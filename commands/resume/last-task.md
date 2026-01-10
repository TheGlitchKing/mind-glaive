---
description: Resume previous session by showing current focus and recent context
allowed-tools: Read, Bash
---

# Resume Last Task

Show what you were working on and relevant context.

This command:
1. Checks git branch for context
2. Shows recent commits/changes
3. Displays "Current Focus" from CLAUDE.md
4. Shows recent critical decisions
5. Lists active branches and files
6. Suggests next steps

!bash
#!/bin/bash

echo "## 📋 Resume: Previous Session Context"
echo ""

if [ ! -f ".claude/CLAUDE.md" ]; then
    echo "No project context found"
    exit 0
fi

# Git context
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo "### Git Context"
    echo "**Current Branch**: \`$BRANCH\`"
    echo ""

    # Recent changes
    echo "**Recent Changes**:"
    git diff --name-only HEAD~3...HEAD 2>/dev/null | head -n 5 | sed 's/^/  - /'
    echo ""
fi

# Current focus
echo "### Current Focus"
echo ""
if grep -q "^## Current Focus" .claude/CLAUDE.md; then
    sed -n '/^## Current Focus/,/^## /p' .claude/CLAUDE.md | head -n 10 | tail -n +2
else
    echo "No current focus defined"
fi

# Recent decisions
echo ""
echo "### Recent Decisions"
echo ""
if grep -q "^## Critical Decisions" .claude/CLAUDE.md; then
    grep "^-" .claude/CLAUDE.md | head -n 3 || echo "No recent decisions"
fi

# Recommended next steps
echo ""
echo "### Next Steps"
echo ""
echo "Continue from where you left off based on the context above."
echo "Update \`/memory\` to record your progress, or run \`/learn/from-session\` to extract patterns."

Provide a summary of what was in progress and suggest next steps based on the current focus items.
