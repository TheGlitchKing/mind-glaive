# mind-glaive Cleanup Guide

How to manage and clean up your context as it grows over time.

## Quick Answer: Yes, There Are Built-In Cleanup Functions!

mind-glaive includes automated cleanup and maintenance features to prevent context bloat.

---

## 1. Check Context Size First

Run this command to see how much space your context is using:

```
/context/status
```

This shows:
- **Project Memory size** (.claude/CLAUDE.md)
- **Rules count and total size**
- **Archive count**
- **Session statistics**
- **Maintenance recommendations**

**Target**: Keep `.claude/CLAUDE.md` under **50KB** for optimal performance.

---

## 2. Automatic Cleanup: `/context/optimize`

This is your main cleanup command. Run it when:
- Context grows over 50KB
- You notice duplicate rules
- Old decisions are cluttering memory
- You want maintenance recommendations

```
/context/optimize
```

**What it does:**
- ✅ Identifies stale sections (>90 days old)
- ✅ Finds duplicate or contradictory rules
- ✅ Reports oversized files
- ✅ Validates YAML frontmatter
- ✅ Suggests specific cleanup actions
- ✅ Recommends archiving old decisions

**Output:** Detailed report with prioritized recommendations.

---

## 3. Archive Old Decisions

As decisions age (>90 days), archive them to keep `.claude/CLAUDE.md` focused on current work.

**Automatic archiving** happens during `/context/optimize`, which suggests:
- Moving old decisions to `.claude/archives/YYYY-MM.md`
- Consolidating similar decisions
- Removing one-off items

**Manual archiving** (if preferred):
1. Open `.claude/CLAUDE.md`
2. Move old "Critical Decisions" to `.claude/archives/2026-01.md`
3. Keep only recent, active decisions in main file

---

## 4. Consolidate Rules

Over time, you may accumulate redundant rules. Cleanup identifies:
- Duplicate rules across files
- Contradictory guidelines
- Unused/stale patterns
- Rules that need consolidation

**Action**: Delete or merge duplicates, keep one authoritative version.

---

## 5. Full Reset: `/context/reset`

For a complete fresh start (removes everything and reinitializes):

```
/context/reset [template]
```

**Options:**
- `minimal` - Start with minimal template
- `full-stack` - Start with full-stack template
- `data-science` - Start with data-science template
- `keep-decisions` - Keep critical decisions, reset rest

**Safety**: Automatically backs up to `.claude/CLAUDE.md.backup`

⚠️ **Warning**: This is irreversible! Always backup first.

---

## 6. Automated Weekly Maintenance

mind-glaive includes a **context-maintenance skill** that runs automatically:
- Archives old decisions to `archives/YYYY-MM.md`
- Consolidates duplicate rules
- Removes stale sections
- Optimizes memory usage
- Validates file integrity

This runs weekly if enabled, keeping context healthy automatically.

---

## When to Clean Up

| Condition | Action |
|-----------|--------|
| Context > 50KB | Run `/context/optimize` |
| Decisions > 6 months old | Archive to `archives/` |
| Duplicate rules found | Consolidate/delete duplicates |
| Planning major refactor | Run `/context/reset` |
| Too much clutter | Full reset with template |

---

## Storage Breakdown

```
.claude/
├── CLAUDE.md          # Main context (~5-30KB - keep small!)
├── rules/             # Rules directory
│   ├── rule1.md      # Usually <2KB each
│   ├── rule2.md
│   └── ...
└── archives/          # Historical decisions
    ├── 2026-01.md    # Monthly archives (old decisions go here)
    └── 2026-02.md
```

**Target Sizes:**
- `CLAUDE.md`: < 50KB (ideal: 5-20KB)
- Each rule: < 2KB
- Archives: Unlimited (moved to cold storage)

---

## Space-Saving Tips

### 1. Archive Aggressively
Move decisions >90 days old to `archives/` immediately. They're searchable if needed.

### 2. Keep Rules Small
Each rule should be < 2KB with:
- Clear purpose
- 3-5 key points max
- Code examples (not full templates)

### 3. Remove Duplicate Rules
If you have 3 API standards rules, consolidate to 1 authoritative rule.

### 4. Use Examples Folder
Large example code goes to `examples/`, not in rules.

### 5. Run Maintenance Weekly
Enable automatic weekly cleanup or run `/context/optimize` every Friday.

---

## Troubleshooting

### Q: Context is still too large after cleanup?
**A**:
1. Run `/context/status` to see what's taking space
2. Check if CLAUDE.md has too much "Known Issues" - archive those
3. Consider if you need all rules - deactivate unused ones
4. Try `/context/reset` for fresh start

### Q: Lost decisions after cleanup?
**A**:
- Check `.claude/archives/` - they're backed up there
- Look for `.claude/CLAUDE.md.backup` from `/context/reset`
- Archives are searchable with `/learn/from-codebase`

### Q: How do I keep specific decisions from archiving?
**A**:
- Mark as "Critical Decision" (keeps in main file)
- Keep important ones in "Current Focus" section
- Don't archive - they'll stay in CLAUDE.md

---

## Commands Summary

| Command | Purpose | Time |
|---------|---------|------|
| `/context/status` | Show memory size & metrics | 5s |
| `/context/optimize` | Get cleanup recommendations | 30-60s |
| `/context/reset [template]` | Full fresh start | 10s |
| `/learn/from-session` | Extract learnings | 20s |
| `/learn/from-codebase` | Mine patterns | 30-60s |

---

## Maintenance Schedule

**Weekly:**
- Run `/context/status` to monitor size
- Check if `/context/optimize` recommends action

**Monthly:**
- Archive decisions >90 days old
- Review and consolidate rules
- Run automated maintenance

**Quarterly:**
- Full review of all rules
- Consider fresh start if too complex
- Evaluate what's actually being used

---

## Next Steps

1. **Check size**: `/context/status`
2. **If > 50KB**: Run `/context/optimize`
3. **Archive old**: Move decisions to `archives/`
4. **Consolidate**: Merge duplicate rules
5. **Reset if needed**: `/context/reset minimal`

Keep context lean, fast, and focused! 🚀
