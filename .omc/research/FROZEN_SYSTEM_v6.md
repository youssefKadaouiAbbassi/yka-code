# FROZEN SYSTEM v6 — April 12 2026
# This is the system to compare against independent research.
# 26 components, all free except Claude Max $200/mo.

## Components
1. Claude Code 2.1.101 (kernel, all features: Fast Mode, Advisor Tool, Computer Use, Channels, /ultraplan, defer, Monitor, --bare, apiKeyHelper, Adaptive Thinking)
2. CLAUDE.md symlinked to AGENTS.md + GEMINI.md
3. karanb192 hooks + conditional if + disler/claude-code-damage-control supplement
4. ast-grep MCP + Code Pathfinder MCP
5. Playwright MCP + Playwright CLI (4x token savings)
6. github-mcp-server (remote HTTP)
7. Crawl4AI (Apache-2.0, built-in MCP v0.8)
8. Deepcon (primary, 90% accuracy) + Context7 (fallback, official plugin)
9. Exa (free tier) + Brave Search MCP (backup)
10. CC native auto-memory (/memory) — upgrade to MemPalace for temporal knowledge graph
11. context-mode (98% output compression)
12. E2B Firecracker microVM (primary) + native seccomp (defense-in-depth) + container-use (Docker)
13. kodus-ai (self-hosted cross-vendor review) + Claude Code Review native (backup)
14. ntfy.sh + Channels (--channels plugin:telegram)
15. Native /cost + telemetry + optional claude-code-otel
16. mise + just + devenv 2.0
17. Google Stitch + awesome-design-md
18. LightRAG (upgrade to ApeRAG for production)
19. Obsidian + claude-obsidian (or OMC /wiki skill)
20. OpenHands (walk-away agent)
21. autoresearch (ML research automation)
22. Agent Teams (native) + Paperclip (self-hosted)
23. Activepieces (MIT, MCP-native workflow automation)
24. Native apiKeyHelper (gateway)
25. agentgateway (solo) / ContextForge IBM (team)
26. Ghostty + tmux + git worktrees + chezmoi + age (or Aizen on macOS)

## 15 Principles
1. Verification > generation (reviewer = different model)
2. Hooks 100%, CLAUDE.md 80%
3. Destructive ops need structural gates (3 layers)
4. Plan in markdown, conversation ephemeral
5. 3-5 parallel agents, start with one fewer
6. Compress tool outputs not inputs
7. Max = interactive, API key = CI (enforced April 4)
8. Pin defaults (they drift)
9. Sandbox non-optional (3 layers, E2B primary since seccomp has bypass)
10. Skills portable, harnesses not
11. Spec and code drift — reconcile or stop
12. Native primitives replace plugins
13. Front-load architecture
14. Skill accumulation has diminishing returns
15. AI codebases have no human reader — SBOM mandatory
