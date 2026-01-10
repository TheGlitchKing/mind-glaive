---
description: Display current context health metrics and memory usage statistics
allowed-tools: Read, Bash
---

# Context Status

Check the health of your project's context preservation system.

This command displays:
- Project memory size and content summary
- Active rules and their patterns
- Archive information and dates
- Session count and tracking
- Recommendations for optimization

!bash
#!/bin/bash

echo "## 📊 Context Health Report"
echo ""
echo "**Generated**: $(date +'%Y-%m-%d %H:%M:%S')"
echo ""

# Check if .claude/CLAUDE.md exists
if [ ! -f ".claude/CLAUDE.md" ]; then
    echo "⚠️ No project context found (.claude/CLAUDE.md)"
    echo ""
    echo "Initialize with: \`/init\` or copy a template"
    exit 0
fi

echo "### Memory Files"
echo ""

# Project memory size
CLAUDE_SIZE=$(wc -c < .claude/CLAUDE.md 2>/dev/null | numfmt --to=iec 2>/dev/null || wc -c < .claude/CLAUDE.md)
echo "- **Project Memory** (.claude/CLAUDE.md): $CLAUDE_SIZE"

# Rules count
RULES_COUNT=$(find .claude/rules -name "*.md" -type f 2>/dev/null | wc -l)
RULES_SIZE=$(find .claude/rules -name "*.md" -type f -exec wc -c {} + 2>/dev/null | tail -1 | awk '{print $1}' | numfmt --to=iec 2>/dev/null || echo "N/A")
echo "- **Rules**: $RULES_COUNT files ($RULES_SIZE total)"

# Archives count
ARCHIVE_COUNT=$(find .claude/archives -name "*.md" -type f 2>/dev/null | wc -l)
echo "- **Archives**: $ARCHIVE_COUNT files"

echo ""
echo "### Session Stats"
echo ""

# Extract metadata
SESSION_COUNT=$(grep "^session_count:" .claude/CLAUDE.md | grep -oE '[0-9]+' | head -1 || echo "0")
LAST_UPDATED=$(grep "^last_updated:" .claude/CLAUDE.md | cut -d' ' -f2 || echo "unknown")
NEXT_CLEANUP=$(grep "^next_cleanup:" .claude/CLAUDE.md | cut -d' ' -f2 || echo "never")

echo "- **Sessions**: $SESSION_COUNT"
echo "- **Last Updated**: $LAST_UPDATED"
echo "- **Next Maintenance**: $NEXT_CLEANUP"

echo ""
echo "### Current Focus (Last 3 items)"
echo ""

if grep -q "^## Current Focus" .claude/CLAUDE.md; then
    sed -n '/^## Current Focus/,/^## /p' .claude/CLAUDE.md | grep "^-" | head -n 3 | sed 's/^/  /'
else
    echo "  No focus items recorded"
fi

echo ""
echo "### Active Rules"
echo ""

if [ "$RULES_COUNT" -gt 0 ]; then
    find .claude/rules -name "*.md" -type f | head -n 5 | while read -r rule; do
        RULE_NAME=$(basename "$rule" .md)
        echo "- \`$RULE_NAME\`"
    done

    if [ "$RULES_COUNT" -gt 5 ]; then
        echo "- ... and $((RULES_COUNT - 5)) more"
    fi
else
    echo "No rules defined yet"
fi

echo ""
echo "### Recommendations"
echo ""

# Check memory size
CLAUDE_BYTES=$(wc -c < .claude/CLAUDE.md)
if [ "$CLAUDE_BYTES" -gt 51200 ]; then  # 50KB
    echo "⚠️ **Context > 50KB**: Run \`/context/optimize\` to clean up"
elif [ "$CLAUDE_BYTES" -gt 40960 ]; then
    echo "ℹ️ **Context near limit**: Consider archiving old items"
fi

# Check rule count
if [ "$RULES_COUNT" -gt 20 ]; then
    echo "⚠️ **Many rules** ($RULES_COUNT): Consider consolidating"
fi

# Check for stale content
if grep -q "^## Current Focus" .claude/CLAUDE.md; then
    FOCUS_LINES=$(sed -n '/^## Current Focus/,/^## /p' .claude/CLAUDE.md | wc -l)
    if [ "$FOCUS_LINES" -lt 3 ]; then
        echo "ℹ️ **No current focus**: Update with today's work"
    fi
fi

# Check archive
TODAY=$(date +%Y-%m-%d)
if [ "$NEXT_CLEANUP" != "never" ] && [ "$NEXT_CLEANUP" \< "$TODAY" ]; then
    echo "⏰ **Maintenance due**: Run \`/context/optimize\` now"
fi

if [ "$SESSION_COUNT" -gt 0 ]; then
    echo "✅ **Context active**: $(grep -c "^## Session" .claude/CLAUDE.md || echo "$SESSION_COUNT") sessions recorded"
fi

echo ""
echo "### Commands"
echo ""
echo "- \`/context/optimize\` - Run cleanup and archival"
echo "- \`/memory\` - Edit context files"
echo "- \`/context/reset\` - Clear all context"
echo ""
echo "See \`docs/LAYER_1_MEMORY.md\` for detailed documentation"

Provide analysis and suggestions based on this information.
