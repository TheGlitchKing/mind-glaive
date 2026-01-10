# Layer 1: Intelligent Memory Hierarchy

**Version**: 1.0.0
**Last Updated**: 2026-01-09
**Status**: Complete - Ready for Integration with Layers 2-8

---

## Overview

Layer 1 provides the **foundation for all context preservation** through a hierarchical memory system that Claude Code natively supports. This layer captures, organizes, and provides selective access to project knowledge without requiring external dependencies.

### Core Problem Solved

> "Why do I have to explain the same architectural decisions multiple times across sessions?"

Layer 1 solves this through:
- **Persistent Project Memory** (CLAUDE.md) that carries decisions across sessions
- **Path-Specific Rules** that inject relevant context automatically
- **Archive System** that preserves history while keeping active memory lean

---

## Architecture

### The 4-Tier Memory Hierarchy

Claude Code enforces a natural hierarchy from broadest to most specific:

```
1. ENTERPRISE POLICY          (System-level, org-wide instructions)
   ↓ (loaded first, lowest priority for override)
2. PROJECT MEMORY             (.claude/CLAUDE.md + .CLAUDE.md)
   ↓
3. PROJECT RULES              (.claude/rules/*.md with path matching)
   ↓
4. USER MEMORY                (~/.claude/CLAUDE.md and .CLAUDE.local.md)
   ↑ (loaded last, highest priority for override)
```

**In Practice**:
- Enterprise policies set baseline security/compliance
- Project memory captures team decisions and context
- Rules provide domain-specific guidance (activated by file path)
- User memory allows personal preferences to override

---

## Component 1: Project Memory (CLAUDE.md)

### Purpose

**Single source of truth** for project context that persists across all sessions.

### Structure

Every CLAUDE.md requires:

#### 1. YAML Frontmatter (Metadata)

```yaml
---
last_updated: 2026-01-09T15:30:00Z
session_count: 12
auto_maintenance: enabled
next_cleanup: 2026-01-16
template: minimal|full-stack|data-science
version: 1.0.0
---
```

**Fields**:
- `last_updated`: ISO timestamp of last modification
- `session_count`: Auto-incremented by SessionEnd hook
- `auto_maintenance`: Enable/disable automatic cleanup
- `next_cleanup`: When maintenance should run (weekly by default)
- `template`: Which template this project uses
- `version`: Schema version for compatibility

#### 2. Current Focus

```markdown
## Current Focus

<!-- Auto-updated by SessionEnd hook -->

### Backend
- Working on user authentication endpoints
- Testing JWT refresh token flow

### Frontend
- Building user profile component
- Setting up Redux store for auth state
```

**Used By**:
- SessionEnd hook for recording what was accomplished
- SessionStart hook for context about ongoing work
- User to quickly recall project state

**Update Strategy**: SessionEnd hook appends completed work; items older than 3 weeks move to archives

#### 3. Critical Decisions

```markdown
## Critical Decisions

<!-- Permanent record of architectural choices -->

### Architecture (2026-01-05)
- Use PostgreSQL RLS for multi-tenant isolation (vs. app-level auth: provides stronger data boundaries)
- FastAPI for backend (vs. Django: better async support for our use case)

### Authentication (2026-01-08)
- JWT with 15-min expiry + 7-day refresh (vs. session-based: stateless, scales better)
- bcrypt with 12 rounds (vs. argon2: simpler, widely supported)

### Database (2026-01-06)
- Soft deletes using nullable `deleted_at` field (vs. hard deletes: preserves audit trail)
- Alembic migrations with manual review (vs. auto-generate: prevents subtle bugs)
```

**Format**: `YYYY-MM-DD: Decision (rationale explaining why)`

**Lifespan**:
- Active: Referenced frequently, in current focus
- Archived: >90 days old, moved to `archives/YYYY-MM.md`
- Permanent: Foundational decisions, never archived

#### 4. Common Patterns

