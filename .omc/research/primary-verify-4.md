# Primary Source Verification — Batch 4 (Tools 22–31)

Verified: 2026-04-13 | Method: Direct GitHub/official docs fetches

---

## 22. Channels (Claude Code `--channels`)

**Source:** [Official Claude Code Docs — Channels](https://code.claude.com/docs/en/channels) + [Channels Reference](https://code.claude.com/docs/en/channels-reference)

**Verdict: REAL — Official Anthropic feature**

**What it actually is:** A first-party Claude Code feature (not a third-party tool). Channels are MCP servers that push events into a running Claude Code session. The `--channels` flag activates channel plugins per session.

**Quoted from official docs:**
> "A channel is an MCP server that pushes events into your running Claude Code session, so Claude can react to things that happen while you're not at the terminal."

**Supported channel plugins (research preview):**
- **Telegram** — `/plugin install telegram@claude-plugins-official`, then `claude --channels plugin:telegram@claude-plugins-official`
- **Discord** — `/plugin install discord@claude-plugins-official`, then `claude --channels plugin:discord@claude-plugins-official`
- **iMessage** — `/plugin install imessage@claude-plugins-official` (macOS only, reads Messages DB directly)
- **fakechat** — localhost demo for testing

**Key facts:**
- Research preview, requires Claude Code v2.1.80+
- Requires claude.ai login (no API key auth)
- Two-way: Claude reads events AND replies back through the channel
- Sender allowlist security model (pairing flow for Telegram/Discord)
- Permission relay: approve/deny tool use remotely from your phone (v2.1.81+)
- Team/Enterprise must explicitly enable via `channelsEnabled` managed setting
- Custom channels via `--dangerously-load-development-channels`
- Plugins published at [claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins)

**Pricing:** Free (part of Claude Code)

---

## 23. claude-notifications-go

**Source:** [GitHub — 777genius/claude-notifications-go](https://github.com/777genius/claude-notifications-go)

**Verdict: REAL — exists and does bundle multiple backends**

**Quoted from README:**
> "Smart notifications for Claude Code with click-to-focus, git branch display, and webhook integrations."

**What it actually does:**
- 6 notification types: Task Complete, Review Complete, Question, Plan Ready, Session Limit Reached, API Error
- Click-to-focus terminal support (Ghostty, VS Code, iTerm2, Warp, kitty, WezTerm, 7+ others)
- Git branch display in notification title
- Sound control (MP3/WAV/FLAC/OGG/AIFF with volume)
- Multiplexer support: tmux, zellij, WezTerm, kitty

**Does it bundle ntfy + Telegram + Slack?** YES, and more:
> "Slack, Discord, Telegram, Lark/Feishu, Microsoft Teams, ntfy.sh, PagerDuty, Zapier, n8n, Make, custom" — all with "retry, circuit breaker, rate limiting"

**Install:**
```bash
curl -fsSL https://raw.githubusercontent.com/777genius/claude-notifications-go/main/bin/bootstrap.sh | bash
```

**Stars:** 530
**License:** GPL-3.0
**Cross-platform:** macOS (Intel & Apple Silicon), Linux (x64 & ARM64), Windows 10+

---

## 24. ccflare

**Source:** [GitHub — snipeship/ccflare](https://github.com/snipeship/ccflare)

**Verdict: REAL — but it's a Claude API PROXY, not just a "terminal dashboard"**

**Quoted from README:**
> "The ultimate Claude API proxy with intelligent load balancing across multiple accounts. Full visibility into every request, response, and rate limit."

**What it actually does:**
- API proxy server that distributes Claude API requests across multiple accounts
- Interactive TUI (terminal UI) AND web dashboard at `http://localhost:8080/dashboard`
- Session-based load balancing (5-hour conversation contexts)
- Token usage tracking, response time monitoring, cost estimation
- Automatic failover, OAuth token refresh, SQLite persistence
- <10ms overhead claimed

**Install:**
```bash
git clone https://github.com/snipeship/ccflare
cd ccflare
bun install
bun run ccflare
export ANTHROPIC_BASE_URL=http://localhost:8080
```

**Stars:** 942
**License:** MIT
**Also:** A fork exists: [tombii/better-ccflare](https://github.com/tombii/better-ccflare) with extended provider support and Docker deployment

**⚠️ Correction needed:** If previously described as just a "terminal dashboard" — it's primarily an API proxy with load balancing. The dashboard is a monitoring feature, not the main purpose.

---

## 25. autoresearch

**Source:** [GitHub — karpathy/autoresearch](https://github.com/karpathy/autoresearch)

**Verdict: REAL — but NOT Claude Code specific**

**Quoted from README:**
> "give an AI agent a small but real LLM training setup and let it experiment autonomously overnight. It modifies the code, trains for 5 minutes, checks if the result improved, keeps or discards, and repeats."

**What it actually does:** Autonomous ML research — an AI agent modifies training code, runs 5-minute experiments, evaluates improvements, and iterates. You wake up to optimized models and experiment logs.

**Is it Claude Code specific?** NO. From README:
> "Simply spin up your Claude/Codex or whatever you want in this repo."

It's agent-agnostic. Works with Claude Code, Codex, or any AI coding agent.

**Stars:** 71,300 (71.3k) — massive project
**Requirements:** Single NVIDIA GPU, Python 3.10+, `uv` package manager
**License:** MIT

**Install:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv sync
uv run prepare.py
uv run train.py
```

**⚠️ Correction needed:** If previously described as Claude Code specific — it's general-purpose, works with any AI agent.

---

## 26. Google Stitch

**Source:** [Google Blog announcement](https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-ai-ui-design/), [Stitch Skills info](https://cultofclaude.com/agents/stitch-skills/), [Toolworthy](https://www.toolworthy.ai/tool/google-stitch-2-0), [Google Codelabs](https://codelabs.developers.google.com/design-to-code-with-antigravity-stitch)

**Verdict: REAL — DESIGN.md export, MCP, and 7 Skills all confirmed**

**Quoted from Google blog:**
> "an AI-native platform that allows anyone to create, iterate, and collaborate on high-fidelity UI"

**Stitch 2.0 (March 18, 2026) key features:**
- AI-native infinite canvas for multi-screen design (up to 5 screens at once)
- Voice Canvas and "vibe design"
- Interactive prototyping with automatic user journey mapping

**DESIGN.md — CONFIRMED:**
> "A designer generates UI in Stitch, exports DESIGN.md, and a developer's AI coding assistant reads those rules to produce matching frontend code."

DESIGN.md is a natural-language markdown format capturing typography, color tokens, component rules, spacing conventions. Export from any live URL.

**MCP — CONFIRMED:**
> "Stitch now has an official MCP server and SDK, with compatibility with Gemini CLI, Claude Code, and Cursor supported via the Stitch Skills workflow."

**7 Skills — CONFIRMED:**
> "Google has released 7 Agent Skills that extend what Stitch + Antigravity can do together. These follow the Agent Skills open standard and work across Antigravity, Gemini CLI, Claude Code, and Cursor."

**Pricing:** Free at stitch.withgoogle.com (Google account required, no credit card)

---

## 27. awesome-design-md

**Source:** [GitHub — VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md)

**Verdict: REAL**

**Quoted from README:**
> "A collection of DESIGN.md files inspired by popular brand design systems. Drop one into your project and let coding agents generate a matching UI."

**Stars:** 47,200 (47.2k)
**Brand files:** 66 DESIGN.md files across categories (AI platforms, developer tools, fintech, automotive, media)
**Commits:** 31 commits in main branch
**Actively maintained:** Yes, with community contributions encouraged

**Purpose:** Ready-to-use plain-text design system documents that AI coding agents can read to generate consistent, brand-aligned UI without Figma exports.

---

## 28. mise

**Source:** [GitHub — jdx/mise](https://github.com/jdx/mise)

**Verdict: REAL — but the "replaces" claim needs nuance**

**Quoted from README:**
> "The front-end to your dev env" — combines three capabilities:
> - Manages dev tools like node, python, cmake, terraform (similar to asdf)
> - Manages environment variables for project directories (like direnv)
> - Manages build and test tasks (like make)

**Does it replace nvm+pyenv+asdf+direnv+make?** Partially accurate:
- ✅ Replaces asdf (or nvm/pyenv for version management) — "Like asdf (or nvm or pyenv but for any language)"
- ✅ Replaces direnv — "Like direnv" for environment variables
- ✅ Replaces make — "Like make" for project tasks
- ⚠️ It doesn't literally replace all five as separate claims — it's ONE tool that covers the combined functionality

**Stars:** 26,600 (26.6k)

**Install:**
```bash
curl https://mise.run | sh
```
Then hook into your shell with activation command.

---

## 29. just

**Source:** [GitHub — casey/just](https://github.com/casey/just)

**Verdict: REAL**

**Quoted from README:**
> "just is a handy way to save and run project-specific commands."

**What it does:** A command runner with make-like syntax. Stores commands in a `justfile`. Key features:
- Cross-platform support
- Recipe parameters
- Environment variable loading via `.env` files
- Recipes can be written in arbitrary languages
- No `.PHONY` needed (unlike make)
- Simpler than make — focused on running commands, not build system

**Stars:** 32,800 (32.8k)

**Install:**
```bash
cargo install just    # or
brew install just     # macOS
```
Plus 15+ other package manager options (npm, conda, apt, dnf, etc.)

---

## 30. Ghostty

**Source:** [GitHub — ghostty-org/ghostty](https://github.com/ghostty-org/ghostty) (50.6k stars) + [ghostty.org](https://ghostty.org) + [Claude Code terminal docs](https://code.claude.com/docs/en/terminal-config)

**Verdict: REAL — GPU-accelerated confirmed, CC team usage has indirect evidence**

**Quoted from GitHub:**
> "Fast, native, feature-rich terminal emulator that uses platform-native UI and GPU acceleration."

**GPU-accelerated?** YES:
> "Our renderer uses OpenGL on Linux and Metal on macOS."

**Platforms:** macOS (SwiftUI + Metal), Linux (GTK + OpenGL), Windows and WebAssembly (via libghostty)

**Stars:** 50,600 (50.6k)

**Does the CC team actually use it?** The official Claude Code docs mention Ghostty repeatedly as a first-class supported terminal:
- From [terminal-config docs](https://code.claude.com/docs/en/terminal-config): "Shift+Enter: Works out of the box in iTerm2, WezTerm, **Ghostty**, and Kitty"
- Ghostty gets native notification support: "**Kitty and Ghostty** support desktop notifications without additional configuration"
- tmux passthrough example mentions Ghostty: "notifications and the terminal progress bar only reach the outer terminal, such as iTerm2, Kitty, or **Ghostty**"
- claude-notifications-go lists Ghostty as first in click-to-focus terminal support

**⚠️ Nuance:** The official docs don't explicitly say "the CC team uses Ghostty." They do treat it as a first-class terminal alongside iTerm2, Kitty, and WezTerm. Search results suggest the creator of Ghostty (Mitchell Hashimoto) and the Claude Code infrastructure team are in the same ecosystem, but there's no official Anthropic statement saying "our team uses Ghostty."

---

## 31. chezmoi

**Source:** [GitHub — twpayne/chezmoi](https://github.com/twpayne/chezmoi) + [chezmoi.io docs](https://www.chezmoi.io/user-guide/encryption/)

**Verdict: REAL — age encryption CONFIRMED**

**Quoted from GitHub:**
> "Manage your dotfiles across multiple diverse machines, securely."

**Age encryption?** YES. From [official encryption docs](https://www.chezmoi.io/user-guide/encryption/):
> "chezmoi supports encrypting files with age, git-crypt, gpg, and transcrypt."

Encrypted files stored in ASCII-armored format, automatically decrypted when accessed.

**Stars:** 19,100 (19.1k)

**Install:** (from chezmoi.io)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"    # or
brew install chezmoi                      # macOS
```

---

# Summary: What We Got WRONG

| # | Tool | Issue | Severity |
|---|------|-------|----------|
| 22 | Channels | If described as third-party — it's a **first-party Anthropic feature** built into Claude Code. `--channels` is a real CLI flag. | 🟡 Medium |
| 24 | ccflare | If described as "terminal dashboard" — it's primarily an **API proxy with load balancing**. Dashboard is secondary. Stars: 942. | 🟡 Medium |
| 25 | autoresearch | If described as Claude Code specific — it's **general-purpose**, works with any AI agent. Stars 71.3k is correct. | 🟡 Medium |
| 26 | Google Stitch | DESIGN.md, MCP, and 7 Skills are all **confirmed real**. No corrections needed if these were the claims. | ✅ Accurate |
| 27 | awesome-design-md | 47.2k stars, 66 brand files — **confirmed**. | ✅ Accurate |
| 28 | mise | "Replaces nvm+pyenv+asdf+direnv+make" is **roughly correct** but it's one tool covering combined functionality, not a literal 1:1 replacement of each. | 🟢 Minor |
| 30 | Ghostty | "CC team uses it" — **unverified claim**. Official docs treat it as first-class but don't say the team uses it internally. GPU-accelerated is confirmed. | 🟡 Medium |
| 23, 27, 29, 31 | Various | No significant errors found for claude-notifications-go, just, chezmoi. All facts confirmed. | ✅ Accurate |
