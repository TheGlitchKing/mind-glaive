---
description: Discover patterns from codebase and suggest new rules
allowed-tools: Read, Grep, Glob
---

# Learn from Codebase

Mine the codebase for patterns and suggest new rules.

This delegates to the **doc-miner subagent** which:
- Scans codebase for recurring patterns
- Identifies patterns appearing 3+ times
- Validates consistency
- Generates rule files
- Suggests CLAUDE.md updates

**Process**:
1. Find function/method naming patterns
2. Identify error handling approaches
3. Discover code organization patterns
4. Extract testing conventions
5. Find architectural patterns
6. Suggest new rules with examples

**Output**:
```markdown
# Code Pattern Discovery

## High-Priority Patterns

### 1. Error Handling (12 occurrences)
- Pattern: try/except with logging
- Action: CREATE `.claude/rules/error-handling.md`

### 2. Repository Pattern (8 occurrences)
- Pattern: Repository classes for data access
- Action: CREATE `.claude/rules/data-access.md`

## Suggested Rules
- .claude/rules/error-handling.md
- .claude/rules/data-access.md
- .claude/rules/dependency-injection.md

## Updates for CLAUDE.md
Add to "Common Patterns" section
```

Invoke doc-miner to scan your codebase and generate this discovery report with specific, actionable suggestions.