```markdown
## Common Patterns

<!-- Learned from 3+ corrections, auto-populated by pattern-learning skill -->

### API Endpoints
All endpoints must include:
- Rate limiting decorator
- Pydantic input validation
- Standard error response format

Auto-generated rule: See `.claude/rules/backend/api-standards.md`

### Database Operations
All database models must have:
- UUID primary key
- `created_at` and `updated_at` timestamps
- `deleted_at` for soft deletes

Auto-generated rule: See `.claude/rules/backend/database-patterns.md`

### React Components
Components should:
- Use TypeScript interfaces for props
- Be organized in feature directories
- Include proper loading/error states

See `.claude/rules/frontend/component-structure.md`
```

**Origin**: PostToolUse hook detects when user corrects the same issue 3+ times → generates rule → documents pattern

**Never Manual**: These should be auto-generated to avoid duplicating rule content

#### 5. Known Issues & Workarounds

```markdown
## Known Issues & Workarounds

### Issue: Database Migrations Fail in Parallel
**Workaround**: Run migrations serially with `alembic upgrade head` one per environment

### Issue: React Re-renders on Every State Change
**Workaround**: Use `React.memo` and `useCallback` for expensive components

### Issue: JWT Tokens Stored in LocalStorage Vulnerable
**Workaround**: Use httpOnly cookies, accept CSRF risk tradeoff for better security
```

**Format**: Clear issue description → specific workaround with rationale

**Lifespan**: Resolved issues move to archives; active issues stay visible

#### 6. Team Conventions (Optional)

```markdown
## Team Conventions

<!-- Shared coding standards -->

### Code Style
- 4-space indentation (Python), 2-space (JavaScript)
- PascalCase for React components
- snake_case for Python functions

### File Organization
- Feature-based directory structure
- Tests colocated with source code
- Shared types in `@/types` directory

### Development Process
- Feature branches with PR reviews
- Rebase before merging (no merge commits)
- Squash commits for clean history
```

**Who Uses**:
- All developers on team
- Important for code consistency
- Referenced in code review

---

## Component 2: Project Rules (.claude/rules/)

### Purpose

**Path-specific context** that activates only when you're working with matching files.

### Why Path-Specific?

```
Problem: If all rules are in one CLAUDE.md, context size grows unbounded
Solution: Load only rules matching current files
Result: Each session has 2-5 relevant rules, not 50
```

### File Structure

```
.claude/rules/
├── _metadata.yaml                  # Registry of all rules (optional)
├── example-rule.md                 # Simple rule
├── backend/
│   ├── api-standards.md           # Activates for backend/app/api/**/*.py
│   ├── database-patterns.md        # Activates for backend/migrations/**/*.py
│   └── error-handling.md           # Activates for backend/**/*.py
├── frontend/
│   ├── component-structure.md      # Activates for frontend/src/components/**
│   └── state-management.md         # Activates for frontend/src/**/*.tsx
└── testing/
    ├── unit-tests.md               # Activates for tests/**/*.py
    └── integration-tests.md         # Activates for tests/integration/**
```

### YAML Frontmatter (Mandatory)

```yaml
---
paths: ["backend/app/api/**/*.py"]  # When this rule activates (glob patterns)
priority: 10                         # Load order (higher = first)
description: API endpoint standards and best practices
tags: [backend, api, fastapi, python]
---
```

**Field Explanations**:
- `paths`: Array of glob patterns (supports braces: `{src,lib}/**/*.ts`)
- `priority`: Integer 1-20 (higher loads first, 10 is standard)
- `description`: What this rule is about (appears in rule listings)
- `tags`: For categorization and discovery (optional)

### Rule Content Guidelines

**Do**:
- ✅ Be specific: "Use 4-space indentation" not "Format code properly"
- ✅ Include practical examples (small, focused)
- ✅ Reference external docs for detailed info
- ✅ Keep under 2KB total (context efficiency critical)
- ✅ Use clear markdown with headers and bullets
- ✅ Add tags for discoverability

**Don't**:
- ❌ Duplicate content from other rules
- ❌ Include huge code examples
- ❌ Exceed 2KB limit
- ❌ Use vague language
- ❌ Repeat CLAUDE.md content (reference instead)

### Example Rule: API Standards

See `templates/full-stack/rules/backend/api-standards.md` for complete example showing:
- YAML frontmatter with path matching
- Specific design requirements
- Code examples
- HTTP status codes
- Documentation standards

