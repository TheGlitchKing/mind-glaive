# Implementation Guide - Getting Started

**For**: Developers building the Context Preservation System
**Start Here**: After reading README.md and ARCHITECTURE.md

---

## Quick Start for New Claude Session

When you open a new Claude Code session in this directory, use this guide to understand what to build and how.

---

## Project Structure (To Be Built)

```
anti-context-rot/
├── README.md                    ✅ Complete
├── ARCHITECTURE.md              ✅ Complete
├── ROADMAP.md                   ✅ Complete
├── IMPLEMENTATION_GUIDE.md      ✅ This file
│
├── plugin.json                  ⏳ To build
├── install.sh                   ⏳ To build
├── uninstall.sh                 ⏳ To build
├── LICENSE                      ⏳ To build
│
├── agents/                      ⏳ Layer 3
│   ├── context-cleaner.md
│   ├── test-runner.md
│   ├── doc-miner.md
│   └── README.md
│
├── commands/                    ⏳ Layer 4
│   ├── context/
│   │   ├── status.md
│   │   ├── optimize.md
│   │   └── reset.md
│   ├── learn/
│   │   ├── from-session.md
│   │   └── from-codebase.md
│   ├── resume/
│   │   ├── last-task.md
│   │   └── branch.md
│   └── README.md
│
├── skills/                      ⏳ Layer 6
│   ├── context-maintenance.md
│   ├── pattern-learning.md
│   └── README.md
│
├── mcp-servers/                 ⏳ Layer 5
│   ├── project-kb/
│   │   ├── server.py
│   │   ├── requirements.txt
│   │   ├── schema.sql
│   │   └── README.md
│   ├── codebase-rag/
│   │   ├── server.py
│   │   ├── requirements.txt
│   │   └── README.md
│   └── README.md
│
├── scripts/                     ⏳ Layer 2
│   ├── capture-session-knowledge.sh
│   ├── inject-session-context.sh
│   ├── learn-from-corrections.sh
│   ├── check-updates.sh
│   └── README.md
│
├── templates/                   ⏳ Layer 8
│   ├── full-stack/
│   │   ├── CLAUDE.md
│   │   ├── rules/
│   │   └── README.md
│   ├── data-science/
│   ├── minimal/
│   └── README.md
│
├── hooks/                       ⏳ Layer 2
│   ├── default-hooks.json
│   ├── advanced-hooks.json
│   └── README.md
│
├── docs/                        ⏳ Layer docs
│   ├── LAYER_1_MEMORY.md
│   ├── LAYER_2_HOOKS.md
│   ├── LAYER_3_SUBAGENTS.md
│   ├── LAYER_4_COMMANDS.md
│   ├── LAYER_5_MCP.md
│   ├── LAYER_6_SKILLS.md
│   ├── LAYER_7_INTELLIGENCE.md
│   ├── LAYER_8_DISTRIBUTION.md
│   ├── INSTALLATION.md
│   ├── DEVELOPMENT.md
│   ├── DISTRIBUTION.md
│   ├── METRICS.md
│   ├── TROUBLESHOOTING.md
│   └── FAQ.md
│
├── examples/                    ⏳ Examples
│   ├── investorhub-setup/
│   ├── simple-api/
│   └── ml-research/
│
└── tests/                       ⏳ Testing
    ├── test-install.sh
    ├── test-uninstall.sh
    └── README.md
```

---

## Implementation Order (8 Weeks)

### Week 1: Layer 1 - Memory Hierarchy

**Goal**: Create the foundation for context storage

**Tasks**:
1. Create template `CLAUDE.md` structure
2. Build modular rules system with YAML frontmatter
3. Implement archive directory structure
4. Add metadata tracking

**Files to Create**:
```
templates/minimal/CLAUDE.md
templates/minimal/rules/example-rule.md
templates/full-stack/CLAUDE.md
templates/full-stack/rules/backend/api-standards.md
templates/full-stack/rules/frontend/component-structure.md
docs/LAYER_1_MEMORY.md
```

