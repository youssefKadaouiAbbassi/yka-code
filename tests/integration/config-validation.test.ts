import { describe, test, expect } from "bun:test";
import { join } from "node:path";
import { Glob } from "bun";

const CONFIGS_DIR = join(import.meta.dir, "../../configs");

describe("Config validation", () => {
  test("home settings.json is valid JSON", async () => {
    const data = await Bun.file(
      join(CONFIGS_DIR, "home-claude/settings.json")
    ).json();
    expect(data).toBeTruthy();
  });

  test("home settings.json has 40+ deny rules", async () => {
    const data = (await Bun.file(
      join(CONFIGS_DIR, "home-claude/settings.json")
    ).json()) as { permissions: { deny: string[] } };
    expect(data.permissions.deny.length).toBeGreaterThanOrEqual(40);
  });

  test("home settings.json does NOT pin a model (preserves user default)", async () => {
    const data = (await Bun.file(
      join(CONFIGS_DIR, "home-claude/settings.json")
    ).json()) as { model?: string };
    expect(data.model).toBeUndefined();
  });

  test("project settings.json is valid JSON with fewer deny rules than home", async () => {
    const home = (await Bun.file(
      join(CONFIGS_DIR, "home-claude/settings.json")
    ).json()) as { permissions: { deny: string[] } };
    const project = (await Bun.file(
      join(CONFIGS_DIR, "project-claude/settings.json")
    ).json()) as { permissions: { deny: string[] } };
    expect(project.permissions.deny.length).toBeLessThan(home.permissions.deny.length);
    expect(project.permissions.deny.length).toBeGreaterThan(0);
  });

  test("home CLAUDE.md is under 120 lines", async () => {
    const text = await Bun.file(
      join(CONFIGS_DIR, "home-claude/CLAUDE.md")
    ).text();
    const lineCount = text.trim().split("\n").length;
    expect(lineCount).toBeLessThan(120);
  });

  test("project CLAUDE.md is a thin template (under 50 lines)", async () => {
    const text = await Bun.file(
      join(CONFIGS_DIR, "project-claude/CLAUDE.md")
    ).text();
    const lineCount = text.trim().split("\n").length;
    expect(lineCount).toBeLessThan(50);
  });

  test("all hooks have correct shebang", async () => {
    const hookDirs = [
      join(CONFIGS_DIR, "home-claude/hooks"),
      join(CONFIGS_DIR, "project-claude/hooks"),
    ];
    for (const dir of hookDirs) {
      const glob = new Glob("*.sh");
      for await (const file of glob.scan(dir)) {
        if (file.startsWith("_")) continue;
        const text = await Bun.file(join(dir, file)).text();
        const firstLine = text.split("\n")[0];
        expect(firstLine).toBe("#!/usr/bin/env bash");
      }
    }
  });

  test("all hooks set errexit (either `set -euo pipefail` or `set -u` with trap)", async () => {
    const hookDirs = [
      join(CONFIGS_DIR, "home-claude/hooks"),
      join(CONFIGS_DIR, "project-claude/hooks"),
    ];
    for (const dir of hookDirs) {
      const glob = new Glob("*.sh");
      for await (const file of glob.scan(dir)) {
        if (file.startsWith("_")) continue;
        const text = await Bun.file(join(dir, file)).text();
        const strict =
          text.includes("set -euo pipefail") ||
          (text.includes("set -u") && text.includes("trap 'exit 0' ERR"));
        expect(strict).toBe(true);
      }
    }
  });

  test("tmux.conf has Ctrl-A prefix", async () => {
    const text = await Bun.file(join(CONFIGS_DIR, "tmux.conf")).text();
    expect(text).toMatch(/set\s+-g\s+prefix\s+C-a/);
  });

  test("starship.toml exists and is non-empty", async () => {
    const file = Bun.file(join(CONFIGS_DIR, "starship.toml"));
    const text = await file.text();
    expect(text.trim().length).toBeGreaterThan(0);
  });

  test("starship.toml escapes literal $ in git_status.stashed", async () => {
    const text = await Bun.file(join(CONFIGS_DIR, "starship.toml")).text();
    const stashedLine = text
      .split("\n")
      .find((line) => /^\s*stashed\s*=/.test(line));
    expect(stashedLine).toBeDefined();
    expect(stashedLine).toMatch(/stashed\s*=\s*'\\\$'/);
  });

  const starshipAvailable = Bun.which("starship") !== null;

  test.skipIf(!starshipAvailable)(
    "starship parses starship.toml with no format-string warnings",
    async () => {
      const configPath = join(CONFIGS_DIR, "starship.toml");
      const repoRoot = join(CONFIGS_DIR, "..");
      const proc = Bun.spawn(["starship", "prompt"], {
        cwd: repoRoot,
        env: { ...process.env, STARSHIP_CONFIG: configPath },
        stdout: "pipe",
        stderr: "pipe",
      });
      await proc.exited;
      const stderr = await new Response(proc.stderr).text();
      expect(stderr).not.toMatch(/\[WARN\]/);
      expect(stderr).not.toMatch(/Error parsing format string/);
    },
  );

  test("config tree contains both home-claude and project-claude template dirs", async () => {
    const homeSettings = Bun.file(join(CONFIGS_DIR, "home-claude/settings.json"));
    const projectSettings = Bun.file(join(CONFIGS_DIR, "project-claude/settings.json"));
    expect(await homeSettings.exists()).toBe(true);
    expect(await projectSettings.exists()).toBe(true);
  });
});