**Size**: ~1.2 KB (well under 2KB limit)
**Activation**: Triggers when editing `backend/app/api/**/*.py`

### Best Practices

#### 1. Glob Pattern Matching

Valid patterns:
```yaml
paths: ["src/**/*.ts"]           # All TypeScript in src/
paths: ["src/**/*.{ts,tsx}"]     # TypeScript and TSX
paths: ["{src,lib}/**/*.ts"]     # Multiple directories
paths: ["backend/api/**/*.py"]   # Specific subdirectory
```

Invalid (not supported):
```yaml
paths: ["!tests/**/*.py"]        # Negation not supported directly
```

#### 2. Rule Organization

```
✅ Good organization:
.claude/rules/
├── backend/            # Feature-based grouping
│   ├── api-standards.md
│   └── database-patterns.md
└── frontend/
    └── component-structure.md

❌ Poor organization:
.claude/rules/
├── rule1.md
├── rule2.md
├── rule3.md           # No structure, hard to maintain
```

#### 3. Priority System

```yaml
# Highest priority (loaded first) - for critical rules
priority: 20
description: Critical security requirements

# Standard priority
priority: 10
description: Common patterns and standards

# Lower priority (loaded last) - for nice-to-have guidelines
priority: 5
description: Stylistic preferences
```

#### 4. Progressive Disclosure

Keep main rule < 2KB by linking to details:

```markdown
---
paths: ["frontend/**/*.tsx"]
priority: 8
---

# Component Structure Standards

## Quick Reference
- PascalCase file names matching component names
- Feature-based directory organization
- TypeScript interfaces for all props

## Detailed Guidelines
For comprehensive component patterns, see:
- `docs/component-style-guide.md` - Full stylistic details
- `frontend/COMPONENT_PATTERNS.md` - Architectural patterns
- Project CLAUDE.md → Common Patterns → React Components
```

---

## Component 3: Archive System

### Purpose

**Preserve historical knowledge** while keeping active memory lean and fast.

### Problem It Solves

```
Without Archives:
- CLAUDE.md grows to 200KB+ over time
- SessionStart injection becomes slow
- Historical info mixes with active context
- Hard to understand current state

With Archives:
- CLAUDE.md stays < 50KB
- Fast session startup
- Historical decisions preserved for reference
- Clear separation of active vs. historical
```

### Directory Structure

```
.claude/archives/
├── README.md                   # Archive guide
├── 2026-01.md                  # January sessions
├── 2026-02.md                  # February sessions
└── decisions/                  # Optional: Deep dives
    ├── 2026-01-auth.md        # Authentication design decision
    └── 2026-02-api-redesign.md # API redesign decision
```

### Monthly Summary Format

**File**: `archives/2026-01.md`
**Contains**: All session summaries from January 2026
**Format**:

```markdown
# January 2026 Sessions

## Week 1 (Jan 1-7)
**Focus Areas**: List of active work

**Key Decisions**:
- Decision 1 (rationale)
- Decision 2 (rationale)

**Patterns Identified**:
- Pattern 1 (occurrence count)
- Pattern 2 (occurrence count)

**Blockers Resolved**:
- Issue 1 → Solution
- Issue 2 → Solution

**Learnings**:
- Key learning 1
- Key learning 2

---
## Week 2 (Jan 8-14)
...
```

**See**: `examples/archives/2026-01.md` for complete real-world example

### Archival Process

#### When to Archive

**SessionEnd Hook Triggers Archive When**:
- Item in "Current Focus" > 21 days old
- Decision in "Critical Decisions" > 90 days old
- Issue in "Known Issues" marked as resolved
- Pattern confirmed 3+ times (moved to rule, documented in archive)

#### Manual Archive Review

Recommended monthly:

```bash
# SessionStart hook can inject archive summary:
# "Recent Archives: Jan 2026 - User auth, Database redesign"

# Users can search archives:
/context/status          # Shows archive dates
/resume/branch           # Loads branch context + archive reference
```

#### Archive Retention

