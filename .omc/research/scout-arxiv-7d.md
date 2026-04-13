# ArXiv Scout Report: April 4–11, 2026
**Generated:** 2026-04-11  
**Categories scanned:** cs.AI, cs.SE, cs.LG, cs.CR  
**Window:** 2026-04-04 → 2026-04-11  
**Existing corpus (skipped):** 2604.04978, 2604.02947, 2604.03081, 2604.04979, 2602.14690

---

## Papers Found (15)

---

### 1. arxiv:2604.07551
**Title:** MCP-DPT: A Defense-Placement Taxonomy and Coverage Analysis for Model Context Protocol Security  
**Authors:** Mehrdad Rostamzadeh, Sidhant Narula, Nahom Birhan et al.  
**Date:** April 8, 2026  
**Category:** cs.CR  
**Abstract excerpt:** "many MCP security weaknesses stem from architectural misalignment rather than isolated implementation flaws," with defense gaps particularly evident at the host orchestration, transport, and supply-chain layers. The paper presents a layer-aligned taxonomy organizing attacks by the architectural component responsible for enforcement, mapping threats across six MCP layers.  
**One-sentence summary:** Presents a defense-placement taxonomy across six MCP architectural layers, finding that most existing defenses target the wrong layer and that host-orchestration and supply-chain layers are the least protected.  
**Blueprint relevance:** Updates §2 MCP/plugin security slot — the layered-defense argument must specify which of the six MCP layers each control sits at; host-orchestration gap directly affects Claude Code's tool-invocation path.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.07551

---

### 2. arxiv:2604.05969
**Title:** A Formal Security Framework for MCP-Based AI Agents: Threat Taxonomy, Verification Models, and Defense Mechanisms  
**Authors:** Nirajan Acharya, Gaurav Kumar Gupta  
**Date:** April 7, 2026  
**Category:** cs.CR  
**Abstract excerpt:** MCPSHIELD provides "a hierarchical threat taxonomy with 23 attack vectors across four surfaces" and "a formal verification model using labeled transition systems." Their integrated approach "achieves theoretical coverage of 91 percent" of identified threats, compared to existing defenses covering "no more than 34 percent" individually. Analysis covers over 177,000 MCP tools.  
**One-sentence summary:** MCPSHIELD formalizes 23 MCP attack vectors across four surfaces using labeled transition systems, demonstrating that current single-layer defenses cover at most 34% of threats while the proposed integrated architecture reaches 91%.  
**Blueprint relevance:** Directly quantifies the coverage gap in any single-layer MCP defense; the 34% ceiling on point-solutions is a hard empirical constraint on Principle 9 (layered-defense) — a single sandbox layer is provably insufficient.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.05969

---

### 3. arxiv:2604.04426
**Title:** ShieldNet: Network-Level Guardrails against Emerging Supply-Chain Injections in Agentic Systems  
**Authors:** Zhuowen Yuan, Zhaorun Chen, Zhen Xiang, Nathaniel D. Bastian et al.  
**Date:** April 6, 2026  
**Category:** cs.CR / cs.AI  
**Abstract excerpt:** "a new class of supply-chain threats has emerged, where malicious behaviors are embedded in seemingly benign tools, silently hijacking agent execution, leaking sensitive data, or triggering unauthorized actions." ShieldNet achieves "strong detection performance (up to 0.995 F-1 with only 0.8% false positives) while introducing little runtime overhead." Evaluated against SC-Inject-Bench with over 10,000 malicious MCP tools.  
**One-sentence summary:** Proposes network-level behavioral monitoring (rather than static tool inspection) to detect supply-chain-poisoned MCP tools, achieving F1=0.995 on a 10,000+ tool benchmark.  
**Blueprint relevance:** Introduces a new detection layer (network traffic observation) absent from most Claude Code security blueprints; this is a concrete add to the sandbox/isolation principle — runtime network monitoring catches what pre-execution analysis misses.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.04426

---

