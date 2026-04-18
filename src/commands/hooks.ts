import { defineCommand } from "citty";
import { promises as fs } from "node:fs";
import { join } from "node:path";
import pc from "picocolors";
import { log } from "../utils.js";
import { HOOK_REGISTRATIONS } from "../hook-registry.js";

function stateFilePath(): string {
  const home = process.env.HOME ?? "";
  return join(home, ".claude", "yka-hooks-disabled");
}

async function readDisabledSet(): Promise<Set<string>> {
  try {
    const text = await fs.readFile(stateFilePath(), "utf-8");
    return new Set(
      text
        .split("\n")
        .map((l) => l.replace(/#.*$/, "").trim())
        .filter((l) => l.length > 0),
    );
  } catch {
    return new Set();
  }
}

async function writeDisabledSet(set: Set<string>): Promise<void> {
  const path = stateFilePath();
  if (set.size === 0) {
    try { await fs.unlink(path); } catch { /* ignore */ }
    return;
  }
  const body = [
    "# yka-code hooks disabled state — managed by `yka-code-setup hooks`",
    "# One hook name per line. Use 'all' to disable every hook.",
    "",
    ...[...set].sort(),
    "",
  ].join("\n");
  await fs.mkdir(join(process.env.HOME ?? "", ".claude"), { recursive: true });
  await fs.writeFile(path, body);
}

function allHookNames(): string[] {
  return HOOK_REGISTRATIONS.map((r) => r.file.replace(/\.sh$/, "")).sort();
}

function validateName(name: string): string | null {
  if (name === "all") return null;
  const known = new Set(allHookNames());
  if (!known.has(name)) return `Unknown hook: "${name}". Known: ${allHookNames().join(", ")}`;
  return null;
}

const listCmd = defineCommand({
  meta: { name: "list", description: "Show which yka-code hooks are enabled vs disabled" },
  async run() {
    const disabled = await readDisabledSet();
    const envBypass = (process.env.YKA_HOOKS_BYPASS ?? "")
      .split(",").map((s) => s.trim()).filter(Boolean);
    const envAll = envBypass.includes("all");

    const rows = allHookNames().map((name) => {
      const fileDisabled = disabled.has("all") || disabled.has(name);
      const envDisabled = envAll || envBypass.includes(name);
      const state = fileDisabled || envDisabled ? pc.red("disabled") : pc.green("enabled");
      const reason = [fileDisabled && "state-file", envDisabled && "YKA_HOOKS_BYPASS"]
        .filter(Boolean).join(", ");
      return `  ${state.padEnd(18)} ${pc.bold(name)}${reason ? pc.dim(` (${reason})`) : ""}`;
    });

    console.log(pc.bold("yka-code hooks:"));
    console.log(rows.join("\n"));
    console.log("");
    console.log(pc.dim(`State file: ${stateFilePath()}`));
    if (envBypass.length > 0) {
      console.log(pc.dim(`YKA_HOOKS_BYPASS: ${envBypass.join(",")}`));
    }
  },
});

const disableCmd = defineCommand({
  meta: { name: "disable", description: "Disable a hook (persistent until `enable`). Use 'all' to disable every hook." },
  args: {
    name: { type: "positional", required: true, description: "Hook name (e.g., pre-pr-gate) or 'all'" },
  },
  async run({ args }) {
    const name = String(args.name);
    const err = validateName(name);
    if (err) { log.error(err); process.exit(1); }

    const disabled = await readDisabledSet();
    if (name === "all") {
      disabled.clear();
      disabled.add("all");
    } else {
      disabled.add(name);
    }
    await writeDisabledSet(disabled);
    log.success(`Disabled: ${pc.bold(name)}`);
    log.info(`One-shot alternative: ${pc.cyan(`YKA_HOOKS_BYPASS=${name} <your-command>`)}`);
    log.info(`Re-enable with: ${pc.cyan(`yka-code-setup hooks enable ${name}`)}`);
  },
});

const enableCmd = defineCommand({
  meta: { name: "enable", description: "Re-enable a hook. Use 'all' to clear the entire disable list." },
  args: {
    name: { type: "positional", required: true, description: "Hook name or 'all'" },
  },
  async run({ args }) {
    const name = String(args.name);
    const err = validateName(name);
    if (err) { log.error(err); process.exit(1); }

    const disabled = await readDisabledSet();
    if (name === "all") {
      disabled.clear();
    } else {
      disabled.delete(name);
      disabled.delete("all");
    }
    await writeDisabledSet(disabled);
    log.success(`Enabled: ${pc.bold(name)}`);
  },
});

export default defineCommand({
  meta: { name: "hooks", description: "Enable / disable yka-code hooks (list, disable, enable)" },
  subCommands: {
    list: listCmd,
    disable: disableCmd,
    enable: enableCmd,
  },
  async run() {
    console.log("Usage: yka-code-setup hooks <list|disable|enable> [name]");
    console.log("");
    console.log("Examples:");
    console.log("  yka-code-setup hooks list");
    console.log("  yka-code-setup hooks disable pre-pr-gate");
    console.log("  yka-code-setup hooks enable pre-pr-gate");
    console.log("  yka-code-setup hooks disable all");
    console.log("");
    console.log("One-shot bypass (no state change):");
    console.log("  YKA_HOOKS_BYPASS=pre-pr-gate git push origin master");
  },
});