- Keep all archives indefinitely (storage is cheap)
- MCP server indexes archives for semantic search
- Never delete - historical knowledge is valuable
- Reference in CLAUDE.md: "See archives/2026-01.md for historical context"

---

## Component 4: Metadata & Automation

### Metadata Fields

```yaml
---
last_updated: 2026-01-09T15:30:00Z   # When CLAUDE.md was last modified
session_count: 12                     # Auto-incremented by SessionEnd hook
auto_maintenance: enabled              # Enable/disable automatic cleanup
next_cleanup: 2026-01-16              # When next maintenance should run
template: full-stack                  # Which template this uses
version: 1.0.0                        # Schema version
---
```

### Auto-Maintenance Process

SessionEnd hook automatically:
1. Increment `session_count`
2. Update `last_updated` timestamp
3. Check if maintenance needed (schedule check)
4. If `next_cleanup` < today:
   - Archive items > 90 days old
   - Move patterns to `.claude/rules/` if 3+ occurrences
   - Condense verbose sections
   - Update `next_cleanup` to 7 days from now

### Manual Cleanup

```bash
/context/optimize           # Run context cleaner subagent
# Analyzes memory, identifies stale sections
# Suggests archival/consolidation
```

---

## Templates

The system includes 3 templates for quick project setup:

### 1. Minimal Template
**For**: Small projects, learning, simple scripts
**Contents**:
- `CLAUDE.md` (core structure, no domain-specific sections)
- `rules/example-rule.md` (demonstrating syntax)
**Size**: ~2KB

**Use**: `./install.sh --template minimal`

### 2. Full-Stack Template
**For**: Web applications with backend + frontend
**Contents**:
- `CLAUDE.md` (with Backend/Frontend/Database sections)
- `rules/backend/api-standards.md`
- `rules/backend/database-patterns.md`
- `rules/frontend/component-structure.md`
**Size**: ~8KB

**Use**: `./install.sh --template full-stack`

### 3. Data Science Template
**For**: ML/Data science projects
**Contents**:
- `CLAUDE.md` (with Experiments/Data/Analysis sections)
- `rules/notebooks.md` (Jupyter standards)
- `rules/ml-models.md` (Model development)
**Size**: ~6KB

**Use**: `./install.sh --template data-science`

---

## Integration with Layers 2-8

### SessionStart Hook (Layer 2)

```
SessionStart Hook runs →
1. Loads `.claude/CLAUDE.md`
2. Finds git branch
3. Loads branch-specific context (if exists)
4. Finds modified files from last 5 commits
5. Matches paths against `.claude/rules/`
6. Injects relevant rules into context
```

**Result**: Claude starts with active context already loaded

### SessionEnd Hook (Layer 2)

```
SessionEnd Hook runs (after session ends) →
1. Analyzes conversation transcript
2. Extracts decisions, patterns, learnings
3. Appends to "Current Focus" in CLAUDE.md
4. Increments session_count
5. Moves old items to archives
6. Updates timestamp metadata
```

**Result**: Next session automatically has new context

### Pattern Learning (Layer 7)

```
PostToolUse Hook detects pattern →
1. User corrects same issue 3+ times
2. Hook generates `.claude/rules/` file
3. Documents in CLAUDE.md "Common Patterns"
4. Rule activates for future similar files
```

**Result**: Learned patterns become automatic context

### Archive Search (Layer 5 - MCP)

```
User asks: "How did we decide on authentication?"
         ↓
MCP project-kb server →
1. Searches `.claude/archives/` with embeddings
2. Finds "2026-01: JWT decision"
3. Returns relevant archive section
```

**Result**: Historical knowledge discoverable

---

## Best Practices

### Do's ✅

1. **Be Specific**
   - ❌ "Use consistent naming"
   - ✅ "Use PascalCase for React components, snake_case for Python functions"

2. **Include Examples**
   - ❌ "Add error handling"
   - ✅ "Wrap database queries in try/except with logging"

3. **Reference External Docs**
   - ❌ "See the documentation" (vague)
   - ✅ "See `docs/DATABASE_MIGRATIONS.md` for detailed schema change process"

4. **Keep Rules Under 2KB**
   - Use quick reference in rule, link to detailed docs
   - Focus on "what" and "why", not "how to" tutorials

