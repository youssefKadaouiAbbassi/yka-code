import { $ } from "bun";
import type { DetectedEnvironment, InstallPackage, InstallResult } from "./types.js";
import { commandExists } from "./utils.js";

export const CORE_PLUGINS = [
  "feature-dev",
  "code-review",
  "pr-review-toolkit",
  "commit-commands",
  "claude-code-setup",
  "claude-md-management",
  "frontend-design",
  "skill-creator",
  "session-report",
  "plugin-dev",
] as const;

export const DEV_CLI_PACKAGES: readonly InstallPackage[] = [
  {
    name: "rg",
    displayName: "ripgrep",
    brew: "brew install ripgrep",
    apt: "sudo apt-get install -y ripgrep",
    pacman: "sudo pacman -S --noconfirm ripgrep",
    dnf: "sudo dnf install -y ripgrep",
    cargo: "cargo install ripgrep --locked",
  },
  {
    name: "uv",
    displayName: "uv",
    brew: "brew install uv",
    curl: "curl --connect-timeout 15 --max-time 300 -LsSf https://astral.sh/uv/install.sh | sh",
  },
  {
    name: "bun",
    displayName: "bun",
    brew: "brew install oven-sh/bun/bun",
    curl: "curl --connect-timeout 15 --max-time 300 -fsSL https://bun.sh/install | bash",
  },
];

export function toUpgradeCommand(installCmd: string, pm: string): string {
  if (pm === "brew") {
    const upgradeVariant = installCmd.replace(/\bbrew install\b/g, "brew upgrade");
    return `${upgradeVariant} 2>/dev/null || ${installCmd}`;
  }
  if (pm === "apt") {
    return installCmd
      .replace(/\bapt-get install\b/g, "apt-get install --only-upgrade")
      .replace(/\bapt install\b/g, "apt install --only-upgrade");
  }
  if (pm === "pacman") {
    return installCmd.replace(/\bpacman -S\b/g, "pacman -Syu");
  }
  if (pm === "dnf") {
    return installCmd.replace(/\bdnf install\b/g, "dnf upgrade");
  }
  return installCmd;
}

export async function installBinary(
  pkg: InstallPackage,
  env: DetectedEnvironment,
  dryRun = false
): Promise<InstallResult> {
  const name = pkg.displayName || pkg.name;
  const alreadyPresent = commandExists(pkg.name);

  let cmd: string | undefined;
  switch (env.packageManager) {
    case "brew": cmd = pkg.brew; break;
    case "apt": cmd = pkg.apt; break;
    case "pacman": cmd = pkg.pacman; break;
    case "dnf": cmd = pkg.dnf; break;
  }
  if (!cmd) cmd = pkg.npm ?? pkg.cargo ?? pkg.pip ?? pkg.curl;
  if (!cmd) cmd = pkg.manual;

  if (!cmd) {
    if (alreadyPresent) {
      return { component: name, status: "already-installed", message: `${name} present (no upgrade path for ${env.packageManager})`, verifyPassed: true };
    }
    return { component: name, status: "skipped", message: `No install method for ${name} on ${env.packageManager}`, verifyPassed: false };
  }

  if (alreadyPresent) {
    cmd = toUpgradeCommand(cmd, env.packageManager);
  }

  if (dryRun) {
    const verb = alreadyPresent ? "upgrade" : "install";
    return { component: name, status: "skipped", message: `[dry-run] Would ${verb} ${name}: ${cmd}`, verifyPassed: false };
  }

  try {
    await $`sh -c ${cmd}`;
    const installed = commandExists(pkg.name);
    return {
      component: name,
      status: installed ? "installed" : "failed",
      message: installed
        ? alreadyPresent
          ? `${name} refreshed to latest`
          : `${name} installed successfully`
        : `${name} install command ran but binary not found`,
      verifyPassed: installed,
    };
  } catch (error) {
    return {
      component: name,
      status: "failed",
      message: `Failed to install ${name}: ${error instanceof Error ? error.message : String(error)}`,
      verifyPassed: false,
    };
  }
}
