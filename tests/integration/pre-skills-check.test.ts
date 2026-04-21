import { describe, test, expect, beforeEach, afterEach } from "bun:test";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const HOOK = join(
  import.meta.dir,
  "../../configs/home-claude/hooks/pre-skills-check.sh",
);
const BLOCK_MARKER = "yka-code PreToolUse block";
const jqAvailable = Bun.which("jq") !== null;

const realUserTurn = (text: string) => ({
  type: "user",
  message: { role: "user", content: text },
});

const skillOutputTurn = (skillText: string) => ({
  type: "user",
  isMeta: true,
  sourceToolUseID: "toolu_test",
  message: { role: "user", content: [{ type: "text", text: skillText }] },
});

const assistantTurn = (content: unknown[]) => ({
  type: "assistant",
  message: { content },
});

const toolUse = (name: string, input: Record<string, unknown> = {}) => ({
  type: "tool_use",
  name,
  input,
});

let sandbox: string;

function writeTranscript(records: object[]): string {
  const path = join(sandbox, `t-${Date.now()}-${Math.random().toString(36).slice(2)}.jsonl`);
  writeFileSync(path, records.map((r) => JSON.stringify(r)).join("\n") + "\n");
  return path;
}

async function runHook(payload: object) {
  const proc = Bun.spawn(["bash", HOOK], {
    stdin: "pipe",
    stdout: "pipe",
    stderr: "pipe",
    env: { ...process.env, HOME: sandbox },
  });
  proc.stdin.write(JSON.stringify(payload));
  await proc.stdin.end();
  const exitCode = await proc.exited;
  const stdout = await new Response(proc.stdout).text();
  const stderr = await new Response(proc.stderr).text();
  return { exitCode, stdout, stderr };
}

describe.skipIf(!jqAvailable)("pre-skills-check.sh", () => {
  beforeEach(() => {
    sandbox = mkdtempSync(join(tmpdir(), "pre-skills-"));
  });
  afterEach(() => {
    rmSync(sandbox, { recursive: true, force: true });
  });

  test("blocks Bash when user turn is a code task and no Skill invoked yet", async () => {
    const transcript = writeTranscript([
      realUserTurn("add a helper function to src/utils.ts"),
    ]);
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(2);
    expect(result.stderr).toContain(BLOCK_MARKER);
  });

  test("blocks Write when user turn is a code task and no Skill invoked yet", async () => {
    const transcript = writeTranscript([
      realUserTurn("fix the bug in src/parser.ts"),
    ]);
    const result = await runHook({
      tool_name: "Write",
      tool_input: { file_path: "/tmp/x", content: "y" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(2);
    expect(result.stderr).toContain(BLOCK_MARKER);
  });

  test("allows Bash when Skill(karpathy-guidelines) already invoked in turn", async () => {
    const transcript = writeTranscript([
      realUserTurn("add a helper function"),
      assistantTurn([toolUse("Skill", { skill: "karpathy-guidelines" })]),
    ]);
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain(BLOCK_MARKER);
  });

  test("allows Bash when Skill(coding-style) already invoked in turn", async () => {
    const transcript = writeTranscript([
      realUserTurn("refactor the logger"),
      assistantTurn([toolUse("Skill", { skill: "coding-style" })]),
    ]);
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
  });

  test("allows non-code-task turn regardless of Skill invocation state", async () => {
    const transcript = writeTranscript([
      realUserTurn("what time is it in Paris"),
    ]);
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "date" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain(BLOCK_MARKER);
  });

  test("allows Read tool call even on code-task turn (Read is exempt)", async () => {
    const transcript = writeTranscript([
      realUserTurn("add a helper function"),
    ]);
    const result = await runHook({
      tool_name: "Read",
      tool_input: { file_path: "/tmp/x" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain(BLOCK_MARKER);
  });

  test("silent-exits when no transcript_path", async () => {
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain(BLOCK_MARKER);
  });

  test("silent-exits when transcript_path points to nonexistent file", async () => {
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      transcript_path: "/tmp/does-not-exist-yka.jsonl",
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
  });

  test("allows Bash across turns once Skills were invoked earlier in session", async () => {
    const transcript = writeTranscript([
      realUserTurn("add helper #1"),
      assistantTurn([toolUse("Skill", { skill: "karpathy-guidelines" })]),
      assistantTurn([toolUse("Skill", { skill: "coding-style" })]),
      assistantTurn([toolUse("Write", { file_path: "/tmp/x", content: "y" })]),
      realUserTurn("now also add helper #2"),
    ]);
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain(BLOCK_MARKER);
  });

  test("allows Bash when Skill invocation is followed by Skill-output isMeta user records (real transcript shape)", async () => {
    const transcript = writeTranscript([
      realUserTurn("add a helper function to src/utils.ts"),
      assistantTurn([toolUse("Skill", { skill: "karpathy-guidelines" })]),
      skillOutputTurn("Base directory for this skill: ~/.claude/skills/karpathy-guidelines\n\n# Karpathy Guidelines\n..."),
      assistantTurn([toolUse("Skill", { skill: "coding-style" })]),
      skillOutputTurn("Base directory for this skill: ~/.claude/skills/coding-style\n\n# Coding style\n..."),
    ]);
    const result = await runHook({
      tool_name: "Bash",
      tool_input: { command: "ls" },
      transcript_path: transcript,
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain(BLOCK_MARKER);
  });
});