5. **Review Regularly**
   - Monthly: Check for stale rules
   - Quarterly: Consolidate related rules
   - Annually: Review template defaults

### Don'ts ❌

1. **Don't Duplicate Content**
   - ❌ Copy content from rule into CLAUDE.md
   - ✅ Reference: "See `rules/api-standards.md` for API guidelines"

2. **Don't Exceed Size Limits**
   - ❌ Rules over 2KB
   - ❌ CLAUDE.md over 50KB
   - ✅ Archive old content

3. **Don't Use Vague Language**
   - ❌ "Code properly"
   - ✅ "Use 4-space indentation, add docstrings, include type hints"

4. **Don't Archive Recent Items**
   - ❌ Archive current work
   - ✅ Archive items > 90 days old or when resolved

5. **Don't Automate Incorrectly**
   - ❌ Archive decisions still being implemented
   - ✅ Let SessionEnd hook handle archival with reasonable time limits

---

## Success Metrics

How to know Layer 1 is working:

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Context Size** | < 50KB per session | `/context/status` |
| **Rule Activation** | 3-5 per file type | Log hook execution |
| **Pattern Accuracy** | > 80% match current code | Manual review of suggested patterns |
| **Archive Coverage** | > 90 days of history | `find archives/ \| wc -l` |
| **Session Load Time** | < 10s (SessionStart) | Time startup |
| **Knowledge Retention** | > 90% recall across sessions | Ask Claude about past decisions |

---

## Troubleshooting

### Problem: Rules Not Activating

**Symptom**: Working on Python file but rules not appearing in context

**Debug**:
1. Check glob pattern: `paths: ["backend/**/*.py"]`
2. Verify file matches pattern: Does `backend/app/utils.py` match?
3. Check rule priority: Is priority high enough (8+)?
4. Test manually: `/context/status` shows active rules

**Fix**: Update glob pattern to match file location

---

### Problem: CLAUDE.md Too Large

**Symptom**: SessionStart hook slow, context size > 50KB

**Fix**:
1. Run `/context/optimize` to identify stale content
2. Archive items > 90 days old to `archives/YYYY-MM.md`
3. Consolidate duplicate entries
4. Verify rules extracted from "Common Patterns"

---

### Problem: Stale Information in Memory

**Symptom**: Claude references outdated architectural decision

**Fix**:
1. Update CLAUDE.md "Critical Decisions" with new decision
2. Archive old decision to `archives/YYYY-MM.md` with date context
3. Update relevant rules if decision changes implementation
4. Add new pattern to "Common Patterns" if repeated

---

## Quick Reference

### File Locations
- Project memory: `.claude/CLAUDE.md`
- User memory: `~/.claude/CLAUDE.md`
- Project local: `.claude/CLAUDE.local.md` (gitignored)
- Rules: `.claude/rules/` (gitignored or shared as needed)
- Archives: `.claude/archives/` (gitignored)

### Key Commands
```bash
/memory                    # Edit any memory file
/init                      # Bootstrap new CLAUDE.md
/context/status           # Check memory health
/context/optimize         # Run cleanup
```

### Frontmatter Quick Reference
```yaml
---
# CLAUDE.md
last_updated: 2026-01-09T00:00:00Z
session_count: 0
auto_maintenance: enabled
next_cleanup: 2026-01-16
template: minimal|full-stack|data-science
version: 1.0.0
---

# Rule files
paths: ["backend/**/*.py"]
priority: 10
description: What this rule is about
tags: [backend, api, python]
---
```

---

## Next Steps

Layer 1 is now complete and provides:
- ✅ Three ready-to-use templates (minimal, full-stack, data-science)
- ✅ Example rules with glob pattern matching
- ✅ Archive system structure and examples
- ✅ Metadata framework for automation

**Week 2 (Layer 2)** will integrate Layer 1 with:
- SessionStart hook for automatic context injection
- SessionEnd hook for automatic context capture
- Ollama integration for local LLM summaries

---

**Created**: 2026-01-09
**Status**: Complete and Ready for Integration
**Next Phase**: Layer 2 - Hooks System (Week 2)
