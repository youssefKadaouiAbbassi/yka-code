import { describe, test, expect, beforeEach, afterEach } from "bun:test";
import { mkdtempSync, rmSync, writeFileSync, readFileSync, existsSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { installCore } from "../../src/core.js";
import type { DetectedEnvironment } from "../../src/types.js";

function fakeEnv(homeDir: string): DetectedEnvironment {
  return {
    os: "linux",
    arch: "x64",
    shell: "bash",
    shellRcPath: join(homeDir, ".bashrc"),
    packageManager: "apt",
    homeDir,
    claudeDir: join(homeDir, ".claude"),
    existingTools: new Map(),
    dockerAvailable: false,
  };
}

let sandboxHome: string;

beforeEach(() => {
  sandboxHome = mkdtempSync(join(tmpdir(), "tmux-focus-"));
});

afterEach(() => {
  rmSync(sandboxHome, { recursive: true, force: true });
});

describe("ensureTmuxFocusEvents", () => {
  test("dry-run reports would-create when tmux.conf is absent", async () => {
    const env = fakeEnv(sandboxHome);
    const results = await installCore(env, true, undefined);
    const tmuxFocus = (results as Array<{ component: string; message?: string }>).find((r) => r.component === "tmux-focus-events");
    expect(tmuxFocus).toBeDefined();
    expect(tmuxFocus?.message).toContain("[dry-run]");
  });

  test("dry-run does not write the file", async () => {
    const env = fakeEnv(sandboxHome);
    await installCore(env, true, undefined);
    expect(existsSync(join(sandboxHome, ".tmux.conf"))).toBe(false);
  });

  test("(behavior-only, no write) recognises 'set -g focus-events on' as already present", async () => {
    const tmuxConf = join(sandboxHome, ".tmux.conf");
    writeFileSync(tmuxConf, "set -g mouse on\nset -g focus-events on\n");
    const env = fakeEnv(sandboxHome);
    const results = await installCore(env, true, undefined);
    const tmuxFocus = (results as Array<{ component: string; message?: string }>).find((r) => r.component === "tmux-focus-events");
    expect(tmuxFocus?.message).toContain("[dry-run]");
    const text = readFileSync(tmuxConf, "utf-8");
    expect(text).not.toContain("yka-code-managed");
  });
});