### 4. arxiv:2604.03679
**Title:** LightThinker++: From Reasoning Compression to Memory Management  
**Authors:** Yuqi Zhu, Jintian Zhang, Zhenjie Wan, Yujie Luo, Shuofei Qiao et al.  
**Date:** April 4, 2026  
**Category:** cs.LG / cs.AI  
**Abstract excerpt:** The framework "enables LLMs to dynamically compress intermediate thoughts into compact semantic representations" with explicit adaptive memory primitives. Key results: "70% reduction in peak token usage and 26% faster inference" plus "stable resource footprints across 80+ rounds" on extended reasoning tasks.  
**One-sentence summary:** Introduces adaptive in-context memory management that compresses intermediate reasoning steps dynamically, cutting peak token usage 70% and sustaining stable performance across 80+ reasoning rounds.  
**Blueprint relevance:** Directly applicable to Claude Code's context-window pressure in long sessions; the 80-round stability claim is the first empirical bound on how far dynamic compression can extend long-horizon coding tasks without degradation.  
**Code/repo:** None linked at submission time.  
**Source:** https://arxiv.org/abs/2604.03679

---

### 5. arxiv:2604.04804
**Title:** SkillX: Automatically Constructing Skill Knowledge Bases for Agents  
**Authors:** Chenxi Wang, Zhuoyun Yu, Xin Xie, Wuguannan Yao, Runnan Fang et al.  
**Date:** April 6, 2026  
**Category:** cs.AI  
**Abstract excerpt:** A fully automated pipeline built on "hierarchical skill design, iterative refinement based on execution feedback, and proactive skill expansion." Tested on AppWorld and BFCL-v3, the skill library improves performance when integrated into weaker agents.  
**One-sentence summary:** Automates the construction and continuous expansion of reusable agent skill libraries through execution-feedback-driven hierarchical refinement, improving weaker agents on AppWorld and BFCL-v3.  
**Blueprint relevance:** Directly relevant to Ralph-style self-improvement loop; the hierarchical skill KB architecture is a concrete implementation pattern for the skill-accumulation slot, and the "proactive expansion" loop is an empirical self-improvement mechanism.  
**Code/repo:** https://github.com/zjunlp/SkillX (announced as "coming soon" at submission)  
**Source:** https://arxiv.org/abs/2604.04804

---

### 6. arxiv:2604.04347
**Title:** RoboPhD: Evolving Diverse Complex Agents Under Tight Evaluation Budgets  
**Authors:** Andrew Borthwick, Stephen Ash, Anthony Galczak  
**Date:** April 5–6, 2026  
**Category:** cs.AI  
**Abstract excerpt:** "RoboPhD introduces validation-free evolution: instead of splitting the budget between training and validation, it uses Elo competition on training data to simultaneously evaluate agents and drive evolution." On ARC-AGI, the method "evolves a 22-line seed agent into a 1,013-line multi-strategy system, improving accuracy from 27.8% to 65.8%." Tested on four benchmarks with a 1,500 evaluation budget. Released as MIT-licensed toolkit with `optimize_anything()` API.  
**One-sentence summary:** Validation-free Elo-competition-based evolution grows a 22-line agent to 1,013 lines with a 38-point accuracy gain on ARC-AGI using only 1,500 evaluations, released as a plug-in toolkit.  
**Blueprint relevance:** Strongest empirical result this week on self-improving agents; the `optimize_anything()` API is a candidate primitive for the self-improvement loop principle. The Elo-without-validation design removes the evaluation-budget bottleneck identified in prior work.  
**Code/repo:** Released under MIT license (toolkit name RoboPhD, no repo URL in abstract page).  
**Source:** https://arxiv.org/abs/2604.04347

---

### 7. arxiv:2604.04323
**Title:** How Well Do Agentic Skills Work in the Wild: Benchmarking LLM Skill Usage in Realistic Settings  
**Authors:** Yujian Liu, Jiabao Ji, Li An, Tommi Jaakkola, Yang Zhang, Shiyu Chang  
**Date:** April 6, 2026  
**Category:** cs.AI / cs.SE  
**Abstract excerpt:** "performance gains degrade consistently as settings become more realistic, with pass rates approaching no-skill baselines in the most challenging scenarios." Testing against 34,000 real-world skills. Query-specific refinement "substantially recovers lost performance when the initial skills are of reasonable relevance and quality." Claude Opus 4.6 on Terminal-Bench 2.0 improved from 57.7% to 65.5% with skill retrieval.  
**One-sentence summary:** A 34,000-skill realistic benchmark shows that skill-retrieval gains collapse to near-zero in the hardest scenarios, but query-specific skill refinement partially rescues performance (Claude Opus 4.6: 57.7% → 65.5%).  
**Blueprint relevance:** Provides the first large-scale empirical ceiling on skill-library benefits in realistic conditions; the near-zero gain in hard scenarios is a direct constraint on how much any skill-KB mechanism can deliver without query-adaptive refinement.  
**Code/repo:** https://github.com/UCSB-NLP-Chang/Skill-Usage  
**Source:** https://arxiv.org/abs/2604.04323

