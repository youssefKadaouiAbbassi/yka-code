import { describe, test, expect, beforeEach, afterEach } from "bun:test";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const HOOK = join(
  import.meta.dir,
  "../../configs/home-claude/hooks/user-prompt-skill-primer.sh",
);
const jqAvailable = Bun.which("jq") !== null;

const realUserTurn = (text: string) => ({
  type: "user",
  message: { role: "user", content: text },
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

function parseInjection(stdout: string): string | null {
  if (!stdout.trim()) return null;
  try {
    const parsed = JSON.parse(stdout.trim());
    return parsed?.hookSpecificOutput?.additionalContext ?? null;
  } catch {
    return null;
  }
}

describe.skipIf(!jqAvailable)("user-prompt-skill-primer.sh", () => {
  beforeEach(() => {
    sandbox = mkdtempSync(join(tmpdir(), "primer-"));
  });
  afterEach(() => {
    rmSync(sandbox, { recursive: true, force: true });
  });

  test("silent on non-code prompt", async () => {
    const result = await runHook({ prompt: "what time is it", session_id: "s" });
    expect(result.exitCode).toBe(0);
    expect(parseInjection(result.stdout)).toBeNull();
  });

  test("silent on empty prompt", async () => {
    const result = await runHook({ prompt: "", session_id: "s" });
    expect(result.exitCode).toBe(0);
    expect(parseInjection(result.stdout)).toBeNull();
  });

  test("emits base directive on trivial code prompt, no /do, no TDD", async () => {
    const result = await runHook({ prompt: "add a helper function foo()", session_id: "s" });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).toContain("karpathy-guidelines");
    expect(text).toContain("coding-style");
    expect(text).toContain("verification-before-completion");
    expect(text).not.toContain('Skill(skill: "do")');
    expect(text).not.toContain('Skill(skill: "test-driven-development")');
  });

  test("adds /do + TDD for correctness-critical prompt (class + infrastructure)", async () => {
    const result = await runHook({
      prompt: "implement a TokenBucket rate limiter class, correctness-critical infrastructure code",
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).toContain("karpathy-guidelines");
    expect(text).toContain("coding-style");
    expect(text).toContain('Skill(skill: "do")');
    expect(text).toContain('Skill(skill: "test-driven-development")');
  });

  test("adds /do but no TDD for multi-file refactor without correctness trigger", async () => {
    const result = await runHook({ prompt: "refactor the logger across modules", session_id: "s" });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).toContain('Skill(skill: "do")');
    expect(text).not.toContain('Skill(skill: "test-driven-development")');
  });

  test("adds TDD on bug-fix prompt with regression/bug/crash trigger", async () => {
    const result = await runHook({ prompt: "fix the bug where the parser crashes on empty input", session_id: "s" });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).toContain('Skill(skill: "test-driven-development")');
  });

  test("Block A skipped when Skills loaded session-wide, Block B still emits done-gate", async () => {
    const transcript = writeTranscript([
      realUserTurn("add helper #1"),
      assistantTurn([toolUse("Skill", { skill: "karpathy-guidelines" })]),
      assistantTurn([toolUse("Skill", { skill: "coding-style" })]),
      assistantTurn([toolUse("Write", { file_path: "/tmp/x", content: "y" })]),
    ]);
    const result = await runHook({
      prompt: "now also add helper #2",
      session_id: "s",
      transcript_path: transcript,
    });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).not.toContain("Base pair (load once per session)");
    expect(text).toContain("Per-turn task-shape reminders");
    expect(text).toContain("verification-before-completion");
  });

  test("Block B includes plan-first (multi-file) for cross-module refactor even when base pair loaded", async () => {
    const transcript = writeTranscript([
      realUserTurn("earlier task"),
      assistantTurn([toolUse("Skill", { skill: "karpathy-guidelines" })]),
      assistantTurn([toolUse("Skill", { skill: "coding-style" })]),
    ]);
    const result = await runHook({
      prompt: "now refactor the logger across modules",
      session_id: "s",
      transcript_path: transcript,
    });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).not.toContain("Base pair (load once per session)");
    expect(text).toContain("Plan first");
    expect(text).toContain("EnterPlanMode");
    expect(text).toContain('Skill(skill: "do")');
    expect(text).toContain('Skill(skill: "verification-before-completion")');
  });

  test("Block B uses brainstorming nudge when prompt is fuzzy-scope", async () => {
    const result = await runHook({
      prompt: "I am thinking about refactoring the auth module, not sure yet",
      session_id: "s",
    });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).toContain("scope is fuzzy");
    expect(text).toContain('Skill(skill: "brainstorming")');
    expect(text).toContain("EnterPlanMode");
  });

  test("Block B includes TDD even when base pair already loaded", async () => {
    const transcript = writeTranscript([
      realUserTurn("earlier task"),
      assistantTurn([toolUse("Skill", { skill: "karpathy-guidelines" })]),
      assistantTurn([toolUse("Skill", { skill: "coding-style" })]),
    ]);
    const result = await runHook({
      prompt: "implement a TokenBucket rate limiter class, correctness-critical infrastructure code",
      session_id: "s",
      transcript_path: transcript,
    });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).not.toContain("Base pair (load once per session)");
    expect(text).toContain('Skill(skill: "test-driven-development")');
    expect(text).toContain('Skill(skill: "verification-before-completion")');
  });

  test("emits directive when transcript exists but has no prior Skill invocations", async () => {
    const transcript = writeTranscript([
      realUserTurn("add helper"),
      assistantTurn([toolUse("Read", { file_path: "/tmp/x" })]),
    ]);
    const result = await runHook({
      prompt: "add a new helper function",
      session_id: "s",
      transcript_path: transcript,
    });
    expect(result.exitCode).toBe(0);
    const text = parseInjection(result.stdout);
    expect(text).not.toBeNull();
    expect(text).toContain("karpathy-guidelines");
  });
});
