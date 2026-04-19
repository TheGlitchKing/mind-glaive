---
name: context-maintenance
description: Weekly cleanup and optimization of project memory - archives old decisions, consolidates rules, removes stale sections
---

# Context Maintenance Skill

Automated weekly maintenance of project context.

## What This Skill Does

Runs automatically (or on demand) to:

1. **Audit Phase**
   - Scan CLAUDE.md for stale sections (>90 days)
   - Find duplicate/contradictory rules
   - Identify oversized files
   - Check for one-off items

2. **Optimization Phase**
   - Archive old decisions to `archives/YYYY-MM.md`
   - Consolidate duplicate rules
   - Condense verbose sections
   - Update metadata timestamps

3. **Validation Phase**
   - Ensure no data loss
   - Verify archive integrity
   - Check YAML syntax
   - Validate rule globs

4. **Report**
   - Before/after size comparison
   - Items archived list
   - Consolidation suggestions
   - Cleanup summary

## Trigger

- Scheduled: Weekly (default Sunday 23:00 UTC)
- Manual: `/context/optimize`
- Automatic: When `next_cleanup` < today
- Threshold: When memory > 50KB

## Configuration

Add to `.claude/CLAUDE.md`:

```yaml
auto_maintenance: enabled
next_cleanup: 2026-01-16
```

## Output

```markdown
## Context Maintenance Report

✅ **Completed**: 2026-01-09 15:00 UTC

### Summary
- Before: 48 KB → After: 32 KB
- Items archived: 12
- Rules consolidated: 2
- Saved space: 16 KB (33%)

### Actions Taken
1. Archived "Current Focus" items >21 days
2. Moved decisions >90 days to archives/2026-01.md
3. Consolidated duplicate backend rules
4. Removed one-off pattern notes

### Next Maintenance
Scheduled: 2026-01-16 23:00 UTC
```

## Options

```bash
/context/optimize [--dry-run] [--archive-age 90] [--size-limit 50000]
```

- `--dry-run`: Show changes without applying
- `--archive-age`: Days before archiving (default 90)
- `--size-limit`: Bytes before triggering (default 50KB)

## Success Metrics

- ✅ No data lost
- ✅ CLAUDE.md < 50KB after run
- ✅ All archives valid
- ✅ YAML syntax correct
- ✅ Execution < 60 seconds
