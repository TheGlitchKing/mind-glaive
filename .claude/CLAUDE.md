# mind-glaive - Project Instructions

**Project**: Claude Code Plugin to Eliminate Context Rot
**Status**: Complete & Production Ready - v1.0.0
**Repository**: https://github.com/TheGlitchKing/mind-glaive

---

## 🎯 Project Goal

Build a production-ready Claude Code plugin that **eliminates context rot** through intelligent memory management, auto-learning hooks, and specialized subagents.

---

## 📚 Documentation Overview

**Start Here** (in order):
1. **[README.md](../README.md)** - Project overview and features (10 min read)
2. **[ARCHITECTURE.md](../ARCHITECTURE.md)** - Deep dive into 8-layer system (20 min read)
3. **[ROADMAP.md](../ROADMAP.md)** - 8-week implementation timeline (15 min read)
4. **[IMPLEMENTATION_GUIDE.md](../IMPLEMENTATION_GUIDE.md)** - Step-by-step build instructions (30 min read)

**Key Principles**:
- Privacy-first (local LLM via Ollama)
- Transparent operations (user always knows what's happening)
- Opt-in intelligence (start minimal, learn over time)
- Clean uninstall (no orphaned data)

---

## 🏗️ Architecture (8 Layers)

1. **Memory Hierarchy** - CLAUDE.md + modular rules + archives
2. **Hooks System** - SessionStart/End, PreToolUse, PostToolUse
3. **Subagents** - context-cleaner, test-runner, doc-miner
4. **Slash Commands** - /context/*, /learn/*, /resume/*
5. **MCP Servers** - project-kb (SQLite), codebase-rag (embeddings)
6. **Skills** - context-maintenance, pattern-learning
7. **Intelligence** - Auto-learning from corrections
8. **Distribution** - One-command install, templates, marketplace

---

## 📅 Current Phase: Week 1 - Layer 1 (Memory Hierarchy)

### Goals
- [x] Complete documentation (README, ARCHITECTURE, ROADMAP, IMPLEMENTATION_GUIDE)
- [ ] Create CLAUDE.md template structure
- [ ] Build modular rules system with glob matching
- [ ] Implement archive directory structure
- [ ] Add metadata tracking (session_count, last_updated)

### Tasks This Session
1. Create directory structure for templates and rules
2. Build `templates/minimal/CLAUDE.md` template
3. Build `templates/full-stack/CLAUDE.md` template
4. Create example rule files demonstrating glob matching
5. Test YAML frontmatter parsing
6. Document Layer 1 in `docs/LAYER_1_MEMORY.md`

### Success Criteria
- ✅ CLAUDE.md template with working YAML frontmatter
- ✅ 3-5 example rules with path glob matching
- ✅ Archive structure ready
- ✅ Metadata tracking functional
- ✅ Documentation complete

---

## 🛠️ Development Guidelines

### Code Style

**Bash Scripts**:
```bash
#!/bin/bash
set -e  # Exit on error
# Clear comments
# Test with shellcheck
```

**Python**:
```python
# Python 3.9+ compatible
# Type hints required
# Docstrings for all functions
# Lint with ruff
```

**Markdown/YAML**:
```yaml
---
# YAML frontmatter for rules
paths: ["**/*.py"]
priority: 10
---

# Markdown content
Keep rules under 2KB for context efficiency
```

### Testing Requirements
- Unit tests where applicable
- Integration tests for each layer
- Manual testing checklist
- Performance benchmarks (context size, hook timing)

### File Organization
```
anti-context-rot/
├── docs/              # Layer documentation
├── agents/            # Subagent definitions
├── commands/          # Slash commands
├── skills/            # Skills
├── scripts/           # Hook scripts
├── templates/         # Project templates
├── mcp-servers/       # MCP servers
├── hooks/             # Hook configs
├── examples/          # Real-world examples
└── tests/             # Test suite
```

---

## 📐 Layer 1 Specifications

### CLAUDE.md Template Structure

```yaml
---
last_updated: 2026-01-09T00:00:00Z
session_count: 0
auto_maintenance: enabled
next_cleanup: 2026-01-16T00:00:00Z
template: minimal|full-stack|data-science
version: 1.0.0
---

# Project Context

## Current Focus
<!-- Auto-updated by SessionEnd hook -->
<!-- Format: Bulleted list of active work -->

## Critical Decisions
<!-- Permanent record of architectural choices -->
<!-- Format: YYYY-MM-DD: Decision (rationale) -->

## Common Patterns
<!-- Learned from 3+ corrections -->
<!-- Auto-populated by pattern-learning skill -->
<!-- Format: Pattern name - description -->

## Known Issues & Workarounds
<!-- Auto-captured from error patterns -->
<!-- Format: Issue → Workaround -->

## Team Conventions
<!-- Shared coding standards -->
<!-- Optional: Remove for solo projects -->
```

### Rule File Structure

```yaml
---
paths: ["backend/app/api/**/*.py"]  # Glob pattern
priority: 10                         # Higher = loaded first
description: API endpoint standards
tags: [backend, api, fastapi]       # For categorization
---

# API Endpoint Standards

Keep under 2KB total.

## Required Patterns
- Rate limiting decorator
- Pydantic validation
- Standard error responses

## Examples
```python
@router.post("/endpoint")
@rate_limit(100, 60)  # 100 req/min
async def endpoint(data: Model):
    ...
```
```

### Archive Structure

```
.claude/archives/
├── README.md
├── 2026-01.md     # Monthly summaries
├── 2026-02.md
└── decisions/      # Decision history (optional deep dive)
    ├── 2026-01-auth.md
    └── 2026-01-database.md
```

---

## 🎯 Success Metrics

### Technical Metrics
| Metric | Target | How to Measure |
|--------|--------|----------------|
| Context size | < 50KB/session | `/context/status` |
| Hook execution | < 10s (start), < 30s (end) | Time command |
| Pattern accuracy | > 80% | Manual validation |
| Test coverage | > 70% | pytest --cov |

### User Experience
- Install time: < 5 minutes
- Zero config for minimal template
- Clear error messages
- Helpful documentation

---

## 🔄 Weekly Workflow

### Daily (Week 1-7)
1. Check current phase in ROADMAP.md
2. Pick next task
3. Implement with tests
4. Document in layer-specific doc
5. Commit with clear message

### Weekly Review
1. Demo working features
2. Update progress in ROADMAP.md
3. Adjust timeline if needed
4. Plan next week

### Milestones
- **End Week 3**: Core system working (Layers 1-3)
- **End Week 5**: Full feature complete (Layers 1-7)
- **End Week 7**: Distribution ready (Layer 8)
- **End Week 8**: Public launch (v1.0.0)

---

## 📝 Commit Message Format

```
type(scope): brief description

Detailed explanation of changes.

- File changes
- Testing performed
- Related issues/docs

Example:
feat(layer1): add CLAUDE.md template system

Create template structure with YAML frontmatter support.

- Add templates/minimal/CLAUDE.md
- Add templates/full-stack/CLAUDE.md
- Implement metadata tracking
- Test YAML parsing

Closes #1
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`

---

## 🚨 Important Reminders

1. **Keep rules under 2KB** - Context efficiency critical
2. **Test on all platforms** - macOS, Linux, Windows (WSL)
3. **Privacy-first** - Default to local Ollama, not external APIs
4. **Document as you build** - Update layer docs immediately
5. **Benchmark performance** - Track context size and hook timing

---

## 🔗 Quick Links

- **GitHub** (future): https://github.com/yourusername/context-preservation-system
- **Issues**: Track bugs and feature requests
- **Discussions**: Design discussions and Q&A
- **Wiki**: Additional documentation

---

## 🤝 For New Sessions

When starting a fresh Claude Code session in this directory:

1. **Read this file first** - Understand current status
2. **Check ROADMAP.md** - See current phase
3. **Review IMPLEMENTATION_GUIDE.md** - Get specific tasks
4. **Build systematically** - Follow layer order
5. **Test thoroughly** - Every component needs tests
6. **Document immediately** - Don't defer documentation

---

## 📊 Current Status

**Documentation**: ✅ Complete
**Implementation**: ⏳ Ready to start

**Next Steps**:
1. Create directory structure
2. Build `templates/minimal/CLAUDE.md`
3. Create example rule files
4. Test YAML frontmatter parsing
5. Document Layer 1

**Target v1.0.0 Release**: 2026-03-06 (8 weeks from 2026-01-09)

---

**Let's build! 🚀**
