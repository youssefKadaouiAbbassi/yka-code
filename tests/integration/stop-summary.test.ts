import { describe, test, expect, beforeEach, afterEach } from "bun:test";
import { mkdtempSync, rmSync, writeFileSync, mkdirSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const HOOK = join(
  import.meta.dir,
  "../../configs/home-claude/hooks/stop-summary.sh",
);
const jqAvailable = Bun.which("jq") !== null;

let sandbox: string;

beforeEach(() => {
  sandbox = mkdtempSync(join(tmpdir(), "stop-summary-"));
  mkdirSync(join(sandbox, ".git"), { recursive: true });
});

afterEach(() => {
  rmSync(sandbox, { recursive: true, force: true });
});

async function runHook(payload: object, cwd: string) {
  const proc = Bun.spawn(["bash", HOOK], {
    stdin: "pipe",
    stdout: "pipe",
    stderr: "pipe",
    cwd,
    env: { ...process.env, HOME: mkdtempSync(join(tmpdir(), "home-")) },
  });
  proc.stdin.write(JSON.stringify(payload));
  await proc.stdin.end();
  const start = Date.now();
  const exitCode = await proc.exited;
  const duration = Date.now() - start;
  const stdout = await new Response(proc.stdout).text();
  const stderr = await new Response(proc.stderr).text();
  return { exitCode, duration, stdout, stderr };
}

describe.skipIf(!jqAvailable)("stop-summary.sh", () => {
  test("exits <4s on a sandbox with 500 recent files (no hang)", async () => {
    for (let i = 0; i < 500; i++) {
      writeFileSync(join(sandbox, `f${i}.ts`), `export const n${i} = ${i};\n`);
    }
    const result = await runHook(
      { transcript_path: "/tmp/none", session_id: "s", stop_hook_active: false },
      sandbox,
    );
    expect(result.exitCode).toBe(0);
    expect(result.duration).toBeLessThan(4000);
  });

  test("detects console.log in a recent file and emits advisory", async () => {
    writeFileSync(join(sandbox, "a.ts"), "console.log('debug');\nexport const n = 1;\n");
    const result = await runHook(
      { transcript_path: "/tmp/none", session_id: "s", stop_hook_active: false },
      sandbox,
    );
    expect(result.exitCode).toBe(0);
    expect(result.stderr).toContain("Stop Hook Advisory");
    expect(result.stderr).toContain("a.ts");
  });

  test("silent when no debug patterns in recent files", async () => {
    writeFileSync(join(sandbox, "clean.ts"), "export const n = 1;\n");
    const result = await runHook(
      { transcript_path: "/tmp/none", session_id: "s", stop_hook_active: false },
      sandbox,
    );
    expect(result.exitCode).toBe(0);
    expect(result.stderr).not.toContain("Stop Hook Advisory");
  });

  test("caps file scan at MAX_FILES (doesn't attempt to grep thousands)", async () => {
    for (let i = 0; i < 2000; i++) {
      writeFileSync(join(sandbox, `big${i}.ts`), `export const n${i} = ${i};\n`);
    }
    const result = await runHook(
      { transcript_path: "/tmp/none", session_id: "s", stop_hook_active: false },
      sandbox,
    );
    expect(result.exitCode).toBe(0);
    expect(result.duration).toBeLessThan(4000);
  });
});