---

### 8. arxiv:2604.05013
**Title:** Scaling Coding Agents via Atomic Skills  
**Authors:** Yingwei Ma, Yue Liu, Xinlong Yang, Yanhao Li, Kelin Fu et al.  
**Date:** April 6, 2026  
**Category:** cs.SE / cs.AI  
**Abstract excerpt:** Identifies five core competencies — "code localization, code editing, unit-test generation, issue reproduction, and code review" — as foundational atomic skills. Joint RL training across these five achieves "18.7% improvement on 5 atomic skills and 5 composite tasks" on average, with transfer to unseen composite tasks including bug-fixing, refactoring, and code security.  
**One-sentence summary:** Proposes training coding agents on five atomic skills via joint RL, achieving 18.7% average improvement with cross-task transfer to unseen composite software engineering tasks.  
**Blueprint relevance:** Provides the training curriculum for a Claude Code agent that actually generalizes; the atomic-skill decomposition is directly addable to the skill-layering principle, and the RL transfer evidence justifies investing in skill-primitive training rather than task-specific fine-tuning.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.05013

---

### 9. arxiv:2604.05400
**Title:** HYVE: Hybrid Views for LLM Context Engineering over Machine Data  
**Authors:** Jian Tan, Fan Bu, Yuqing Gao, Dev Khanolkar, Jason Mackay, Boris Sobolev, Lei Jin, Li Zhang  
**Date:** April 7, 2026 (Tuesday)  
**Category:** cs.LG / cs.SE  
**Abstract excerpt:** "HYVE reduces token usage by 50-90% while maintaining or improving output quality" through selective data representation and hybrid views for machine data payloads. Achieves "up to 132% improvement in chart-generation accuracy."  
**One-sentence summary:** A request-scoped datastore with schema-aware hybrid views cuts machine-data token usage 50–90% while improving downstream task accuracy by up to 132%.  
**Blueprint relevance:** Directly applicable to Claude Code's context-engineering pipeline for long log/trace payloads; complements 2604.04979 (Squeez 92% input reduction) with a different approach targeting structured machine data rather than code.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.05400

---

### 10. arxiv:2604.06742
**Title:** Evaluating LLM-Based 0-to-1 Software Generation in End-to-End CLI Tool Scenarios  
**Authors:** Ruida Hu, Xinchen Wang, Chao Peng, Cuiyun Gao, David Lo  
**Date:** April 8, 2026  
**Category:** cs.SE  
**Abstract excerpt:** CLI-Tool-Bench features 100 real-world repositories with a "black-box differential testing framework." Evaluation of seven state-of-the-art models reveals "top models achieve under 43% success." The research notes that "increased computational resources don't guarantee improved results and that generated code tends toward monolithic structures."  
**One-sentence summary:** A 100-repo benchmark for greenfield CLI tool generation shows all top models below 43% success, with a finding that throwing more compute at the problem does not help and outputs skew monolithic.  
**Blueprint relevance:** The monolithic-structure tendency and <43% ceiling update the bounded-autonomy principle — even frontier models fail majority-case greenfield generation, supporting a human-in-the-loop checkpoint at architecture design stage.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.06742

---

### 11. arxiv:2604.06793
**Title:** Evaluating Repository-level Software Documentation via Question Answering and Feature-Driven Development  
**Authors:** Xinchen Wang, Ruida Hu, Cuiyun Gao, Pengfei Gao, Chao Peng  
**Date:** April 8, 2026  
**Category:** cs.SE  
**Abstract excerpt:** SWD-Bench comprises 4,170 entries derived from high-quality pull requests. Experiments demonstrate that documentation from top-performing methods "improves the issue-solving rate of SWE-Agent by 20.00%."  
**One-sentence summary:** A QA-based repository documentation benchmark (4,170 entries) shows that high-quality auto-generated repo docs improve SWE-Agent's issue resolution rate by 20%.  
**Blueprint relevance:** Directly supports the CLAUDE.md/AGENTS.md documentation principle; a 20% issue-resolution lift from better docs is the strongest empirical justification yet for investing in repo-level documentation as an agent primitive.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.06793

