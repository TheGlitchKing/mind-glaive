# Context Preservation System - Architecture

**Version**: 1.0.0
**Last Updated**: 2026-01-09

## Table of Contents

- [Overview](#overview)
- [Core Philosophy](#core-philosophy)
- [8-Layer Architecture](#8-layer-architecture)
- [Data Flow](#data-flow)
- [Component Interactions](#component-interactions)
- [Security & Privacy](#security--privacy)
- [Performance Considerations](#performance-considerations)
- [Scalability](#scalability)

## Overview

The Context Preservation System (CPS) addresses context rot through a **multi-layered, self-learning architecture** that operates transparently in the background while you work.

### The Context Rot Problem

```
Session 1: "Use PostgreSQL RLS for security"
Session 2: "What did we decide for security?" ❌
Session 3: "Use PostgreSQL RLS" (repeated decision)
```

**Root Causes**:
1. **Memory evaporation** - Decisions lost between sessions
2. **Verbose pollution** - Test output clutters conversations
3. **Pattern blindness** - Repeated corrections not learned
4. **Context sprawl** - Information scattered across sessions

### The CPS Solution

```
Session 1: "Use PostgreSQL RLS for security"
         └─> [Hook] Captures decision to CLAUDE.md

Session 2: [Hook] Injects "Security: PostgreSQL RLS" at start
         └─> Claude already knows, no repeated explanation ✅
```

## Core Philosophy

### 1. **Privacy-First**
- Local Ollama for summaries (no external API calls)
- All data stays on your machine
- Optional cloud sync (explicit opt-in)

### 2. **Transparent Operations**
- Hooks log what they're doing
- `/context/status` shows health metrics
- All automation visible and controllable

### 3. **Opt-In Intelligence**
- Start minimal (Layer 1-2)
- Add layers as needed
- Disable features without breaking system

### 4. **Self-Improving**
- Learns from corrections
- Auto-generates rules
- Optimizes over time

## 8-Layer Architecture

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     USER INTERACTION                         │
│              (Claude Code Chat Interface)                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 4: SLASH COMMANDS                                    │
│  /context/status | /learn/from-session | /resume/last-task  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 2: HOOKS SYSTEM                                      │
│  SessionStart → SessionEnd → PreToolUse → PostToolUse       │
└──┬────────────────┬────────────────┬────────────────┬───────┘
   │                │                │                │
   ▼                ▼                ▼                ▼
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│  LAYER 1 │  │  LAYER 3 │  │  LAYER 5 │  │  LAYER 7 │
│  MEMORY  │  │ SUBAGENT │  │   MCP    │  │INTELLIGE │
│          │  │          │  │  SERVER  │  │   NCE    │
│ CLAUDE.md│  │  context │  │ project  │  │ Pattern  │
│  rules/  │  │  -cleaner│  │   -kb    │  │ Learning │
│ archives/│  │  test-run│  │ codebase │  │ Auto-Rule│
└──────────┘  │  doc-mine│  │   -rag   │  │   Gen    │
              └──────────┘  └──────────┘  └──────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 6: SKILLS                                            │
│  context-maintenance | pattern-learning                     │
└─────────────────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 8: DISTRIBUTION                                      │
│  install.sh | templates/ | plugin.json                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Layer 1: Intelligent Memory Hierarchy

### Components

#### 1.1 Project Memory (`CLAUDE.md`)
**Location**: `.claude/CLAUDE.md` (version controlled)

**Structure**:
```markdown
---
last_updated: 2026-01-09T15:30:00Z
session_count: 47
auto_maintenance: enabled
next_cleanup: 2026-01-16
---

# Project Context

## Current Focus
<!-- Auto-updated by SessionEnd hook -->

## Critical Decisions
<!-- Permanent record of architectural choices -->

## Common Patterns
<!-- Learned from 3+ corrections -->

## Known Issues & Workarounds
<!-- Auto-captured from error patterns -->

## Team Conventions
<!-- Shared coding standards -->
```

**Auto-Maintenance**:
- SessionEnd hook appends new learnings
- Weekly cleanup removes stale sections (>90 days)
- Archives old decisions to `.claude/archives/YYYY-MM.md`

#### 1.2 Modular Rules (`.claude/rules/`)
**Purpose**: Context-efficient, path-activated guidelines

**File Size Target**: < 2KB per rule (minimize context pollution)

**Activation**: YAML frontmatter with glob patterns
```yaml
---
paths: ["backend/app/api/**/*.py"]
priority: 10
---

# API Endpoint Standards

- Always include rate limiting decorator
- Use Pydantic models for validation
- Return standard error responses
```

**Directory Structure**:
```
.claude/rules/
├── _metadata.yaml          # Rule registry
├── backend/
│   ├── api-standards.md
│   ├── database-patterns.md
│   └── error-handling.md
├── frontend/
│   ├── component-structure.md
│   └── state-management.md
└── testing/
    ├── unit-tests.md
    └── integration-tests.md
```

#### 1.3 Context Archives
**Location**: `.claude/archives/`

**Monthly Summaries**:
```
archives/
├── 2026-01.md              # January session summaries
├── 2026-02.md
└── README.md
```

**Archive Structure**:
```markdown
# January 2026 Sessions

## Week 1 (Jan 1-7)
- **Focus**: User authentication refactor
- **Decisions**: Chose JWT over session cookies
- **Learnings**: Keycloak integration patterns

## Week 2 (Jan 8-14)
...
```

**Retrieval**: MCP server indexes archives for semantic search

---

## Layer 2: Context-Preserving Hooks

### Hook Lifecycle

```
┌─────────────────────────────────────────────────────┐
│  SESSION START                                      │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ SessionStart Hook    │
        │ - Load branch context│
        │ - Inject recent rules│
        │ - Add decisions      │
        └──────────┬───────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  MAIN CONVERSATION                                  │
│  (Claude + User)                                    │
└───┬──────────────────────────────────┬──────────────┘
    │                                  │
    │ Tool Use Requested               │ Tool Completed
    ▼                                  ▼
┌──────────────────┐            ┌──────────────────┐
│ PreToolUse Hook  │            │ PostToolUse Hook │
│ - Delegate noisy │            │ - Track patterns │
│ - Validate ops   │            │ - Learn from edits│
└──────────────────┘            └──────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ SessionEnd Hook      │
        │ - Extract learnings  │
        │ - Update CLAUDE.md   │
        │ - Archive summary    │
        └──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  SESSION END                                        │
└─────────────────────────────────────────────────────┘
```

### Hook Implementations

#### 2.1 SessionEnd Hook
**File**: `scripts/capture-session-knowledge.sh`

**Input** (stdin JSON):
```json
{
  "session_id": "abc123",
  "transcript_path": "~/.claude/projects/my-app/abc123/transcript.json",
  "cwd": "/path/to/project",
  "hook_event_name": "SessionEnd"
}
```

**Process**:
1. Read transcript
2. Use Ollama (mistral:7b-instruct) to analyze
3. Extract: decisions, patterns, learnings, blockers
4. Append to CLAUDE.md
5. Store in knowledge base

**Output**:
```json
{
  "status": "success",
  "decisions_captured": 3,
  "patterns_found": 2,
  "memory_updated": true
}
```

#### 2.2 SessionStart Hook
**File**: `scripts/inject-session-context.sh`

**Process**:
1. Get current git branch
2. Load `.claude/context/branch-{name}.md` if exists
3. Get recently modified files (last 5 commits)
4. Find matching rules in `.claude/rules/`
5. Load relevant decisions from CLAUDE.md
6. Output context to inject

**Output** (stdout):
```markdown
## Session Context (Auto-Injected)

**Branch**: feature/user-auth
**Recent Focus**: Authentication system refactor

**Relevant Decisions**:
- 2026-01-08: Using PostgreSQL RLS for multi-tenant security
- 2026-01-06: JWT tokens with 15min expiry, 7day refresh

**Active Rules**:
- backend/api-standards.md (modified: auth endpoints)
- backend/database-patterns.md (modified: users table)
```

#### 2.3 PreToolUse Hook (Verbose Delegation)
**Matcher**: `Bash(npm test|pytest|docker-compose logs)`

**Process**:
```bash
if [[ $TOOL_NAME =~ (npm test|pytest|docker.*logs) ]]; then
  echo '{"decision": "delegate", "subagent": "test-runner"}'
else
  echo '{"decision": "allow"}'
fi
```

**Result**: Noisy commands run in isolated subagent, main context stays clean

#### 2.4 PostToolUse Hook (Pattern Learning)
**File**: `scripts/learn-from-corrections.sh`

**Triggers**: After Edit tool use

**Process**:
1. Track edit type (e.g., "added rate limiting to endpoint")
2. Check history: seen 3+ times?
3. If yes → Generate `.claude/rules/` file
4. Add to CLAUDE.md "Common Patterns"

**Example**:
```
Session 5: Claude creates endpoint without rate limiting
         → User edits to add rate limiting

Session 9: Same correction
Session 14: Same correction again (3rd time)

Hook triggers:
  → Creates .claude/rules/backend/api-rate-limiting.md
  → Adds to CLAUDE.md: "API endpoints must include rate limiting"
```

---

## Layer 3: Specialized Subagent Fleet

### Subagent Architecture

```
┌─────────────────────────────────────────────────────┐
│  MAIN CONVERSATION                                  │
│  (Claude with full context)                         │
└──────────────────┬──────────────────────────────────┘
                   │
                   │ Delegates verbose task
                   ▼
        ┌──────────────────────┐
        │ SUBAGENT (Isolated)  │
        │ - Fresh context      │
        │ - Limited tools      │
        │ - Faster model?      │
        │ - No MCP access      │
        └──────────┬───────────┘
                   │
                   │ Returns summary only
                   ▼
┌─────────────────────────────────────────────────────┐
│  MAIN CONVERSATION                                  │
│  (Receives 5-line summary, not 500-line output)     │
└─────────────────────────────────────────────────────┘
```

### Subagent Definitions

#### 3.1 context-cleaner
**File**: `agents/context-cleaner.md`

```yaml
---
name: context-cleaner
description: Analyzes project memory for outdated/redundant information
tools: Read, Grep, Glob
model: haiku
permissionMode: plan
---

Analyze `.claude/CLAUDE.md` and `.claude/rules/`.

Identify:
1. Stale sections (>90 days, no references)
2. Duplicate/contradictory rules
3. Verbose sections to condense
4. One-off mentions (not patterns)

Output markdown report with recommendations.
```

**Usage**: `/context/optimize` or weekly cron

#### 3.2 test-runner
**File**: `agents/test-runner.md`

```yaml
---
name: test-runner
description: Executes tests and summarizes results without polluting main context
tools: Bash, Read
model: haiku
permissionMode: acceptEdits
---

Execute requested test command. Capture full output.

Report to main conversation:
- ✅/❌ Pass/fail summary
- Failed test names only
- First 5 lines of each error
- Suggested fixes

Full logs available on request.
```

**Isolation Benefit**: 500-line test output → 10-line summary

#### 3.3 doc-miner
**File**: `agents/doc-miner.md`

```yaml
---
name: doc-miner
description: Discovers undocumented patterns from codebase
tools: Read, Grep, Glob
model: sonnet
permissionMode: plan
---

Analyze codebase for patterns appearing 3+ times:
1. Function naming conventions
2. Error handling approaches
3. Import organization
4. Testing fixtures

Generate `.claude/rules/` files for discovered patterns.
Require 3+ consistent occurrences before suggesting.
```

**Output**: Auto-generated rules based on actual code

---

## Layer 4: Auto-Updating Slash Commands

### Command Architecture

**Location**: `.claude/commands/`

**Structure**:
```
commands/
├── context/
│   ├── status.md         # /context/status
│   ├── optimize.md       # /context/optimize
│   └── reset.md          # /context/reset
├── learn/
│   ├── from-session.md   # /learn/from-session
│   └── from-codebase.md  # /learn/from-codebase
└── resume/
    ├── last-task.md      # /resume/last-task
    └── branch.md         # /resume/branch
```

### Example: `/context/status.md`

```markdown
---
description: Show current context usage and health metrics
allowed-tools: Read, Bash
---

!bash
#!/bin/bash
echo "## Context Health Report"
echo ""
echo "**Memory Files:**"
echo "- Project: $(wc -c < .claude/CLAUDE.md) bytes"
echo "- Rules: $(find .claude/rules -name '*.md' | wc -l) files"
echo "- Archives: $(find .claude/archives -name '*.md' | wc -l) months"
echo ""
echo "**Session Stats:**"
grep "session_count" .claude/CLAUDE.md || echo "- Sessions: N/A"
echo ""
echo "**Last Maintenance:**"
grep "next_cleanup" .claude/CLAUDE.md || echo "- Never"
echo ""
echo "**Recent Focus:**"
sed -n '/## Current Focus/,/## /p' .claude/CLAUDE.md | head -n 10

Analyze this report and suggest optimizations if context > 50KB or rules > 20 files.
```

---

## Layer 5: MCP Servers

### 5.1 project-kb (Knowledge Base)

**Purpose**: Queryable SQLite database of all session summaries

**Schema**:
```sql
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  timestamp DATETIME,
  summary TEXT,
  decisions TEXT[],
  patterns TEXT[],
  embedding BLOB  -- For semantic search
);

CREATE TABLE decisions (
  id INTEGER PRIMARY KEY,
  date DATE,
  category TEXT,
  decision TEXT,
  rationale TEXT,
  session_id TEXT REFERENCES sessions(id)
);

CREATE TABLE patterns (
  id INTEGER PRIMARY KEY,
  pattern_name TEXT,
  first_seen DATE,
  occurrence_count INTEGER,
  rule_generated BOOLEAN
);
```

**MCP Tools**:
- `search_knowledge(query)` - Semantic search
- `get_decision_history(topic)` - Track evolution
- `list_recent_patterns()` - Recent learnings

**Installation**:
```bash
claude mcp add --transport stdio project-kb -- \
  python3 ~/.claude/plugins/cps/mcp-servers/project-kb/server.py
```

### 5.2 codebase-rag (Semantic Code Search)

**Purpose**: Find similar implementations across your codebase

**Features**:
- Embeddings via local Ollama (nomic-embed-text)
- Chunks code into functions/classes
- Semantic search for "code like X"
- Privacy-preserving (all local)

**MCP Tools**:
- `search_similar_code(description)` - Find implementations
- `find_pattern_usage(pattern)` - Pattern instances
- `suggest_reusable_code(task)` - Extract utilities

---

## Layer 6: Automated Maintenance Skills

### 6.1 context-maintenance Skill

**Trigger**: Weekly or when memory > 50KB

**Process**:
```
1. Audit Phase
   - Scan CLAUDE.md and rules/
   - Identify stale sections (>90 days)
   - Find duplicates/contradictions

2. Optimization Phase
   - Archive old decisions to archives/YYYY-MM.md
   - Consolidate duplicate rules
   - Condense verbose sections
   - Update timestamps

3. Validation Phase
   - Ensure no data loss
   - Verify links valid
   - Check YAML integrity

4. Report
   - Before/after size comparison
   - Archived items list
   - Recommendations
```

---

## Layer 7: Intelligence Amplification

### Pattern Learning System

**Flow**:
```
User corrects Claude (Edit tool)
         ↓
PostToolUse hook tracks correction type
         ↓
Check history: Seen 3+ times?
         ↓ Yes
Generate .claude/rules/ file
         ↓
Add to CLAUDE.md "Common Patterns"
         ↓
Future sessions: Claude knows automatically
```

**Example Tracking**:
```json
{
  "corrections": {
    "missing_rate_limiting": {
      "count": 3,
      "first_seen": "2026-01-05",
      "last_seen": "2026-01-14",
      "rule_generated": true,
      "rule_file": ".claude/rules/backend/api-rate-limiting.md"
    }
  }
}
```

---

## Layer 8: Distribution

See [DISTRIBUTION.md](DISTRIBUTION.md) for full details.

**Key Components**:
- `plugin.json` - Manifest
- `install.sh` - One-command installer
- `templates/` - Project templates
- `uninstall.sh` - Clean removal

---

## Data Flow

### Complete Session Lifecycle

```
1. SESSION START
   ↓
   SessionStart Hook runs
   ↓
   Loads: branch context + recent rules + decisions
   ↓
   Claude has relevant memory pre-loaded
   ↓

2. MAIN CONVERSATION
   ↓
   User: "Build login endpoint"
   ↓
   Claude: (knows from rules: needs rate limiting, JWT, validation)
   ↓
   PreToolUse Hook: (no verbose output, allow)
   ↓
   Claude creates endpoint
   ↓
   PostToolUse Hook: (tracks pattern usage)
   ↓

3. SESSION END
   ↓
   SessionEnd Hook runs
   ↓
   Analyzes transcript with Ollama
   ↓
   Extracts: "Created login endpoint with JWT auth"
   ↓
   Updates CLAUDE.md → Current Focus
   ↓
   Stores in project-kb MCP server
   ↓
   Next session: Knowledge persists ✅
```

---

## Security & Privacy

### Privacy Principles

1. **Local-First**: All processing on your machine
2. **No Cloud Required**: Ollama runs locally
3. **Opt-In External**: Claude API only if explicitly enabled
4. **Data Sovereignty**: You own all knowledge base data

### Security Measures

1. **Hook Sandboxing**: Scripts run with limited permissions
2. **Subagent Isolation**: No access to user MCP servers
3. **Input Validation**: All hook inputs sanitized
4. **Secrets Protection**: Never capture API keys or credentials

---

## Performance Considerations

### Context Size Optimization

**Problem**: Large CLAUDE.md slows sessions

**Solutions**:
1. **Rule Modularization**: Path-specific loading (only 2-5 rules per session)
2. **Archive Rotation**: Move old decisions to archives/
3. **Lazy Loading**: MCP server queries on-demand
4. **Compression**: Condense verbose sections

**Target**: < 50KB total context per session

### Hook Performance

**SessionEnd Hook** (runs after session):
- Timeout: 30s
- Non-blocking: Runs in background
- Failure: Logs error, doesn't block next session

**SessionStart Hook** (runs before session):
- Timeout: 10s
- Critical: Must complete for context injection
- Cached: Reuses git/file info

---

## Scalability

### Multi-Project Usage

**User-Level Install**:
```
~/.claude/
├── agents/              # Shared across all projects
├── commands/            # Available everywhere
├── skills/              # Global skills
└── scripts/             # Shared hooks
```

**Project-Level Overrides**:
```
project1/.claude/
├── CLAUDE.md            # Project-specific memory
├── rules/               # Project rules
└── settings.json        # Override global hooks
```

### Team Collaboration

**Version Controlled** (shared):
- `.claude/CLAUDE.md` - Team knowledge
- `.claude/rules/` - Coding standards
- `.claude/agents/` - Custom subagents

**Local Only** (gitignored):
- `CLAUDE.local.md` - Personal preferences
- `.claude/context/` - Knowledge base cache

---

## Future Enhancements

### v1.1 (March 2026)
- Web dashboard for knowledge base
- Visual context health monitoring
- Team sync features

### v2.0 (Q2 2026)
- Cloud backup/sync (optional)
- Advanced pattern recognition (ML-based)
- Cross-project knowledge sharing
- IDE integration (VS Code extension)

---

**Next**: See [INSTALLATION.md](INSTALLATION.md) for setup instructions.
