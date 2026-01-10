# Project Memory Archives

This directory shows the recommended structure for archiving project context over time.

## Overview

Archives preserve historical knowledge while keeping active memory (CLAUDE.md) lean and focused.

**Benefits**:
- Main CLAUDE.md stays under 50KB
- Historical decisions remain discoverable via MCP search
- Pattern evolution tracked over time
- Team knowledge grows without polluting current context

## Archive Strategy

### Monthly Summaries

Store monthly summaries in files named `YYYY-MM.md`:

```
archives/
├── 2026-01.md     # January sessions
├── 2026-02.md     # February sessions
└── 2026-03.md     # March sessions
```

Each file contains session summaries from that month.

### Rotation Policy

**Active Memory (CLAUDE.md)**:
- Keep < 50KB total
- Remove items not referenced in 90 days
- Link to archives for historical context

**Archival Process** (triggered by SessionEnd hook or `/context/optimize`):
1. Review CLAUDE.md for stale sections (>90 days old)
2. Move dated decisions to `archives/YYYY-MM.md`
3. Condense verbose sections
4. Update timestamps in metadata

### Deep Dive Archives (Optional)

For significant decisions, create subdirectory archives:

```
archives/decisions/
├── 2026-01-auth.md        # Authentication system decision
├── 2026-01-database.md    # Database migration decision
└── 2026-02-api-design.md  # API redesign decision
```

## Format: Monthly Summary File

```markdown
# January 2026 Sessions

## Week 1 (Jan 1-7)
**Focus Areas**:
- Project initialization
- Architecture planning
- Environment setup

**Key Decisions**:
- Decided on PostgreSQL for data storage
- Chose FastAPI for backend framework
- Selected React + TypeScript for frontend

**Patterns Identified**:
- API endpoint rate limiting requirement (3+ occurrences)
- Component composition pattern emerging

**Blockers Resolved**:
- Database migration version conflicts → Rolled back and re-initialized

---

## Week 2 (Jan 8-14)
**Focus Areas**:
- User authentication implementation
- Database schema design
- Component library setup

**Key Decisions**:
- JWT tokens with 15-minute expiry, 7-day refresh
- Soft deletes for data integrity
- CSS modules for component styling

**Patterns Identified**:
- Error handling pattern (2+ occurrences, tracking)

**Learnings**:
- Alembic migrations require careful planning for production systems
- React memo improves performance for heavy re-renders

---

## Week 3 (Jan 15-21)
...
```

## MCP Integration

Archives are indexed by the `project-kb` MCP server for semantic search:

```
User Query: "How did we decide to handle authentication?"
           ↓
Search archives with embeddings
           ↓
Return: "2026-01: JWT tokens with 15-minute expiry decision"
```

The `/context/status` command shows:
- Archive count and total size
- Last archived session
- Recommended next cleanup date

## Cleanup Recommendations

**When to Archive**:
- Current Focus items older than 3 weeks
- Critical Decisions older than 90 days (keep references, move details)
- Known Issues resolved and no longer relevant
- Common Patterns that've been merged into rules

**When NOT to Archive**:
- Active decisions being implemented
- Current blockers
- Recently identified patterns (wait for 3+ occurrences)
- Team conventions (permanent reference)

## Accessing Archived Knowledge

**From CLAUDE.md**:
```markdown
## Archived Decisions
See `archives/2026-01.md` for historical decisions from January 2026
```

**From Slash Commands**:
```
/context/status        # Shows archive info and dates
/resume/branch         # Loads branch-specific context + archives
```

**From MCP**:
```
search_knowledge("authentication decisions")
search_knowledge("database design decisions")
```

## Example Archive

See `2026-01.md` in this directory for a complete example monthly archive showing:
- Multi-week session summaries
- Decision history
- Pattern evolution
- Blocker resolution
- Learning outcomes

---

**Archive Management**: Handled automatically by SessionEnd hook and `/context/optimize` command
**Manual Review**: Recommended monthly to ensure organization and completeness
