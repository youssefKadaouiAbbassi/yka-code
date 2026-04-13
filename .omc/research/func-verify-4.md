# Functional Verification Report: Tool Stack Reality Check

**Date:** 2026-04-13
**Method:** Web search for real user experiences, README analysis, community feedback

---

## 1. Google Stitch + DESIGN.md

**Job:** Design-to-code pipeline
**Verdict: KEEP**

**Evidence:**
- Stitch 2.0 (March 2026) ships an MCP Server that connects directly to Claude Code, Cursor, Gemini CLI. No copy-paste HTML needed — design flows automatically to production-ready code.
- DESIGN.md is now an emerging standard: VoltAgent/awesome-design-md has 55+ reverse-engineered design systems ready to drop in. The format captures colors, typography, spacing, component patterns in machine-readable markdown.
- Real workflow: design in Stitch -> Claude reads tokens from DESIGN.md -> consistent UI across codebase. Users report full simple apps in ~30 minutes.
- Google released 7 open-standard skills (stitch-skills) covering the full cycle from design generation to code review.
- MindStudio, FindSkill.ai, and multiple tutorials confirm the pipeline works end-to-end.

**Risk:** Stitch is Google Labs — could be killed. DESIGN.md format itself is portable and vendor-neutral, so the worst case is you lose the generator, not the format.

---

## 2. Obsidian + claude-obsidian (Karpathy LLM Wiki)

**Job:** Persistent, compounding knowledge base
**Verdict: KEEP**

**Evidence:**
- Karpathy's LLM Wiki gist (April 2026) hit 5,000+ stars in days. The core idea — LLM incrementally builds and maintains a structured wiki of interlinked .md files — is validated by wide adoption.
- Multiple implementations exist: claude-obsidian (AgriciDaniel), llm-wiki (MehmetGoekce), Karpathy-LLM-Wiki-Stack (ScrapingArt).
- Eleanor Konik reports Claude + Obsidian + MCP "feels like a big unlock" — writing 2,000 words in 90 minutes with vault context. Another user runs 6 specialized agents with 50+ sub-agents per session, says it "scales beautifully."
- One user drops status updates in Obsidian and Claude "challenges them on what they're working on, connects it to past decisions, spots patterns they miss."

**Caveats:**
- Some Obsidian MCP servers are basic — "only rigid title keyword search." Quality varies by implementation. The MarkusPfundstein/mcp-obsidian and iansinnott/obsidian-claude-code-mcp are the more mature ones.
- Risk of cognitive atrophy if you outsource all organization to AI. Use it as amplifier, not replacement.

---

## 3. Snyk MCP

**Job:** Dependency vulnerability scanning
**Verdict: KEEP**

**Evidence:**
- Official Snyk MCP is first-party, maintained by Snyk themselves (snyk/studio-mcp). Setup is one command: `npx -y snyk@latest mcp configure --tool=claude-cli`.
- Covers SAST, SCA (open-source deps), IaC scanning, and container scanning — full security stack, not just deps.
- Available on all Snyk plans including free tier. Works with Claude Code, Cursor, Copilot, Windsurf.
- Brian Reich documented a real workflow: Snyk finds vulns -> Claude Code auto-fixes them -> validates the fix. Seven-phase workflow from scan to PR.
- Community also built sammcj/mcp-snyk as an alternative.

**No real competitor at this level:** Snyk is the market leader in this space and their MCP is first-party. No better alternative exists for agent-integrated security scanning.

---

## 4. PostgreSQL MCP Pro (crystaldba)

**Job:** Database operations via natural language
**Verdict: KEEP**

**Evidence:**
- 2.5k GitHub stars, 79 commits, actively maintained. Supports Postgres 15-17.
- Goes beyond basic queries: health monitoring, index tuning (using classical optimization algorithms, not just LLM guessing), EXPLAIN plan analysis, hypothetical index simulation.
- Hybrid approach: deterministic tools + classical algorithms + LLM. This means recommendations are grounded, not hallucinated.
- Real user experience: "asked 'which users signed up in the last 7 days?' — got the answer in three seconds from production" with proper JOINs, appropriate indexes, correct date handling.
- Configurable read-only vs read-write access modes for safety.
- Listed on multiple "Best MCP Servers for Claude Code 2026" roundups (EvoMap, AISkillsUp).

**Alternative considered:** Timescale pg-aiguide focuses on Postgres documentation/skills rather than live DB operations — complementary, not a replacement. pgEdge MCP exists but is less mature.

---

## 5. Composio MCP

