---
name: pattern-learning
description: Auto-learns from correction patterns - generates rules after 3+ occurrences of same correction
---

# Pattern Learning Skill

Automatically extract and codify patterns from corrections.

## What This Skill Does

1. **Monitors Corrections**
   - Tracks when user edits Claude-generated code
   - Categorizes correction type
   - Records frequency and context

2. **Pattern Detection**
   - Triggers when pattern appears 3+ times
   - Validates consistency across occurrences
   - Checks for false positives

3. **Rule Generation**
   - Creates `.claude/rules/{category}/{pattern}.md`
   - Includes code examples from actual corrections
   - Sets appropriate priority and tags
   - Adds to CLAUDE.md "Common Patterns"

4. **Continuous Learning**
   - Updates rule frequency count
   - Adjusts priority as pattern becomes more important
   - Retires rules that stop being issues

## Examples

**Correction Pattern**: Missing rate limiting in API endpoints

```
Session 5: Claude creates endpoint without @rate_limit
         → User adds: @rate_limit(100, 60)

Session 9: Same correction
Session 14: Same correction again (3rd time)

System generates:
- .claude/rules/backend/api-rate-limiting.md
- Adds to CLAUDE.md: "API endpoints must include rate limiting"
- Next session: Claude automatically includes rate limiting
```

## Output

```markdown
## New Patterns Learned

### Pattern 1: API Rate Limiting
- Occurrences: 3
- Generated rule: `.claude/rules/backend/api-rate-limiting.md`
- Status: Active (applied to future sessions)

### Pattern 2: React Component Memoization
- Occurrences: 2 (monitoring)
- Status: Pending (needs 1 more occurrence)
```

## Configuration

Tracking file: `.claude/.patterns.json`

```json
{
  "patterns": {
    "api_rate_limiting": {
      "count": 3,
      "first_seen": "2026-01-05",
      "last_seen": "2026-01-14",
      "rule_generated": true,
      "rule_file": ".claude/rules/backend/api-rate-limiting.md"
    },
    "react_memo": {
      "count": 2,
      "first_seen": "2026-01-12",
      "last_seen": "2026-01-14",
      "rule_generated": false
    }
  }
}
```

## Trigger

- **PostToolUse hook**: After Edit tool use
- **Manual**: `/learn/from-session`
- **Auto**: After each session when patterns emerge

## Performance

- Detection: < 5 seconds per correction
- Rule generation: < 10 seconds
- Total overhead: < 2% of session time

## Success Metrics

- ✅ Patterns detected by 3rd occurrence
- ✅ 80%+ accuracy in pattern categorization
- ✅ Generated rules useful (positive feedback)
- ✅ No false positive rules created
- ✅ Rules improve over time
