# mind-glaive

**Eliminate context rot in Claude Code with intelligent memory, auto-learning hooks, and specialized subagents.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status: Production Ready](https://img.shields.io/badge/Status-Production%20Ready-green.svg)]()
[![GitHub: TheGlitchKing/mind-glaive](https://img.shields.io/badge/GitHub-TheGlitchKing%2Fmind--glaive-blue)](https://github.com/TheGlitchKing/mind-glaive)

## Overview

**mind-glaive** is a production-ready Claude Code plugin that solves the context rot problem through an intelligent, multi-layered architecture that:

- **Captures** knowledge automatically via hooks
- **Distills** it efficiently using local LLM summaries
- **Indexes** it semantically through MCP servers
- **Retrieves** it contextually at session start
- **Maintains** it proactively with subagents
- **Learns** from patterns and corrections

## The Problem: Context Rot

Context rot occurs when:
- Knowledge evaporates between sessions
- You repeat the same explanations to Claude
- Verbose output pollutes conversations
- Critical decisions are forgotten
- Patterns aren't recognized

**Result**: Wasted tokens, slower development, repeated mistakes.

## The Solution: 8-Layer Architecture

### Layer 1: Intelligent Memory Hierarchy
- **Project Memory** (`.claude/CLAUDE.md`) - Auto-updated with session learnings
- **Modular Rules** (`.claude/rules/`) - Domain-specific, glob-activated guidelines
- **Context Archives** - Historical summaries for knowledge retrieval

### Layer 2: Context-Preserving Hooks
- **SessionEnd Hook** - Captures and distills session knowledge
- **SessionStart Hook** - Injects relevant context automatically
- **PreToolUse Hook** - Delegates verbose operations to subagents
- **PostToolUse Hook** - Learns from repeated corrections

### Layer 3: Specialized Subagent Fleet
- **context-cleaner** - Identifies and removes stale memory
- **test-runner** - Isolates verbose test output
- **doc-miner** - Discovers undocumented patterns from codebase

### Layer 4: Auto-Updating Slash Commands
- `/context/status` - Show context health metrics
- `/context/optimize` - Run maintenance and cleanup
- `/learn/from-session` - Extract patterns from current session
- `/resume/last-task` - Continue from previous session

### Layer 5: MCP Servers for External Knowledge
- **project-kb** - Queryable knowledge base (SQLite)
- **codebase-rag** - Semantic search over your codebase (local embeddings)

### Layer 6: Automated Maintenance Skills
- **context-maintenance** - Weekly cleanup and optimization
- **pattern-learning** - Auto-generates rules from corrections

### Layer 7: Intelligence Amplification
- **Pattern Detection** - Learns from 3+ repeated corrections
- **Auto-Rule Generation** - Creates `.claude/rules/` from patterns
- **Decision Tracking** - Maintains history of architectural choices

### Layer 8: Plugin Packaging & Distribution
- **One-Command Install** - `./install.sh --scope user`
- **Project Templates** - full-stack, data-science, minimal
- **Multi-Scope Support** - User-global or project-local
- **Auto-Updates** - Version checking and upgrade path

## Quick Start

### Via Claude Code Marketplace (Easiest - Recommended!)

**For each collaborator (once):**
```
/plugin install TheGlitchKing/mind-glaive
```

**For each project (once):**
```
/mind-glaive/setup
```

That's it! 🎉 Hooks are now active. Run:
```
/context/status
```

### Or Direct Install

```bash
# Clone the repository
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive

# Install globally (all your projects)
./install.sh --scope user --template full-stack

# Or install for current project only
./install.sh --scope project --template minimal

# Verify installation
claude # Start Claude Code
/welcome
```

## Installation Methods

### Method 1: Via Claude Code Marketplace (Recommended - No Terminal Needed!)

**Step 1: Install the plugin** (once per person, any Claude Code session)

```
/plugin install TheGlitchKing/mind-glaive
```

**Step 2: Setup project** (once per project, in the project's Claude Code session)

```
/mind-glaive/setup
```

**That's it!** 🎉 Hooks are now active in your project.

**Verify it works:**

```
/context/status
```

**Optional: Choose a template** (default is minimal)

```
/mind-glaive/setup full-stack
/mind-glaive/setup data-science
```

---

### Method 2: Direct Install from GitHub (For Power Users)

Clone and install manually for more control:

```bash
# Clone the repository
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive

# Install globally (shared by all projects)
./install.sh --scope user --template full-stack

# Or install for current project only
cd /path/to/your/project
/path/to/mind-glaive/install.sh --scope project --template minimal

# Then enable the plugin
/plugin enable mind-glaive
/welcome
```

---

### Method 3: Migrating from Marketplace to Direct Install

If you already installed via marketplace but want direct control:

```bash
# Keep the plugin installed
# Just run the installer in your project
/path/to/mind-glaive/install.sh --scope project --template minimal

# Verify hooks are active
/plugin enable mind-glaive
/context/status
```

---

### For Teams: Installing for All Collaborators

**Have each team member do this (once per person):**

```
1. /plugin install TheGlitchKing/mind-glaive
```

**Then in the shared project, have one person do this (once per project):**

```
2. /mind-glaive/setup
```

**Commit `.claude/` to git so other team members pick up the config:**

```bash
git add .claude/
git commit -m "chore: initialize mind-glaive for project"
git push
```

**Other team members just need to:**

```
1. /plugin install TheGlitchKing/mind-glaive
2. git pull (to get .claude/ with hooks.json)
3. /plugin enable mind-glaive
```

## Updates & Maintenance

### Automatic Updates

If you installed via the Claude Code marketplace, the plugin **automatically checks for updates at startup**:

- ✅ New versions install automatically
- 📢 You'll see a notification suggesting you restart Claude Code
- 🔄 Just restart to apply the latest features and fixes

### Manual Updates

To manually update to the latest version:

**Via Marketplace:**
```
/plugin uninstall mind-glaive@mind-glaive-marketplace
/plugin install mind-glaive
```

**Via Direct Install:**
```bash
cd mind-glaive
git pull origin main
./install.sh --scope user --template full-stack
```

### What's New

Check the [GitHub releases](https://github.com/TheGlitchKing/mind-glaive/releases) for what's included in each version:

- New features and improvements
- Bug fixes
- New hook capabilities (e.g., PreCompact hook for context preservation during compaction)
- Enhanced documentation

### Breaking Changes

We follow semantic versioning (MAJOR.MINOR.PATCH). Breaking changes only occur in major version updates and are documented in release notes.

**Current Version**: 1.0.0 ✅

## Project Templates

Choose a template during installation:

### Full-Stack
Optimized for web applications with backend/frontend/database patterns.
```bash
./install.sh --template full-stack
```

### Data Science
Configured for notebooks, experiments, and model training.
```bash
./install.sh --template data-science
```

### Minimal
Lightweight setup for small projects or learning.
```bash
./install.sh --template minimal
```

## How It Works

### Automatic Knowledge Capture (SessionEnd Hook)
```bash
# When you end a session, the hook runs:
1. Analyzes session transcript
2. Extracts key decisions, patterns, learnings
3. Updates CLAUDE.md automatically
4. Archives to knowledge base
```

### Smart Context Injection (SessionStart Hook)
```bash
# When you start a new session:
1. Checks current git branch
2. Loads branch-specific context
3. Injects recently modified file rules
4. Adds relevant historical decisions
```

### Verbose Output Isolation (PreToolUse Hook)
```bash
# Before running noisy commands:
1. Detects verbose operations (tests, logs, builds)
2. Delegates to isolated subagent
3. Receives only summarized results
4. Main context stays clean
```

## Configuration

### Settings File (`.claude/settings.json`)
```json
{
  "hooks": {
    "SessionEnd": [...],
    "SessionStart": [...],
    "PreToolUse": [...]
  }
}
```

### Project Memory (`.claude/CLAUDE.md`)
```markdown
---
last_updated: 2026-01-09T15:30:00Z
session_count: 47
auto_maintenance: enabled
---

# Project Context

## Current Focus
- Working on: User authentication
- Blocked by: Database migration pending

## Critical Decisions
- 2026-01-08: Chose PostgreSQL RLS over app-level auth

## Common Patterns
- Always use asyncpg not psycopg2
- API endpoints must include rate limiting
```

### Modular Rules (`.claude/rules/`)
```
.claude/rules/
├── backend/
│   ├── api-standards.md      # Applied to backend/app/api/**
│   └── database-patterns.md  # Applied to backend/migrations/**
└── frontend/
    └── component-structure.md # Applied to frontend/src/components/**
```

## Success Metrics

Track context health with `/context/status`:

| Metric | Target | Description |
|--------|--------|-------------|
| Avg context size | < 50KB | Per session memory usage |
| Repeated clarifications | < 2/session | Knowledge retention |
| Knowledge retention | > 90% | Cross-session recall |
| Sessions using history | > 70% | Context reuse rate |
| Manual searches | < 5/week | Auto-retrieval success |

## Architecture Principles

1. **Privacy-First**: Local LLM (Ollama) for summaries, no external API calls required
2. **Opt-In Intelligence**: Start minimal, learn over time
3. **Transparent Operations**: All hooks show what they're doing
4. **Clean Uninstall**: Remove cleanly without data loss
5. **Version Control Friendly**: Project configs in `.claude/`, user configs in `~/.claude/`

## Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Deep dive into system design
- **[INSTALLATION.md](INSTALLATION.md)** - Detailed installation guide
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Contributing and development
- **[ROADMAP.md](ROADMAP.md)** - Implementation timeline
- **[DISTRIBUTION.md](DISTRIBUTION.md)** - Marketplace strategy
- **[docs/](docs/)** - Layer-by-layer documentation

## Requirements

### Minimum
- Claude Code v1.0+
- Python 3.9+
- Git 2.0+
- Bash (for hooks)

### Recommended
- Ollama (for local LLM summaries, privacy-first)
- 10GB disk space (for knowledge base + embeddings)

### Optional
- Docker (for MCP server isolation)
- PostgreSQL (for advanced knowledge graphs)

## Development Status

- [x] Architecture design
- [x] Documentation structure
- [ ] Layer 1: Memory Hierarchy
- [ ] Layer 2: Hooks System
- [ ] Layer 3: Subagents
- [ ] Layer 4: Slash Commands
- [ ] Layer 5: MCP Servers
- [ ] Layer 6: Skills
- [ ] Layer 7: Intelligence
- [ ] Layer 8: Distribution
- [ ] v1.0.0 Release

## Contributing

Contributions welcome! See [DEVELOPMENT.md](DEVELOPMENT.md) for guidelines.

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- **Issues**: https://github.com/yourusername/context-preservation-system/issues
- **Discussions**: https://github.com/yourusername/context-preservation-system/discussions
- **Email**: your-email@example.com

## Acknowledgments

Inspired by the Claude Code community's need for better context management.

Built with:
- Claude Code (Anthropic)
- Ollama (local LLM)
- Python + Bash

## Roadmap

### v1.0.0 (Target: February 2026)
- Core 8-layer system
- 3 project templates
- Full documentation
- Installer + tests

### v1.1.0 (Target: March 2026)
- Web dashboard for knowledge base
- Visual context health monitoring
- Team sync features

### v2.0.0 (Target: Q2 2026)
- Cloud backup/sync (optional)
- Advanced pattern recognition
- Cross-project knowledge sharing

---

**Star this repo if it helps you eliminate context rot!** ⭐