**Job:** 500+ app integrations in one endpoint
**Verdict: KEEP (with caveats)**

**Evidence FOR:**
- G2 and Product Hunt reviews are positive: "easy to use, easy to implement," "issues resolved within few hours," "straightforward, reliable."
- SOC2 and ISO compliant. 30% more accuracy on function-calling vs raw MCP.
- Real user built a complete invoice management MVP in one day using Composio + Claude Code.
- Single MCP URL for multiple apps with zero auth hassles — the value prop is real.
- Tools are tuned using real error and success rates to improve reliability over time.

**Evidence AGAINST (the broader MCP ecosystem, not Composio-specific):**
- MCP in production is "rarely clean" — credential management, permission enforcement, silent failures.
- Garry Tan (YC) criticized MCP for context window consumption and poor auth UX.
- 2026 scanning found 1,862 exposed MCP servers with zero auth. Supply chain risks with unsanitized packages.

**Bottom line:** Composio itself is reliable for the integrations it supports well. Don't expect all 500+ to work perfectly — the popular ones (GitHub, Slack, Google, Linear) will be solid; long-tail integrations may be brittle. The "one URL, many apps" value prop is genuine and saves significant setup time vs individual MCP servers.

---

## 6. mise + just

**Job:** Reproducible build loop / task runner
**Verdict: KEEP**

**Evidence:**
- `just` has a dedicated Claude Code skill ecosystem: justfile-expert skill, just-mcp server (toolprint/just-mcp), and multiple Claude plugins.
- just-mcp reduces context waste — AI doesn't need to read the full justfile, it discovers recipes through MCP.
- `Bash(just *)` matches any target in your Justfile — you can approve broad categories of safe commands without listing every invocation. Clean permission model for Claude Code.
- mise manages tool versions and can bootstrap Claude Code installation on new machines. A mise-guide skill exists to teach AI agents proper mise usage.
- Used together: mise handles environment/versions, just handles task recipes. Claude Code reads the justfile for available commands.

**Caveat:** No strong evidence of people using mise + just *together* as an integrated system specifically with Claude Code. They're both independently useful, and the combination is logical, but it's more "good tools that compose well" than "proven integrated workflow."

---

## 7. autoresearch

**Job:** Autonomous ML experiments overnight
**Verdict: KEEP**

**Evidence — this one is a slam dunk:**
- Karpathy's original run: 700 experiments in 2 days, found 20 genuine improvements, 11% speedup on already-optimized GPT-2 training code (2.02h -> 1.80h). One finding: QK-Norm was missing a scalar multiplier.
- 25,000 GitHub stars in 5 days.
- **Shopify CEO Tobi Lutke's results:** 19% improvement in model quality after 37 experiments in 8 hours. Then applied to Liquid templating engine: **53% faster rendering, 61% fewer memory allocations** from 93 automated commits. This is production code, not toy benchmarks.
- Red Hat ran 198 experiments on OpenShift AI with zero intervention.
- SkyPilot scaled it to 16 GPUs on Kubernetes: ~910 experiments in 8 hours, drove val_bpb from 1.003 to 0.974.
- Hyperspace network: 35 autonomous agents ran 333 experiments completely unsupervised.
- ~12 experiments/hour, so 8-hour overnight = ~100 experiments. Real improvements, not GPU waste.

**The pattern generalizes:** Lutke's Liquid results prove it's not just for ML training — any codebase with a measurable metric can benefit.

---

## Summary Table

| Tool | Verdict | Confidence | Notes |
|------|---------|------------|-------|
| Google Stitch + DESIGN.md | **KEEP** | High | MCP integration works, format is becoming a standard. Google Labs risk. |
| Obsidian + claude-obsidian | **KEEP** | High | Wiki compounds over time. Pick a mature MCP server. |
| Snyk MCP | **KEEP** | High | First-party, full security stack, free tier. No real competitor. |
| PostgreSQL MCP Pro | **KEEP** | High | 2.5k stars, hybrid algo approach, actively maintained. |
| Composio MCP | **KEEP** | Medium | Popular integrations work well. Long-tail may be brittle. |
| mise + just | **KEEP** | Medium | Both independently good. Combined workflow is logical but not widely proven as a unit. |
| autoresearch | **KEEP** | Very High | Shopify production results (53% faster Liquid). Proven at scale. Slam dunk. |

**Overall: 7/7 KEEP. No CUTs, no SWAPs needed.** This is a strong toolset. The weakest links are Composio (long-tail integration quality) and mise+just (unproven as integrated pair), but neither warrants cutting or swapping.
