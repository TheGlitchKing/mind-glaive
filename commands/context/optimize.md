---
description: Run context cleaner to identify and suggest cleanup for stale, duplicate, or oversized content
allowed-tools: Read
---

# Context Optimize

Analyze project context and get cleanup recommendations.

This delegates to the **context-cleaner subagent** which:
- Identifies stale sections (> 90 days old)
- Finds duplicate or contradictory rules
- Reports oversized files
- Validates YAML frontmatter
- Suggests specific actions

Invoke the context-cleaner subagent to analyze `.claude/` and provide recommendations for:
1. Archiving old decisions to `archives/`
2. Consolidating duplicate rules
3. Removing one-off items
4. Optimizing memory usage

The subagent will generate a detailed report with prioritized recommendations and specific actions for each issue found.
