---
description: Extract and document patterns and learnings from current session
allowed-tools: Read, Write
---

# Learn from Session

Analyze current session and extract learnings.

This command:
1. Analyzes our conversation so far
2. Extracts key decisions, patterns, and learnings
3. Suggests updates to CLAUDE.md "Common Patterns"
4. Proposes new rules if patterns are repeated

**Output**:
- Summary of session work
- New patterns identified
- Suggestions for CLAUDE.md updates
- Recommended new rules

Based on our conversation, extract:

- **Decisions Made**: Architectural choices, tool selections, design decisions
- **Problems Solved**: Issues encountered and how they were resolved
- **Patterns Emerged**: Common approaches taken multiple times
- **Learnings**: New knowledge, workarounds, best practices discovered
- **Blockers**: Issues still unresolved that should be noted

Format as:

```markdown
## Session Learnings (2026-01-09)

### Decisions
- Decision 1 (rationale)
- Decision 2 (rationale)

### Patterns
- Pattern A (appears X times)
- Pattern B (appears Y times)

### Recommended CLAUDE.md Updates
- Add to "Common Patterns"
- Update "Known Issues"
- Clarify "Critical Decisions"

### New Rules to Consider
- Rule for Pattern A (when 3+ occurrences)
- Rule for Pattern B (tracking)
```

Provide this analysis so updates can be manually reviewed before committing to CLAUDE.md.