---

### 12. arxiv:2604.06066
**Title:** From Hallucination to Structure Snowballing: The Alignment Tax of Constrained Decoding in LLM Reflection  
**Authors:** Hongxu Zhou  
**Date:** April 7, 2026  
**Category:** cs.AI  
**Abstract excerpt:** Structural constraints in self-correction "consume so much model capacity that it produces 'formatting traps,' where models achieve syntactic alignment but miss semantic errors." This reveals an inherent "alignment tax" when using strict formatting constraints in autonomous workflows. Tested on an 8B-parameter model.  
**One-sentence summary:** Strict structured-output constraints during LLM self-reflection create a semantic-alignment tax — models hit formatting compliance at the cost of catching actual errors — introducing a new failure mode for verification loops.  
**Blueprint relevance:** Directly challenges the structured-output-in-verification-loops assumption; verification architectures that mandate strict JSON/XML output from the reflector model may silently degrade semantic error detection.  
**Code/repo:** https://github.com/hongxuzhou/agentic_llm_structured_self_critique  
**Source:** https://arxiv.org/abs/2604.06066

---

### 13. arxiv:2604.04820
**Title:** ANX: Protocol-First Design for AI Agent Interaction with a Supporting 3EX Decoupled Architecture  
**Authors:** Xu Mingze  
**Date:** April 6, 2026  
**Category:** cs.AI  
**Abstract excerpt:** ANX integrates CLI, Skill, and MCP technologies through four core innovations, reducing tokens by "up to 55.6% against competing approaches and shortening execution time by approximately 58%" through agent-native design, dual rendering, lightweight MCP-supported apps, and markup-enabled executable procedures.  
**One-sentence summary:** ANX proposes an agent-native interaction protocol that unifies CLI, Skill, and MCP into a single decoupled architecture, cutting token usage 55.6% and execution time 58% vs. GUI/MCP baselines.  
**Blueprint relevance:** Relevant to the agent-protocol/DSL slot — ANX is an alternative to raw MCP that trades protocol complexity for measurable efficiency gains; worth tracking as a potential replacement or complement to MCP in the toolchain.  
**Code/repo:** https://github.com/mountorc/anx-protocol  
**Source:** https://arxiv.org/abs/2604.04820

---

### 14. arxiv:2604.06506
**Title:** Guiding Symbolic Execution with Static Analysis and LLMs for Vulnerability Discovery (SAILOR)  
**Authors:** Md Shafiuzzaman, Achintya Desai, Wenbo Guo, Tevfik Bultan  
**Date:** April 7, 2026  
**Category:** cs.SE / cs.CR  
**Abstract excerpt:** Three-phase approach finds "379 distinct, previously unknown memory-safety vulnerabilities (421 confirmed crashes)" across 6.8M lines of C/C++. "Removing static analysis reduces confirmed vulnerabilities by 12.2x, eliminating iterative LLM synthesis yields zero confirmations."  
**One-sentence summary:** SAILOR's static-analysis-guided LLM harness synthesis finds 379 new memory-safety vulnerabilities across 6.8M lines, with ablations proving each component (static analysis, LLM, symbolic execution) is individually necessary.  
**Blueprint relevance:** Demonstrates the verification-loop architecture at full production scale; the 12.2x multiplier from static analysis pre-filtering is the most concrete empirical argument for a hybrid (static + LLM) verification pipeline over pure-LLM approaches.  
**Code/repo:** None linked.  
**Source:** https://arxiv.org/abs/2604.06506

---

### 15. arxiv:2604.04604
**Title:** AI Agents Under EU Law  
**Authors:** Luca Nannini, Adam Leon Smith, Michele Joshua Maggini et al.  
**Date:** April 6, 2026  
**Category:** cs.AI (Law/Policy)  
**Abstract excerpt:** "high-risk agentic systems with untraceable behavioral drift cannot currently satisfy the AI Act's essential requirements." Compliance requires "an exhaustive inventory of the agent's external actions, data flows, connected systems, and affected persons." Covers cybersecurity, human oversight, transparency across multi-party action chains, and runtime behavioral drift as the four primary compliance challenges.  
**One-sentence summary:** Maps EU AI Act obligations to agentic systems, finding that runtime behavioral drift and opaque multi-party action chains are the two currently unresolvable compliance blockers for high-risk deployments.  
**Blueprint relevance:** Adds a regulatory constraint layer to the human-oversight principle; the "exhaustive inventory of external actions" requirement is functionally equivalent to the audit-log/tool-call-ledger that any serious Claude Code deployment needs for compliance.  
**Code/repo:** None.  
**Source:** https://arxiv.org/abs/2604.04604

