# Ultimate Claude Code Ecosystem Catalog — April 2026

> Compiled 2026-04-12 by document-specialist agent. Sources: GitHub, awesome lists, official docs, MCP registries, community reviews, blog posts.

---

## Table of Contents

1. [Agent Orchestrators & Multi-Agent Frameworks](#1-agent-orchestrators--multi-agent-frameworks)
2. [Agent Skills & Skill Registries](#2-agent-skills--skill-registries)
3. [Official Anthropic Repos & SDKs](#3-official-anthropic-repos--sdks)
4. [Plugins (Official Marketplace & Community)](#4-plugins-official-marketplace--community)
5. [MCP Servers — Dev Tools & Code Intelligence](#5-mcp-servers--dev-tools--code-intelligence)
6. [MCP Servers — Databases & ORMs](#6-mcp-servers--databases--orms)
7. [MCP Servers — Cloud & Infrastructure](#7-mcp-servers--cloud--infrastructure)
8. [MCP Servers — Communication & Messaging](#8-mcp-servers--communication--messaging)
9. [MCP Servers — Productivity & Knowledge Management](#9-mcp-servers--productivity--knowledge-management)
10. [MCP Servers — Web Scraping & Search](#10-mcp-servers--web-scraping--search)
11. [MCP Servers — Design & Diagrams](#11-mcp-servers--design--diagrams)
12. [MCP Servers — E-Commerce & Payments](#12-mcp-servers--e-commerce--payments)
13. [MCP Servers — File Format Converters](#13-mcp-servers--file-format-converters)
14. [MCP Servers — Observability & Monitoring](#14-mcp-servers--observability--monitoring)
15. [MCP Servers — Security & Secrets](#15-mcp-servers--security--secrets)
16. [MCP Servers — Deployment & Hosting](#16-mcp-servers--deployment--hosting)
17. [MCP Servers — Accessibility & Testing](#17-mcp-servers--accessibility--testing)
18. [MCP Servers — Database Migration & Schema](#18-mcp-servers--database-migration--schema)
19. [MCP Servers — Calendar, Email & Task Mgmt](#19-mcp-servers--calendar-email--task-mgmt)
20. [MCP Servers — Analytics, SEO & Feature Flags](#20-mcp-servers--analytics-seo--feature-flags)
21. [Workflows & Knowledge Guides](#21-workflows--knowledge-guides)
22. [CLAUDE.md Templates & Config Frameworks](#22-claudemd-templates--config-frameworks)
23. [IDE Integrations](#23-ide-integrations)
24. [Usage Monitors & Cost Optimization](#24-usage-monitors--cost-optimization)
25. [Status Lines](#25-status-lines)
26. [Session Recording & Replay](#26-session-recording--replay)
27. [Git Workflow & Worktree Tools](#27-git-workflow--worktree-tools)
28. [Docker & Sandbox Isolation](#28-docker--sandbox-isolation)
29. [Memory & Context Persistence](#29-memory--context-persistence)
30. [Config Managers & Linters](#30-config-managers--linters)
31. [Infrastructure as Code Skills](#31-infrastructure-as-code-skills)
32. [Security Skills & Scanners](#32-security-skills--scanners)
33. [Communication Channels (Telegram/Discord/iMessage)](#33-communication-channels-telegramdiscordimessage)
34. [Browser Automation & E2E Testing](#34-browser-automation--e2e-testing)
35. [LLM Gateways & Model Routers](#35-llm-gateways--model-routers)
36. [CI/CD & GitHub Actions](#36-cicd--github-actions)
37. [Awesome Lists & Curated Directories](#37-awesome-lists--curated-directories)
38. [Alternative / Complementary Coding Agents](#38-alternative--complementary-coding-agents)
39. [Ralph Wiggum Loop Resources](#39-ralph-wiggum-loop-resources)
40. [Voice & Speech Tools](#40-voice--speech-tools)
41. [Design System Generators](#41-design-system-generators)
42. [Learning & Documentation Resources](#42-learning--documentation-resources)

---

## 1. Agent Orchestrators & Multi-Agent Frameworks

| Name | URL | Stars | Description | Integration |
|------|-----|-------|-------------|-------------|
| Claude Code Agent Teams | https://code.claude.com/docs/en/agent-teams | Official | Built-in multi-agent orchestrator (experimental) | Native CC feature |
| oh-my-claudecode | https://github.com/Yeachan-Heo/oh-my-claudecode | 4.5k+ | Teams-first multi-agent orchestration for Claude Code | CC plugin/framework |
| Claude Squad | https://github.com/smtg-ai/claude-squad | 8k+ | TUI for managing multiple AI terminal agents in isolated git worktrees | Standalone TUI |
| Claude Swarm | https://github.com/parruda/claude-swarm | 2k+ | Launch CC sessions connected to agent swarms via YAML config | CLI wrapper |
| Claude Code Flow | https://github.com/ruvnet/claude-code-flow | 1k+ | Code-first orchestration layer for recursive agent cycles | CLI framework |
| Ruflo | https://github.com/ruvnet/ruflo | 800+ | Orchestration platform for multi-agent swarms with vector memory | Framework |
| Auto-Claude | https://github.com/AndyMik90/Auto-Claude | 500+ | Multi-agent coding framework with kanban UI and full SDLC | Desktop app |
| Claude Task Master | https://github.com/eyaltoledano/claude-task-master | 3k+ | Task management system for AI-assisted development | Cursor/CC plugin |
| Claude Task Runner | https://github.com/grahama1970/claude-task-runner | 300+ | Context isolation and focused task execution manager | CLI tool |
| Happy Coder (slopus/happy) | https://github.com/slopus/happy | 200+ | Spawn and control multiple Claude Codes from phone or desktop | Mobile/Desktop |
| sudocode | https://github.com/sudocode-ai/sudocode | 400+ | Lightweight agent orchestration dev tool integrated with specs | CLI tool |
| TSK | https://github.com/dtormoen/tsk | 300+ | Rust CLI delegating tasks to sandboxed Docker agents | CLI tool |
| The Agentic Startup | https://github.com/rsmdt/the-startup | 200+ | Collection of agents, commands, and resources for shipping code | CC config |
| GasTown | (Steve Yegge) | N/A | Kubernetes-like orchestrator for AI agents; good for parallel agents | Desktop app |
| Multiclaude | (Dan Lorenc) | N/A | Multi-agent orchestrator with auto-merge-on-CI-pass | CLI tool |
| Claude Code Agentrooms | https://claudecode.run/ | N/A | Route tasks to specialized AI agents with @mentions | Web platform |
| IttyBitty | (Adam Wulf) | N/A | Lightweight multi-agent Claude Code orchestrator | CLI tool |
| jean | N/A | N/A | Desktop & web app for orchestrating coding agents across projects | Desktop app |
| lalph | N/A | N/A | LLM agent orchestrator driven by issue tracker | CLI tool |
| mux | N/A | N/A | Desktop app for isolated, parallel agentic development | Desktop app |
| openkanban | N/A | N/A | TUI kanban board for orchestrating AI coding agents | TUI |
| parallel-code | N/A | N/A | Desktop app for orchestrating multiple AI coding agents in worktrees | Desktop app |
| sortie | N/A | N/A | Turns issue tracker tickets into autonomous coding agent sessions | CLI tool |
| ComposioHQ agent-orchestrator | https://github.com/ComposioHQ/agent-orchestrator | 500+ | Plans tasks, spawns agents, handles CI fixes and merge conflicts | CLI framework |
| Claude Code PM (ccpm) | https://github.com/automazeio/ccpm | 300+ | Comprehensive project-management workflow with specialized agents | CC workflow |

---

## 2. Agent Skills & Skill Registries

| Name | URL | Stars | Description | Integration |
|------|-----|-------|-------------|-------------|
| OpenClaw / ClawHub | https://clawhub.ai | N/A | 13,729+ community-built skills in official OpenClaw registry | SKILL.md format |
| VoltAgent awesome-agent-skills | https://github.com/VoltAgent/awesome-agent-skills | 2k+ | 1,000+ curated agent skills from official dev teams & community | SKILL.md format |
| VoltAgent awesome-openclaw-skills | https://github.com/VoltAgent/awesome-openclaw-skills | 1.5k+ | 5,400+ OpenClaw skills filtered & categorized | SKILL.md format |
| antigravity-awesome-skills | https://github.com/sickn33/antigravity-awesome-skills | 1k+ | 1,370+ agentic skills for CC, Cursor, Codex, Gemini, Antigravity | SKILL.md format |
| anthropics/skills | https://github.com/anthropics/skills | Official | Public repository for official Anthropic Agent Skills | SKILL.md format |
| AgentSys | https://github.com/avifenesh/agentsys | 500+ | Workflow automation with plugins, agents, and skills | CC plugin |
| Superpowers | https://github.com/obra/superpowers | 1k+ | Bundle covering core software engineering competencies | CC skill |
| Trail of Bits Security Skills | https://github.com/trailofbits/skills | 800+ | 12+ security-focused skills for code auditing | CC skill |
| Fullstack Dev Skills | https://github.com/jeffallan/claude-skills | 600+ | 65 specialized skills for full-stack development | CC skill |
| Book Factory | https://github.com/robertguss/claude-skills | 400+ | Publishing pipeline for nonfiction book creation | CC skill |
| Claude Scientific Skills | https://github.com/K-Dense-AI/claude-scientific-skills | 300+ | Research, science, engineering, analysis, finance skills | CC skill |
| cc-devops-skills | https://github.com/akin-ozer/cc-devops-skills | 200+ | DevOps skill set with validations and IaC code generation | CC skill |
| Claude Code Agents | https://github.com/undeadlist/claude-code-agents | 300+ | E2E development workflow with subagent prompts | CC skill |
| Claude Codex Settings | https://github.com/fcakyon/claude-codex-settings | 200+ | Plugin collection for GitHub, Azure, MongoDB, cloud | CC plugin |
| Claude Mountaineering Skills | https://github.com/dreamiurg/claude-mountaineering-skills | 100+ | Mountain route research aggregating 10+ data sources | CC skill |
| Codebase to Course | https://github.com/zarazhangrui/codebase-to-course | 300+ | Converts codebases into interactive HTML courses | CC skill |
| Context Engineering Kit | https://github.com/NeoLabHQ/context-engineering-kit | 400+ | Advanced context engineering with minimal token footprint | CC skill |
| Everything Claude Code | https://github.com/affaan-m/everything-claude-code | 500+ | Comprehensive resources covering core engineering domains | CC skill |
| Compound Engineering Plugin | https://github.com/EveryInc/compound-engineering-plugin | 200+ | Learning-from-mistakes agents and skills | CC plugin |
| Web Assets Generator | https://github.com/alonw0/web-asset-generator | 100+ | Generate favicons, app icons, social media images | CC skill |
| TACHES CC Resources | https://github.com/glittercowboy/taches-cc-resources | 200+ | Sub agents, skills, commands with meta-skills focus | CC skill |
| read-only-postgres | https://github.com/jawwadfirdousi/agent-skills | 100+ | Read-only PostgreSQL query skill with strict validation | CC skill |
| Codex Skill | https://github.com/skills-directory/skill-codex | 100+ | Enables codex prompting with parameter inference | CC skill |
| Pulumi Agent Skills | https://github.com/pulumi/agent-skills | Official | IaC skills for Pulumi across Claude Code and other agents | SKILL.md format |

---

## 3. Official Anthropic Repos & SDKs

| Name | URL | Description |
|------|-----|-------------|
| claude-code | https://github.com/anthropics/claude-code | The agentic coding tool (CLI) |
| claude-code-action | https://github.com/anthropics/claude-code-action | GitHub Actions integration |
| claude-code-base-action | https://github.com/anthropics/claude-code-base-action | Base action for GitHub Actions |
| claude-code-security-review | https://github.com/anthropics/claude-code-security-review | AI-powered security review GitHub Action |
| claude-agent-sdk-python | https://github.com/anthropics/claude-agent-sdk-python | Python Agent SDK (same engine as CC) |
| claude-agent-sdk-typescript | https://github.com/anthropics/claude-agent-sdk-typescript | TypeScript Agent SDK |
| claude-plugins-official | https://github.com/anthropics/claude-plugins-official | Official 101-plugin marketplace |
| claude-plugins-community | https://github.com/anthropics/claude-plugins-community | Community plugin marketplace mirror |
| knowledge-work-plugins | https://github.com/anthropics/knowledge-work-plugins | Plugins for knowledge workers (Cowork) |
| financial-services-plugins | https://github.com/anthropics/financial-services-plugins | Financial services-focused plugins |
| skills | https://github.com/anthropics/skills | Official Agent Skills repository |
| anthropic-sdk-python | https://github.com/anthropics/anthropic-sdk-python | Python SDK |
| anthropic-sdk-typescript | https://github.com/anthropics/anthropic-sdk-typescript | TypeScript SDK |
| anthropic-sdk-java | https://github.com/anthropics/anthropic-sdk-java | Java SDK |
| anthropic-sdk-go | https://github.com/anthropics/anthropic-sdk-go | Go SDK |
| anthropic-sdk-ruby | https://github.com/anthropics/anthropic-sdk-ruby | Ruby SDK |
| anthropic-sdk-csharp | https://github.com/anthropics/anthropic-sdk-csharp | C# SDK |
| anthropic-sdk-php | https://github.com/anthropics/anthropic-sdk-php | PHP SDK |
| anthropic-cli | https://github.com/anthropics/anthropic-cli | CLI for Claude API |
| claude-cookbooks | https://github.com/anthropics/claude-cookbooks | Notebooks/recipes for using Claude |
| homebrew-tap | https://github.com/anthropics/homebrew-tap | Homebrew formulae for Anthropic tools |
| modelcontextprotocol/servers | https://github.com/modelcontextprotocol/servers | 50+ official MCP server implementations |
| modelcontextprotocol/registry | https://github.com/modelcontextprotocol/registry | Official MCP Registry service |

---

## 4. Plugins (Official Marketplace & Community)

### Official Anthropic Marketplace (101 plugins: 33 Anthropic-built + 68 partner)

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Firecrawl | https://claude.com/plugins/firecrawl | Web scraping, crawling, and search | Official plugin |
| Playwright | https://claude.com/plugins/playwright | Browser automation and testing | Official plugin |
| GitHub | https://claude.com/plugins/github | GitHub repository management | Official plugin |
| Supabase | https://claude.com/plugins/supabase | 20+ tools for Supabase backend management | Official plugin |
| Postman | https://claude.com/plugins/postman | API testing with 111 MCP tools | Official plugin |
| Mermaid Chart | https://claude.com/connectors/mermaid-chart | Diagram validation and rendering | Official connector |
| Aikido Security | https://claude.com/plugins/aikido | SAST, secrets, IaC misconfiguration scanning | Official plugin |
| Stripe | (via Composio/MCP) | Payment processing integration | MCP plugin |
| Shopify (4 servers) | (via MCP) | Dev, Storefront, Customer, Checkout servers | MCP plugin |

### Community Plugin Repos

| Name | URL | Description |
|------|-----|-------------|
| ComposioHQ awesome-claude-plugins | https://github.com/ComposioHQ/awesome-claude-plugins | Curated list of CC plugins |
| ccplugins awesome-claude-code-plugins | https://github.com/ccplugins/awesome-claude-code-plugins | Curated slash commands, subagents, MCP, hooks |
| GiladShoham awesome-claude-plugins | https://github.com/GiladShoham/awesome-claude-plugins | Curated plugin list |
| quemsah awesome-claude-plugins | https://github.com/quemsah/awesome-claude-plugins | Plugin adoption metrics via n8n |
| Chat2AnyLLM awesome-claude-plugins | https://github.com/Chat2AnyLLM/awesome-claude-plugins | Curated marketplaces and plugins |
| claude-code-plugins-plus-skills | (jeremylongshore) | Extended plugins and skills collection |

---

## 5. MCP Servers — Dev Tools & Code Intelligence

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| GitHub MCP | https://github.com/modelcontextprotocol/servers | PRs, issues, repo management | `claude mcp add` |
| GitLab MCP | (via registry) | GitLab integration | MCP server |
| Jira (Atlassian Rovo) | https://github.com/tom28881/mcp-jira-server | Issue tracking and project management | MCP HTTP |
| Linear | (via MCP HTTP) | Issue tracking and project boards | MCP HTTP |
| Sentry | https://mcp.sentry.dev/mcp | Error monitoring and stack traces | MCP HTTP |
| Figma MCP | (Figma official) | Design-to-code, canvas manipulation | MCP server |
| Postman MCP | https://github.com/postmanlabs/postman-mcp-server | API testing, collections, mock servers | MCP server |
| Sequential Thinking | (official reference) | Step-by-step reasoning tool | MCP server |
| Git MCP | (official reference) | Git operations | MCP server |
| Filesystem MCP | (official reference) | File system operations | MCP server |
| Memory MCP | (official reference) | Persistent key-value memory | MCP server |
| Fetch MCP | (official reference) | HTTP fetching | MCP server |

---

## 6. MCP Servers — Databases & ORMs

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| PostgreSQL MCP | (official) | Direct PostgreSQL access | MCP server |
| SQLite MCP | (official) | SQLite database access | MCP server |
| MongoDB MCP | (via registry) | Collection querying and schema inspection | MCP server |
| Supabase MCP | https://supabase.com/docs/guides/getting-started/mcp | Full Supabase access (DB, auth, storage, edge) | MCP server |
| Redis MCP | (via registry) | Key-value read/write | MCP server |
| Neon MCP | (via registry) | Serverless Postgres | MCP server |
| Prisma MCP | (built-in CLI v6.6+) | migrate-dev/status/reset | Built-in CLI |
| Drizzle MCP | (community) | Type-safe SQL ORM tools | MCP server |
| Google MCP Toolbox for Databases | (13.5k stars) | Multi-database toolbox | MCP server |
| Atlas MCP | (community, mpreziuso) | Schema migration (5 tools) | MCP server |

---

## 7. MCP Servers — Cloud & Infrastructure

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| AWS MCP | https://github.com/IncomeStreamSurfer/claude-aws-toolkit | AWS infrastructure management | MCP server |
| Azure MCP | https://github.com/kalivaraprasad-gonapa/azure-mcp | Azure services via Resource Manager API | MCP server |
| Azure CLI MCP | https://github.com/St8ntonWil3y/azure-cli-mcp | Azure CLI wrapper | MCP server |
| Azure Skills Plugin | (Microsoft official) | Azure skills + Foundry MCP bundled | CC plugin |
| Azure DevOps MCP | (Microsoft official, public preview) | Azure DevOps integration | MCP HTTP |
| GCP / gcloud MCP | (via registry) | Compute Engine, Storage, BigQuery, Cloud Run | MCP server |
| Terraform MCP | https://github.com/hashicorp/terraform-mcp-server | Terraform Registry and Cloud APIs | MCP server |
| Docker MCP | (via registry) | Container image operations, registry, builds | MCP server |
| Kubernetes / kubectl MCP | (lens MCP) | Pod events, logs, resource limits, SRE-like queries | MCP server |
| Cloud Pilot MCP | https://glama.ai/mcp/servers/vitalemazo/cloud-pilot-mcp | Multi-cloud management | MCP server |
| Cloudflare MCP | (via registry) | Workers, Pages, DNS, KV | MCP server |

---

## 8. MCP Servers — Communication & Messaging

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Slack MCP | (via registry/Composio) | Slack messaging and channels | MCP server |
| Discord MCP | (CC Channels) | Discord bot integration | CC Channel plugin |
| Telegram MCP | (CC Channels) | Telegram bot integration | CC Channel plugin |
| iMessage MCP | (CC Channels) | iMessage integration | CC Channel plugin |
| Microsoft Teams MCP | (via Composio) | Teams messaging | MCP server |
| Google Chat MCP | (via Google Workspace MCP) | Chat messaging | MCP server |

---

## 9. MCP Servers — Productivity & Knowledge Management

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Notion MCP | (via MCP HTTP) | Pages, databases, blocks | MCP server |
| Obsidian MCP | (community) | Vault read/write/search | MCP server |
| Confluence MCP | https://composio.dev/toolkits/confluence/framework/claude-code | Atlassian Confluence integration | MCP server |
| Google Workspace MCP | https://github.com/taylorwilsdon/google_workspace_mcp | Gmail, Calendar, Docs, Sheets, Slides, Drive, Tasks | MCP server |
| M365 Planner MCP | https://github.com/avellinosantiago/m365-mcp | Microsoft 365 Planner integration | MCP server |
| Miro MCP | https://composio.dev/toolkits/miro/framework/claude-code | Whiteboard collaboration | MCP server |

---

## 10. MCP Servers — Web Scraping & Search

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Firecrawl MCP | https://github.com/firecrawl/firecrawl-claude-plugin | Scrape, search, crawl, map the web with anti-bot handling | CC plugin |
| Brave Search MCP | (official reference) | Privacy-focused web search | MCP server |
| Perplexity Sonar MCP | (community) | AI-powered search | MCP server |
| Bright Data MCP | (community) | Web data extraction at scale | MCP server |
| Context7 MCP | (community) | Live, version-accurate library documentation | MCP server |
| markdownify-mcp | https://github.com/zcaceres/markdownify-mcp | Convert almost anything to Markdown | MCP server |

---

## 11. MCP Servers — Design & Diagrams

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Figma MCP | (Figma official) | Read designs, manipulate canvas (use_figma tool) | MCP server |
| Mermaid MCP | https://github.com/veelenga/claude-mermaid | Preview Mermaid diagrams with live reload | MCP server |
| mcp-mermaid | https://github.com/hustcc/mcp-mermaid | Generate Mermaid diagrams dynamically | MCP server |
| draw.io MCP | (community) | Open editable diagrams in draw.io editor | MCP server |
| Storybook (via Figma) | (workflow) | Reverse-engineer Storybook into Figma components | Workflow |

---

## 12. MCP Servers — E-Commerce & Payments

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Stripe MCP | https://docs.stripe.com/mcp | Payments, subscriptions, invoices, refunds | MCP server |
| Shopify Dev MCP | (Shopify official) | Development and API access | MCP server |
| Shopify Storefront MCP | (Shopify official) | Storefront operations | MCP server |
| Shopify Customer Account MCP | (Shopify official) | Customer management | MCP server |
| Shopify Checkout MCP | (Shopify official) | Checkout customization | MCP server |

---

## 13. MCP Servers — File Format Converters

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| md-to-pdf-mcp | https://github.com/MarceauSolutions/md-to-pdf-mcp | Markdown to PDF conversion | MCP server |
| html2pdf | https://github.com/jesamkim/html2pdf | HTML to PDF via Puppeteer | MCP server |
| MarkItDown | (skill) | 15+ file formats to Markdown (Office, PDF, media) | CC skill |
| Marker | (skill) | PDF, EPUB, Office to Markdown/HTML/JSON | CC skill |
| Nutrient DWS MCP | (community) | PDF-to-HTML, Markdown, PDF/UA conversion | MCP server |

---

## 14. MCP Servers — Observability & Monitoring

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| claude-code-otel | https://github.com/ColeMurray/claude-code-otel | OpenTelemetry observability for CC usage/costs | OTEL integration |
| Datadog MCP | https://docs.datadoghq.com/bits_ai/mcp_server/ | Logs, metrics, traces, dashboards, monitors | MCP server |
| Grafana MCP | (skill) | Query metrics, analyze logs, manage dashboards | MCP/skill |
| GCP Observability MCP | (skill) | GCP log management and monitoring | MCP/skill |
| Honeycomb | (via OTEL) | Distributed tracing | OTEL integration |
| Jaeger / Zipkin | (via OTEL) | Distributed tracing backends | OTEL integration |

---

## 15. MCP Servers — Security & Secrets

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Claude Code Security | https://claude.com/solutions/claude-code-security | Built-in vulnerability scanning (Opus 4.6, 500+ vulns found) | Native CC feature |
| Aikido Security | https://claude.com/plugins/aikido | SAST, secrets, IaC misconfiguration detection | CC plugin |
| Security Scanner Plugin | https://github.com/harish-garg/security-scanner-plugin | GitHub-data-based vulnerability scanning | CC plugin |
| Anthropic Vaults API | https://platform.claude.com/docs/en/managed-agents/vaults | Credential management for MCP servers | API feature |
| Claude Vault (skill) | (mcpmarket) | Secrets handling in CC sessions | CC skill |
| Snyk (skill) | (community) | Dependency vulnerability scanning | CC skill |

---

## 16. MCP Servers — Deployment & Hosting

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Vercel MCP | https://vercel.com/docs/agent-resources/vercel-mcp | Deployment logs, project metadata, management | MCP HTTP |
| Netlify MCP | https://docs.netlify.com/build/build-with-ai/netlify-mcp-server/ | Site setup, builds, serverless functions | MCP HTTP |
| Cloudflare (Workers/Pages) | (via registry) | Serverless deployment | MCP server |
| AWS Lambda / ECS | (via AWS MCP) | Serverless and container deployment | MCP server |

---

## 17. MCP Servers — Accessibility & Testing

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| a11ymcp | https://mcpservers.org/servers/ronantakizawa/a11ymcp | 24 accessibility scanning tools, WCAG 2.0-2.2 | MCP server |
| mcp-web-a11y | https://mcpservers.org/servers/bilhasry-deriv/mcp-web-a11y | Web accessibility testing | MCP server |
| accessibility-agents | https://github.com/Community-Access/accessibility-agents | 11 WCAG 2.2 AA specialists for CC, Copilot | CC agents |
| claude-a11y-skill | https://github.com/airowe/claude-a11y-skill | axe-core + jsx-a11y accessibility audits | CC skill |

---

## 18. MCP Servers — Database Migration & Schema

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Prisma CLI (v6.6+) | (built-in) | migrate-dev, status, reset | CC built-in |
| Liquibase AI Changelog Generator | (private preview) | 19 tools, natural language to XML changelogs | MCP server |
| Atlas MCP | (community) | Schema migration (5 tools) | MCP server |
| Drizzle MCP | (community) | Type-safe SQL schema tools | MCP server |
| MCP Migration Advisor | https://lobehub.com/mcp/dmitriusan-mcp-migration-advisor | Flyway/Liquibase migration analysis | MCP server |
| DBDiff | https://github.com/DBDiff/DBDiff | MySQL/Postgres/SQLite schema diff, supports Flyway/Liquibase | CLI tool |

---

## 19. MCP Servers — Calendar, Email & Task Mgmt

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Google Calendar MCP | https://github.com/nspady/google-calendar-mcp | Calendar event management | MCP server |
| Gmail MCP | https://mcpservers.org/servers/bastienchabal/gmail-mcp | Email management | MCP server |
| Outlook MCP | https://github.com/ryaker/outlook-mcp | Email, calendar, contacts via MS Graph | MCP server |
| Google Workspace MCP | https://github.com/taylorwilsdon/google_workspace_mcp | Full Google Workspace (10+ services) | MCP server |
| Cal.com MCP | https://composio.dev/toolkits/cal/framework/claude-code | Scheduling integration | MCP server |
| ServiceNow MCP | https://composio.dev/toolkits/servicenow/framework/claude-code | IT service management | MCP server |

---

## 20. MCP Servers — Analytics, SEO & Feature Flags

| Name | URL | Description | Integration |
|------|-----|-------------|-------------|
| Google Analytics MCP | https://composio.dev/toolkits/google_analytics/framework/claude-code | Analytics data access | MCP server |
| Harness FME MCP | https://www.harness.io/blog/ai-powered-feature-management-with-harness-mcp-server-and-claude-code | Feature flags and experimentation | MCP server |
| Ahrefs / SEMrush | (via MCP connectors) | SEO data access | MCP server |
| Intl Skill (i18n) | (mcpmarket) | Internationalization patterns for Payload CMS/Astro | CC skill |

---

## 21. Workflows & Knowledge Guides

| Name | URL | Description |
|------|-----|-------------|
| AB Method | https://github.com/ayoubben18/ab-method | Spec-driven workflow for focused missions |
| Agentic Workflow Patterns | https://github.com/ThibautMelen/agentic-workflow-patterns | Agentic patterns with Mermaid diagrams |
| RIPER Workflow | https://github.com/tony/claude-code-riper-5 | Research, Innovate, Plan, Execute, Review with subagents |
| Simone | https://github.com/Helmi/claude-simone | Project management workflow with documents and guidelines |
| Claude CodePro | https://github.com/maxritter/claude-codepro | Professional dev environment with spec-driven workflow |
| Claude Code PM (ccpm) | https://github.com/automazeio/ccpm | Comprehensive PM workflow with specialized agents |
| Harness (meta-skill) | https://github.com/revfactory/harness | Meta-skill designing domain-specific agent teams |
| Scopecraft | https://github.com/scopecraft/command/tree/main/.claude/commands | Commands for all SDLC aspects |
| Claude Code Infrastructure Showcase | https://github.com/diet103/claude-code-infrastructure-showcase | Hooks for intelligent skill selection |
| ClaudoPro Directory | https://github.com/JSONbored/claudepro-directory | Hooks, slash commands, subagent files |
| Context Priming | https://github.com/disler/just-prompt/tree/main/.claude/commands | Systematic context priming commands |
| Design Review Workflow | https://github.com/OneRedOak/claude-code-workflows/tree/main/design-review | Automated UI/UX design review |
| n8n_agent | https://github.com/kingler/n8n_agent/tree/main/.claude/commands | Code analysis, QA, design, optimization |
| Project Workflow System | https://github.com/harperreed/dotfiles/tree/master/.claude/commands | Project management, code review, deployment |

---

## 22. CLAUDE.md Templates & Config Frameworks

| Name | URL | Description |
|------|-----|-------------|
| SuperClaude | https://github.com/SuperClaude-Org/SuperClaude_Framework | Configuration framework with commands and personas |
| ContextKit | https://github.com/FlineDev/ContextKit | Systematic 4-phase development framework |
| Claude Code Templates (davila7) | https://github.com/davila7/claude-code-templates | 1000+ components: agents, commands, skills, MCPs |
| Laravel TALL Stack Kit | https://github.com/tott/laravel-tall-claude-ai-configs | Laravel TALL stack CC configurations |
| Rulesync | https://github.com/dyoshikawa/rulesync | CLI generating configs for multiple AI agents |
| claude-toolbox | https://github.com/serpro69/claude-toolbox | Starter template with pre-configured MCP servers |
| VoltAgent awesome-design-md | https://github.com/VoltAgent/awesome-design-md | 55+ brand DESIGN.md files for AI-generated UI |

---

## 23. IDE Integrations

| Name | URL | Description |
|------|-----|-------------|
| Claude Code Chat (VS Code) | https://marketplace.visualstudio.com/items?itemName=AndrePimenta.claude-code-chat | Elegant CC chat interface for VS Code |
| Claudix (VS Code) | https://github.com/Haleclipse/Claudix | VSCode extension with chat and session management |
| claude-code.nvim | https://github.com/greggh/claude-code.nvim | Neovim integration |
| claude-code.el | https://github.com/stevemolitor/claude-code.el | Emacs interface for CC CLI |
| claude-code-ide.el | https://github.com/manzaltu/claude-code-ide.el | Emacs integration with ediff and LSP |

---

## 24. Usage Monitors & Cost Optimization

| Name | URL | Description |
|------|-----|-------------|
| CC Usage (ccusage) | https://github.com/ryoppippi/ccusage | CLI for managing/analyzing CC usage metrics |
| ccflare | https://github.com/snipeship/ccflare | Usage dashboard with comprehensive web UI |
| better-ccflare | https://github.com/tombii/better-ccflare | Enhanced ccflare fork with Docker support |
| Claude Code Usage Monitor | https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor | Real-time terminal token usage monitor |
| Claudex | https://github.com/kunwar-shah/claudex | Web-based conversation history browser |
| viberank | https://github.com/sculptdotfun/viberank | Community leaderboard for CC usage stats |
| Vibe-Log | https://github.com/vibe-log/vibe-log-cli | Prompt analysis with intelligent session analysis |
| Claude Code Router (CCR) | (community) | Open-source proxy for model routing & cost reduction |
| LiteLLM | (community) | Python proxy routing across 100+ model providers |
| OmniRoute | https://github.com/diegosouzapw/OmniRoute | AI gateway with routing, load balancing, caching |

---

## 25. Status Lines

| Name | URL | Description |
|------|-----|-------------|
| CCometixLine | https://github.com/Haleclipse/CCometixLine | Rust statusline with Git integration |
| ccstatusline | https://github.com/sirmalloc/ccstatusline | Customizable model info and token usage display |
| claude-code-statusline | https://github.com/rz1989s/claude-code-statusline | Enhanced 4-line statusline with themes and cost tracking |
| claude-powerline | https://github.com/Owloops/claude-powerline | Vim-style powerline with real-time tracking |
| claudia-statusline | https://github.com/hagan/claudia-statusline | Rust-based with persistent stats and progress bars |

---

## 26. Session Recording & Replay

| Name | URL | Description |
|------|-----|-------------|
| claude-replay | https://github.com/es617/claude-replay | Convert CC sessions to interactive HTML replays |
| claude-record | https://github.com/davidglogan/claude-record | AI-powered session recorder with summarization |
| claude-screen-recorder | https://github.com/ItachiDevv/claude-screen-recorder | Record browser sessions as MP4 via Playwright |
| cclogviewer | https://github.com/Brads3290/cclogviewer | View .jsonl conversation files in HTML UI |
| cchistory | https://github.com/eckardt/cchistory | Shell history command for CC sessions |

---

## 27. Git Workflow & Worktree Tools

| Name | URL | Description |
|------|-----|-------------|
| Native Worktree Support | (CC v2.1.49+) | Built-in `--worktree` flag for isolated branches | 
| Worktrunk | https://worktrunk.dev/ | CLI for Git worktree management for AI agents |
| viwo-cli | https://github.com/OverseedAI/viwo | Run CC in Docker with git worktrees as volume mounts |
| cc-sessions | https://github.com/GWUDCAP/cc-sessions | Opinionated productive development approach |
| Claude Hub | https://github.com/claude-did-this/claude-hub | Webhook service connecting CC to GitHub repos |

---

## 28. Docker & Sandbox Isolation

| Name | URL | Description |
|------|-----|-------------|
| Docker Sandboxes | https://docs.docker.com/ai/sandboxes/agents/claude-code/ | Official Docker microVM-based isolation |
| Container Use (Dagger) | https://github.com/dagger/container-use | Dev environments for coding agents |
| run-claude-docker | https://github.com/icanhasjonas/run-claude-docker | Self-contained Docker runner for CC |
| claude-code-sandbox | https://github.com/textcortex/claude-code-sandbox | Run CC safely in local Docker containers |

---

## 29. Memory & Context Persistence

| Name | URL | Description |
|------|-----|-------------|
| CLAUDE.md (native) | (built-in) | Native persistent instructions per project |
| MemClaw | (community) | Isolated project memory with Living README |
| claude-mem | https://github.com/thedotmack/claude-mem | Auto-capture, compress, inject context across sessions |
| memsearch ccplugin | (community) | Persistent memory plugin with full-text search |
| ClawMem | https://github.com/yoloshii/ClawMem | On-device context engine, hooks + MCP + hybrid RAG |
| Claude Session Restore | https://github.com/ZENG3LD/claude-session-restore | Restore context from previous sessions |
| recall | https://github.com/zippoxer/recall | Full-text search for CC sessions |
| claude-code-tools | https://github.com/pchalasani/claude-code-tools | Session continuity with Rust-powered full-text search |

---

## 30. Config Managers & Linters

| Name | URL | Description |
|------|-----|-------------|
| agnix | https://github.com/agent-sh/agnix | Comprehensive linter for CC agent files with IDE plugins |
| claude-rules-doctor | https://github.com/nulone/claude-rules-doctor | Detect dead .claude/rules/ files by checking path globs |
| ClaudeCTX | https://github.com/foxj77/claudectx | Switch entire CC configuration with single command |
| ccexp | https://github.com/nyatinte/ccexp | Interactive CLI for discovering CC config files |
| tweakcc | https://github.com/Piebald-AI/tweakcc | Customize CC styling from command line |

---

## 31. Infrastructure as Code Skills

| Name | URL | Description |
|------|-----|-------------|
| Terraform Skill (antonbabenko) | https://github.com/antonbabenko/terraform-skill | HCL, modules, CI/CD, production patterns | 
| Pulumi Agent Skills | https://github.com/pulumi/agent-skills | ComponentResource, Automation API, migration |
| AWS Toolkit Skill | https://github.com/IncomeStreamSurfer/claude-aws-toolkit | AWS infrastructure management |
| cc-devops-skills | https://github.com/akin-ozer/cc-devops-skills | DevOps with validations and IaC generation |
| Azure Skills Plugin | (Microsoft official) | Azure + Foundry MCP bundled |

---

## 32. Security Skills & Scanners

| Name | URL | Description |
|------|-----|-------------|
| Claude Code Security (Anthropic) | https://claude.com/solutions/claude-code-security | Built-in vuln scanning, 500+ vulns found |
| Trail of Bits Skills | https://github.com/trailofbits/skills | 12+ professional security-focused skills |
| claude-code-security-review | https://github.com/anthropics/claude-code-security-review | GitHub Action for security review |
| Security Scanner Plugin | https://github.com/harish-garg/security-scanner-plugin | GitHub-data-based scanning |
| Aikido Security | https://claude.com/plugins/aikido | SAST + secrets + IaC scanning |

---

## 33. Communication Channels (Telegram/Discord/iMessage)

| Name | URL | Description |
|------|-----|-------------|
| Claude Code Channels | https://code.claude.com/docs/en/channels | Official research preview (March 2026) |
| Telegram Channel Plugin | https://github.com/anthropics/claude-plugins-official/blob/main/external_plugins/telegram/README.md | Telegram bot bridge |
| Discord Channel Plugin | (official) | Discord bot bridge |
| iMessage Channel Plugin | (official) | iMessage bridge (added 1 week after launch) |

---

## 34. Browser Automation & E2E Testing

| Name | URL | Description |
|------|-----|-------------|
| Playwright MCP (@playwright/mcp) | https://claude.com/plugins/playwright | 25+ browser control tools via accessibility tree |
| Playwright CLI | (Microsoft, 2026) | Compact YAML snapshots, 4x fewer tokens |
| playwright-skill | https://github.com/lackeyjb/playwright-skill | CC skill for model-invoked browser automation |
| mcp-playwright | https://github.com/executeautomation/mcp-playwright | Automate browsers and APIs in Claude Desktop |
| Puppeteer MCP | (deprecated/archived) | Original browser automation (use Playwright instead) |
| Claude in Chrome | (MCP server) | Direct Chrome browser control |

---

## 35. LLM Gateways & Model Routers

| Name | URL | Description |
|------|-----|-------------|
| Claude Code Router (CCR) | (community) | Open-source proxy for intelligent model routing |
| LiteLLM | (community) | Python proxy routing across 100+ providers |
| OmniRoute | https://github.com/diegosouzapw/OmniRoute | AI gateway with routing, load balancing, caching |
| OpenRouter | (commercial) | Free models + routing for CC |
| Morphic LLM | https://www.morphllm.com/ | Cost optimization proxy |
| Native LLM Gateway | https://code.claude.com/docs/en/llm-gateway | Built-in CC gateway configuration |

---

## 36. CI/CD & GitHub Actions

| Name | URL | Description |
|------|-----|-------------|
| claude-code-action | https://github.com/anthropics/claude-code-action | Official GitHub Action (PR review, code impl, triage) |
| claude-code-security-review | https://github.com/anthropics/claude-code-security-review | Security-focused GitHub Action |
| HTTP Hooks CI/CD | (native) | CC hooks for CI/CD integration |
| /install-github-app | (built-in) | One-command GitHub app setup |

---

## 37. Awesome Lists & Curated Directories

| Name | URL | Stars | Entries |
|------|-----|-------|---------|
| hesreallyhim/awesome-claude-code | https://github.com/hesreallyhim/awesome-claude-code | 35.9k | 200+ |
| rohitg00/awesome-claude-code-toolkit | https://github.com/rohitg00/awesome-claude-code-toolkit | 8k+ | 850+ files |
| wong2/awesome-mcp-servers | https://github.com/wong2/awesome-mcp-servers | 3.6k | 500+ |
| andyrewlee/awesome-agent-orchestrators | https://github.com/andyrewlee/awesome-agent-orchestrators | 500+ | 96 projects |
| davila7/claude-code-templates | https://github.com/davila7/claude-code-templates | 3k+ | 1000+ components |
| Chat2AnyLLM/awesome-claude-skills | https://github.com/Chat2AnyLLM/awesome-claude-skills | 500+ | Varies |
| travisvn/awesome-claude-skills | https://github.com/travisvn/awesome-claude-skills | 300+ | Varies |
| ComposioHQ/awesome-claude-skills | https://github.com/ComposioHQ/awesome-claude-skills | 200+ | Varies |
| VoltAgent/awesome-agent-skills | https://github.com/VoltAgent/awesome-agent-skills | 2k+ | 1000+ |
| VoltAgent/awesome-openclaw-skills | https://github.com/VoltAgent/awesome-openclaw-skills | 1.5k+ | 5400+ |
| VoltAgent/awesome-design-md | https://github.com/VoltAgent/awesome-design-md | 4.3k | 55+ brands |
| gmh5225/awesome-skills | https://github.com/gmh5225/awesome-skills | 300+ | Varies |
| jqueryscript/awesome-claude-code | https://github.com/jqueryscript/awesome-claude-code | 200+ | Varies |
| Picrew/awesome-agent-harness | https://github.com/Picrew/awesome-agent-harness | 200+ | Varies |
| tolkonepiu/best-of-mcp-servers | https://github.com/tolkonepiu/best-of-mcp-servers | 500+ | Ranked weekly |
| e2b-dev/awesome-ai-agents | https://github.com/e2b-dev/awesome-ai-agents | 10k+ | Varies |
| daymade/claude-code-skills | https://github.com/daymade/claude-code-skills | 200+ | Varies |
| chauncygu/collection-claude-code-source-code | https://github.com/chauncygu/collection-claude-code-source-code | 300+ | Source code collection |

---

## 38. Alternative / Complementary Coding Agents

| Name | Description | Relationship to CC |
|------|-------------|-------------------|
| Cursor | IDE with Background Agents, AI-native editor | Complementary (daily coding) |
| Windsurf (Codeium) | Agentic IDE with Cascade | Complementary (refactoring) |
| GitHub Copilot | Agent Mode + PR reviews | Complementary (enterprise) |
| OpenAI Codex | Cloud-based agent with desktop app | Alternative CLI agent |
| Google Antigravity | Multi-agent IDE, adopted CC skill standard | Alternative IDE |
| Gemini CLI | Google's terminal agent, Plan Mode default | Alternative CLI agent |
| OpenCode | Open-source terminal coding agent | Alternative CLI agent |
| Kiro (AWS) | AWS-backed coding IDE | Alternative IDE |
| Amp | Terminal coding agent | Alternative CLI agent |
| Replit Agent | Browser-based coding agent | Alternative (browser) |

---

## 39. Ralph Wiggum Loop Resources

| Name | URL | Description |
|------|-----|-------------|
| awesome-ralph | https://github.com/snwfdhmp/awesome-ralph | Curated Ralph technique resources |
| Ralph for Claude Code | https://github.com/frankbria/ralph-claude-code | Autonomous framework with exit detection |
| Ralph Wiggum Marketer | https://github.com/muratcankoylan/ralph-wiggum-marketer | Autonomous copywriter with knowledge bases |
| ralph-orchestrator | https://github.com/mikeyobrien/ralph-orchestrator | Robust orchestration for autonomous tasks |
| ralph-wiggum-bdd | https://github.com/marcindulak/ralph-wiggum-bdd | BDD with Ralph Wiggum Loop |
| The Ralph Playbook | https://github.com/ClaytonFarr/ralph-playbook | Detailed guide with theory and practice |

---

## 40. Voice & Speech Tools

| Name | URL | Description |
|------|-----|-------------|
| VoiceMode MCP | https://github.com/mbailey/voicemode | Natural voice conversations for CC |
| stt-mcp-server-linux | https://github.com/marcindulak/stt-mcp-server-linux | Push-to-talk speech transcription for Linux |

---

## 41. Design System Generators

| Name | URL | Description |
|------|-----|-------------|
| VoltAgent awesome-design-md | https://github.com/VoltAgent/awesome-design-md | 55+ brand DESIGN.md files for AI UI generation |
| Figma MCP (design-to-code) | (Figma official) | Full design-to-code workflow |
| Design Review Workflow | https://github.com/OneRedOak/claude-code-workflows/tree/main/design-review | Automated UI/UX design review |

---

## 42. Learning & Documentation Resources

| Name | URL | Description |
|------|-----|-------------|
| Claude Code Ultimate Guide | https://github.com/FlorianBruniaux/claude-code-ultimate-guide | Beginner to power user with templates |
| Claude Code Documentation Mirror | https://github.com/ericbuess/claude-code-docs | Auto-updated Anthropic docs mirror |
| Claude Code System Prompts | https://github.com/Piebald-AI/claude-code-system-prompts | Full CC system prompt including sub-agents |
| Claude Code Tips | https://github.com/ykdojo/claude-code-tips | 35+ information-dense tips |
| Claude Code Repos Index | https://github.com/danielrosehill/Claude-Code-Repos-Index | Index of 75+ CC repositories |
| Claude Code Handbook | https://nikiforovall.blog/claude-code-rules/ | Best practices and techniques |
| Learn Claude Code | https://github.com/shareAI-lab/learn-claude-code | Analysis of coding agents reconstructed in Python |
| learn-faster-kit | https://github.com/cheukyin175/learn-faster-kit | FASTER approach educational framework |
| Claude Code Agent Teams Exercises | https://github.com/panaversity/claude-code-agent-teams-exercises | 6 exercises + 2 capstones on teams |
| claude-howto | https://github.com/luongnv89/claude-howto | Visual example-driven guide |
| Claude Code Guide (Cranot) | https://github.com/Cranot/claude-code-guide | Live auto-updated CLI guide |

---

## MCP Server Marketplace & Registry Portals

| Name | URL | Description |
|------|-----|-------------|
| Official MCP Registry | https://registry.modelcontextprotocol.io | Canonical MCP server registry |
| mcpservers.org | https://mcpservers.org | Community MCP server directory |
| MCP Market | https://mcpmarket.com | Skills and servers marketplace |
| PulseMCP | https://www.pulsemcp.com | MCP server discovery |
| FastMCP | https://fastmcp.me | Skills directory and details |
| Claude Marketplaces | https://claudemarketplaces.com | Plugin marketplace aggregator |
| Claude Plugin Hub | https://www.claudepluginhub.com | Plugin discovery |
| aitmpl.com | https://www.aitmpl.com | CC templates web interface |
| Awesome Skills | https://www.awesomeskills.dev | Skill search and discovery |
| awesomeclaude.ai | https://awesomeclaude.ai | Visual CC directory |

---

## Composio Integration Hub (500+ apps)

Composio provides a single MCP URL to connect 500+ apps with Claude Code. Key integrations include:

- **Dev:** GitHub, GitLab, Bitbucket, Jira, Linear, Sentry, Figma, Vercel, Netlify
- **Communication:** Slack, Discord, Microsoft Teams, Google Chat, WhatsApp, Telegram
- **Productivity:** Notion, Confluence, Google Workspace, Microsoft 365, Miro
- **CRM/Sales:** Salesforce, HubSpot, Pipedrive
- **Finance:** Stripe, Shopify, QuickBooks
- **Social:** X (Twitter), Instagram, TikTok, Meta/Facebook
- **AI:** Various AI model connectors
- **Storage:** Google Drive, Dropbox, OneDrive, Box

URL: https://composio.dev/toolkits

---

## Statistics

- **Total unique tools/projects cataloged:** ~420+
- **Categories:** 42 primary + sub-categories
- **Official Anthropic repos:** 22+
- **Official marketplace plugins:** 101 (33 Anthropic + 68 partner)
- **MCP servers in official registry:** 10,000+ public (50+ official)
- **OpenClaw registry skills:** 13,729+
- **Awesome lists tracked:** 18+
- **Composio integrations:** 500+ apps

---

*Last updated: 2026-04-12. Sources: GitHub repos, official Anthropic docs, MCP Registry, awesome lists, community reviews, mcpmarket.com, composio.dev, awesomeclaude.ai.*