**Example: `templates/minimal/CLAUDE.md`**
```markdown
---
last_updated: 2026-01-09T00:00:00Z
session_count: 0
auto_maintenance: enabled
next_cleanup: 2026-01-16T00:00:00Z
template: minimal
version: 1.0.0
---

# Project Context

## Current Focus
<!-- Auto-updated by SessionEnd hook -->

## Critical Decisions
<!-- Permanent record of architectural choices -->
<!-- Format: YYYY-MM-DD: Decision -->

## Common Patterns
<!-- Learned from 3+ corrections -->
<!-- Auto-populated by pattern-learning skill -->

## Known Issues & Workarounds
<!-- Auto-captured from error patterns -->
```

**Example: `templates/minimal/rules/example-rule.md`**
```yaml
---
paths: ["**/*.py"]
priority: 5
description: Example rule demonstrating structure
---

# Example Rule

This is an example rule file showing the structure.

- Rules are written in Markdown
- Activated by path matching (glob patterns in frontmatter)
- Keep under 2KB for context efficiency
```

**Testing**:
```bash
# Test glob pattern matching
# Test CLAUDE.md YAML parsing
# Test archive creation
```

---

### Week 2: Layer 2 - Hooks System

**Goal**: Automate knowledge capture and injection

**Tasks**:
1. Write `capture-session-knowledge.sh` (SessionEnd)
2. Write `inject-session-context.sh` (SessionStart)
3. Create `default-hooks.json` configuration
4. Document Ollama integration

**Files to Create**:
```
scripts/capture-session-knowledge.sh
scripts/inject-session-context.sh
hooks/default-hooks.json
hooks/advanced-hooks.json
docs/LAYER_2_HOOKS.md
```

**Example: `scripts/capture-session-knowledge.sh`**
```bash
#!/bin/bash
# SessionEnd Hook: Capture session knowledge

# Input: JSON via stdin
# {
#   "session_id": "abc123",
#   "transcript_path": "~/.claude/projects/my-app/abc123/transcript.json",
#   "cwd": "/path/to/project"
# }

# Read input
INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
CWD=$(echo "$INPUT" | jq -r '.cwd')

# Check for Ollama
if command -v ollama &> /dev/null; then
    # Use local LLM for summary
    SUMMARY=$(cat "$TRANSCRIPT_PATH" | ollama run mistral:7b-instruct "
        Analyze this development session and extract:
        1. Important technical decisions
        2. Repeated patterns or corrections
        3. New learnings
        4. Blockers or unresolved issues

        Format as concise bullet points.
    ")
else
    # Fallback: Simple extraction
    SUMMARY="Session completed. Ollama not available for auto-summary."
fi

# Update CLAUDE.md
cd "$CWD"
if [ -f ".claude/CLAUDE.md" ]; then
    # Append to Current Focus
    echo "" >> .claude/CLAUDE.md
    echo "### Session $(date +%Y-%m-%d)" >> .claude/CLAUDE.md
    echo "$SUMMARY" >> .claude/CLAUDE.md
    echo "" >> .claude/CLAUDE.md
fi

# Output success
echo '{"status": "success", "summary_length": '$(echo "$SUMMARY" | wc -c)'}'
```

**Example: `hooks/default-hooks.json`**
```json
{
  "hooks": {
    "SessionEnd": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/scripts/capture-session-knowledge.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/scripts/inject-session-context.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

**Testing**:
```bash
# Test with mock transcript
# Test with/without Ollama
# Measure execution time
# Verify CLAUDE.md updates
```

---

### Week 3: Layer 3 - Subagents

**Goal**: Isolate verbose operations

**Tasks**:
1. Create `context-cleaner` subagent
2. Create `test-runner` subagent
3. Create `doc-miner` subagent
4. Add PreToolUse hook for delegation

**Files to Create**:
```
agents/context-cleaner.md
agents/test-runner.md
agents/doc-miner.md
agents/README.md
scripts/delegate-verbose-ops.sh
docs/LAYER_3_SUBAGENTS.md
```

**Example: `agents/context-cleaner.md`**
```yaml
---
name: context-cleaner
description: Analyzes project memory for outdated or redundant information and suggests cleanup
tools: Read, Grep, Glob
model: haiku
permissionMode: plan
---

# Context Cleaner Subagent