---

## Principle-Changing Findings

### Finding A — MCPSHIELD (2604.05969) challenges any single-layer sandbox argument
> "existing defenses covering no more than 34 percent" of identified MCP threat vectors individually.

**Impact:** If your blueprint's §2/Principle 9 argues that a single sandbox layer (e.g., container isolation) provides adequate defense, this paper makes that position empirically indefensible. The 34% ceiling means any blueprint must specify at minimum three independent, non-overlapping defense layers across different MCP architectural surfaces.

### Finding B — ShieldNet (2604.04426) introduces a new required defense layer not in most blueprints
> "observing real network interactions rather than surface-level tool traces"

**Impact:** Existing blueprints that rely solely on static tool inspection or pre-execution analysis have a blind spot for supply-chain injection. Network-level behavioral monitoring is not listed in the original layered-defense taxonomy and constitutes a new required layer.

### Finding C — Skill-in-the-Wild benchmark (2604.04323) sets an empirical ceiling on skill-library benefits
> "pass rates approaching no-skill baselines in the most challenging scenarios"

**Impact:** If your blueprint contains a principle about skill accumulation providing compounding productivity gains (Ralph-style), this paper is a direct falsifier in the realistic setting. The gain is real but fragile; query-specific refinement is the necessary recovery mechanism, not skill accumulation alone.

### Finding D — Alignment Tax (2604.06066) undermines structured-output verification loops
> "formatting traps, where models achieve syntactic alignment but miss semantic errors"

**Impact:** Any blueprint principle that uses structured JSON/XML output as a signal of successful verification is now suspect. The alignment tax means structured outputs may increase false-confidence in verification passes. This is a new failure mode for the verification-loop architecture.

### Finding E — CLI-Tool-Bench (2604.06742): <43% greenfield generation ceiling
> "top models achieve under 43% success" and "increased computational resources don't guarantee improved results"

**Impact:** Contradicts any blueprint principle that suggests scaling compute resolves greenfield generation failures. The ceiling is model-capability-bound, not compute-bound, which changes the architectural response (supervision checkpoints, not more tokens).

---

## Companion Code / Tools Worth Adding to Blueprint

| Tool | Repo | Use |
|---|---|---|
| SkillX skill-KB builder | https://github.com/zjunlp/SkillX | Automated skill library construction for Ralph-style loops |
| RoboPhD evolution toolkit | MIT-licensed, `optimize_anything()` API | Self-improving agent evolution under budget constraint |
| Skill-Usage benchmark | https://github.com/UCSB-NLP-Chang/Skill-Usage | Evaluation harness for realistic skill retrieval |
| ANX protocol | https://github.com/mountorc/anx-protocol | Lightweight MCP alternative, 55.6% token reduction |
| LightThinker++ | No repo yet | 70% peak-token reduction for long reasoning chains |
| Alignment Tax code | https://github.com/hongxuzhou/agentic_llm_structured_self_critique | Benchmark for structured-output failure in verification loops |

---

## Papers Excluded (pre-April 4 or in existing corpus)

- 2604.04978 — in existing corpus (Auto-Mode permission gate, 81% FN)
- 2604.02947 — in existing corpus (AgentHazard)
- 2604.03081 — in existing corpus (DDIPE)
- 2604.04979 — in existing corpus (Squeez)
- 2604.01905 — submitted April 2 (MCP malicious server detection, Connor F1=94.6%)
- 2604.01438 — submitted April 1 (ClawSafety, 40–75% attack success)
- 2604.01007 — submitted April 1 (Omni-SimpleMem, +411% LoCoMo)
- 2604.00436 — submitted April 1 (Programming by Chat, 11,579 sessions)
- 2604.01527 — submitted April 2 (ProdCodeBench, 53.2–72.2% solve rates)

---

*Scout completed: 2026-04-11. All citations primary-source arxiv.org abstracts.*