Analyze the project's `.claude/CLAUDE.md` and `.claude/rules/` files.

## Tasks

1. **Identify Stale Sections**
   - Find sections not referenced in last 90 days
   - Check for outdated decisions

2. **Find Duplicates**
   - Locate duplicate or contradictory rules
   - Identify redundant information

3. **Measure Verbosity**
   - Calculate total context size
   - Find overly verbose sections (>500 words)

4. **Pattern Validation**
   - Check "Common Patterns" section
   - Verify each pattern appears 3+ times in codebase

## Output Format

```markdown
# Context Cleanup Report

## Summary
- Total size: XXX KB
- Stale sections: X
- Duplicates found: X
- Recommended actions: X

## Stale Sections (>90 days)
- [ ] Section name (last referenced: YYYY-MM-DD)

## Duplicates
- [ ] Rule A and Rule B contain same information

## Recommendations
1. Archive sections older than 90 days to `.claude/archives/`
2. Consolidate duplicate rules
3. Condense verbose sections
```

## Constraints

- Read-only analysis (no modifications)
- Must complete in < 60 seconds
- Report should be actionable
```

**Testing**:
```bash
# Test with bloated CLAUDE.md (100KB+)
# Verify finds stale sections
# Check duplicate detection accuracy
# Measure execution time
```

---

### Week 4: Layer 4 - Slash Commands

**Goal**: User-friendly context management

**Tasks**:
1. Create 7 slash commands
2. Test each in isolation
3. Document usage

**Files to Create**:
```
commands/context/status.md
commands/context/optimize.md
commands/context/reset.md
commands/learn/from-session.md
commands/learn/from-codebase.md
commands/resume/last-task.md
commands/resume/branch.md
commands/README.md
docs/LAYER_4_COMMANDS.md
```

**Example: `commands/context/status.md`**
```yaml
---
description: Show current context health metrics and usage statistics
allowed-tools: Read, Bash
---

# Context Status Check

!bash
#!/bin/bash
echo "## 📊 Context Health Report"
echo ""
echo "**Memory Files:**"
echo "- Project Memory: $(wc -c < .claude/CLAUDE.md 2>/dev/null || echo 0) bytes"
echo "- Rules: $(find .claude/rules -name '*.md' 2>/dev/null | wc -l) files"
echo "- Archives: $(find .claude/archives -name '*.md' 2>/dev/null | wc -l) months"
echo ""
echo "**Session Stats:**"
grep "session_count:" .claude/CLAUDE.md 2>/dev/null | sed 's/session_count:/- Sessions:/' || echo "- Sessions: 0"
echo ""
echo "**Last Maintenance:**"
grep "next_cleanup:" .claude/CLAUDE.md 2>/dev/null | sed 's/next_cleanup:/- Scheduled:/' || echo "- Scheduled: Never"
echo ""
echo "**Recent Focus:**"
sed -n '/## Current Focus/,/## /p' .claude/CLAUDE.md 2>/dev/null | head -n 15 || echo "- No current focus tracked"
echo ""
echo "**Storage Breakdown:**"
echo "- Rules total: $(find .claude/rules -name '*.md' -exec wc -c {} + 2>/dev/null | tail -n 1 | awk '{print $1}') bytes"
echo "- Archives total: $(find .claude/archives -name '*.md' -exec wc -c {} + 2>/dev/null | tail -n 1 | awk '{print $1}') bytes"

Analyze this report and provide recommendations:

1. If total context > 50KB, suggest running `/context/optimize`
2. If rules > 20 files, suggest consolidation
3. If no recent maintenance, schedule cleanup
4. If current focus is empty, suggest updating workflow

Provide actionable next steps.
```

---

### Week 5: Layer 5 - MCP Servers

**Goal**: Queryable knowledge infrastructure

**Tasks**:
1. Build `project-kb` MCP server (SQLite)
2. Build `codebase-rag` MCP server (embeddings)
3. Create installation scripts
4. Document MCP tool usage

**Files to Create**:
```
mcp-servers/project-kb/server.py
mcp-servers/project-kb/requirements.txt
mcp-servers/project-kb/schema.sql
mcp-servers/project-kb/README.md
mcp-servers/codebase-rag/server.py
mcp-servers/codebase-rag/requirements.txt
mcp-servers/codebase-rag/README.md
mcp-servers/README.md
docs/LAYER_5_MCP.md
```

**Example: `mcp-servers/project-kb/schema.sql`**
```sql
-- Knowledge Base Schema

CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    summary TEXT,
    decisions TEXT, -- JSON array
    patterns TEXT,  -- JSON array
    embedding BLOB  -- For semantic search
);

CREATE TABLE IF NOT EXISTS decisions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    category TEXT,
    decision TEXT NOT NULL,
    rationale TEXT,
    session_id TEXT REFERENCES sessions(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern_name TEXT NOT NULL,
    first_seen DATE NOT NULL,
    occurrence_count INTEGER DEFAULT 1,
    rule_generated BOOLEAN DEFAULT FALSE,
    rule_file_path TEXT,
    last_occurrence DATE
);

CREATE INDEX idx_sessions_timestamp ON sessions(timestamp);
CREATE INDEX idx_decisions_date ON decisions(date);
CREATE INDEX idx_patterns_name ON patterns(pattern_name);
```

---

### Week 6: Layers 6-7 - Skills & Intelligence

**Goal**: Auto-learning and maintenance

**Tasks**:
1. Create maintenance skill
2. Create pattern learning skill
3. Build correction tracking
4. Implement auto-rule generation

**Files to Create**:
```
skills/context-maintenance.md
skills/pattern-learning.md
skills/README.md
scripts/learn-from-corrections.sh
docs/LAYER_6_SKILLS.md
docs/LAYER_7_INTELLIGENCE.md
```

---

### Week 7: Layer 8 - Distribution

**Goal**: One-command installation

**Tasks**:
1. Create plugin.json
2. Write install.sh
3. Write uninstall.sh
4. Create all 3 templates
5. Test on all platforms

**Files to Create**:
```
plugin.json
install.sh
uninstall.sh
LICENSE (MIT)
docs/LAYER_8_DISTRIBUTION.md
docs/INSTALLATION.md
docs/DEVELOPMENT.md
docs/DISTRIBUTION.md
```

---

### Week 8: Polish & Launch

**Goal**: v1.0.0 release

**Tasks**:
1. Complete all documentation
2. Set up GitHub repo
3. Add CI/CD
4. Create launch materials
5. Tag v1.0.0

---

## Development Guidelines

### Code Style

**Bash Scripts**:
- Use `#!/bin/bash` shebang
- Set `-e` for error handling
- Add comments for complex logic
- Test with `shellcheck`

**Python**:
- Python 3.9+ compatible
- Type hints required
- Docstrings for all functions
- Lint with `ruff`

**Markdown**:
- Use YAML frontmatter where needed
- Keep rules < 2KB
- Use examples liberally

### Testing

**Every component needs**:
- Unit tests where applicable
- Integration tests
- Manual testing checklist
- Performance benchmarks

### Documentation

**For each layer**:
- Layer-specific doc in `docs/LAYER_X.md`
- Examples in component README
- Troubleshooting section
- Usage examples

---

## Common Commands

### Development
```bash
# Test installer
./install.sh --scope project --template minimal

# Test hooks locally
bash scripts/capture-session-knowledge.sh < test-input.json

# Validate JSON
jq . hooks/default-hooks.json

# Lint bash
shellcheck scripts/*.sh

# Lint Python
ruff check mcp-servers/
```

### Testing
```bash
# Run all tests
./tests/test-install.sh
./tests/test-uninstall.sh

# Test on specific platform
docker run -it --rm -v $(pwd):/workspace ubuntu:22.04 /workspace/install.sh
```

---

## Questions?

When starting a new Claude session:

1. **Read**: README.md → ARCHITECTURE.md → ROADMAP.md → This file
2. **Check**: Current week's phase in ROADMAP.md
3. **Build**: Follow implementation order above
4. **Test**: Validate each component
5. **Document**: Update layer docs

**Current Status**: Documentation complete, ready for Phase 1 implementation.

**Next Step**: Start Week 1 - Build Layer 1 (Memory Hierarchy)

---

Good luck building! 🚀
