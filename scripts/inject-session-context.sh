#!/bin/bash
# SessionStart Hook: Inject relevant context at session start
#
# Purpose: Load and inject project context based on current state
# Trigger: Before user starts developing
# Input: JSON via stdin containing cwd, session metadata
#
# Process:
# 1. Parse input JSON
# 2. Find .claude/CLAUDE.md files (project + user)
# 3. Check git branch for context
# 4. Find recently modified files
# 5. Match rules to activated files
# 6. Output context injection
#
# Output: Markdown text sent to stdout (auto-injected into context)

set -e

# Helper functions
log_debug() {
    if [ "$DEBUG" = "1" ]; then
        echo "[DEBUG] $1" >&2
    fi
}

# Read input from stdin
read -r INPUT

# Parse JSON input
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

log_debug "SessionStart hook triggered for: $CWD"

# Default empty context if no CWD
if [ -z "$CWD" ]; then
    exit 0
fi

cd "$CWD" || exit 0

# Check if project has CLAUDE.md
if [ ! -f ".claude/CLAUDE.md" ]; then
    log_debug "No .claude/CLAUDE.md found, skipping context injection"
    exit 0
fi

# Start building context
CONTEXT=""

# Section 1: Project Memory
CONTEXT+=$'## Session Context (Auto-Injected)\n\n'

# Add project CLAUDE.md sections
log_debug "Loading project CLAUDE.md"
CONTEXT+=$'### Project Memory\n\n'

# Extract Current Focus section
if grep -q "^## Current Focus" .claude/CLAUDE.md; then
    CONTEXT+=$'**Current Focus:**\n'
    # Get lines after "## Current Focus" until next heading
    sed -n '/^## Current Focus/,/^## /p' .claude/CLAUDE.md | head -n -1 | tail -n +2 >> <<< "$CONTEXT" 2>/dev/null || true
    CONTEXT+=$'\n'
fi

# Extract recent Critical Decisions
if grep -q "^## Critical Decisions" .claude/CLAUDE.md; then
    CONTEXT+=$'**Recent Decisions:**\n'
    # Get most recent decisions (last 3 under each category)
    grep "^-" .claude/CLAUDE.md | head -n 3 >> <<< "$CONTEXT" 2>/dev/null || true
    CONTEXT+=$'\n'
fi

# Section 2: Git branch context
log_debug "Checking git branch"
if command -v git &> /dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    CONTEXT+=$'### Git Context\n'
    CONTEXT+="**Branch:** \`$CURRENT_BRANCH\`\n\n"

    # Check for branch-specific context file
    BRANCH_CONTEXT_FILE=".claude/context/branch-${CURRENT_BRANCH}.md"
    if [ -f "$BRANCH_CONTEXT_FILE" ]; then
        CONTEXT+=$'**Branch Context:**\n'
        CONTEXT+=$(cat "$BRANCH_CONTEXT_FILE")
        CONTEXT+=$'\n\n'
    fi

    # Get recently modified files (last 5 commits)
    log_debug "Checking recently modified files"
    RECENT_FILES=$(git diff --name-only HEAD~5...HEAD 2>/dev/null | sort -u || echo "")

    if [ -n "$RECENT_FILES" ]; then
        CONTEXT+=$'**Recently Modified Files:**\n'
        echo "$RECENT_FILES" | head -n 10 | while read -r file; do
            CONTEXT+="- \`$file\`\n"
        done
        CONTEXT+=$'\n'
    fi
fi

# Section 3: Active rules
log_debug "Loading active rules"
if [ -d ".claude/rules" ]; then
    CONTEXT+=$'### Active Rules\n\n'

    # Find and list active rule files (simplified)
    # Real implementation would match glob patterns against current files
    RULE_COUNT=0
    while IFS= read -r -d '' rule_file; do
        if [ "$RULE_COUNT" -lt 5 ]; then
            RULE_NAME=$(basename "$rule_file" .md)
            CONTEXT+="- \`$RULE_NAME\`\n"
            RULE_COUNT=$((RULE_COUNT + 1))
        fi
    done < <(find .claude/rules -name "*.md" -type f -print0 | head -z -20)

    if [ "$RULE_COUNT" -gt 0 ]; then
        CONTEXT+=$'\n'
    fi
fi

# Section 4: Metadata summary
log_debug "Adding metadata"
if [ -f ".claude/CLAUDE.md" ]; then
    SESSION_COUNT=$(grep "^session_count:" .claude/CLAUDE.md | grep -oE '[0-9]+' | head -1 || echo "0")
    LAST_UPDATED=$(grep "^last_updated:" .claude/CLAUDE.md | cut -d' ' -f2 || echo "unknown")

    CONTEXT+=$'### Memory Status\n'
    CONTEXT+="- **Sessions:** $SESSION_COUNT\n"
    CONTEXT+="- **Last Updated:** $LAST_UPDATED\n"
    CONTEXT+="- **Next Maintenance:** $(grep 'next_cleanup:' .claude/CLAUDE.md | cut -d' ' -f2 || echo 'N/A')\n"
    CONTEXT+=$'\n'
fi

# Add helpful note
CONTEXT+=$'---\n'
CONTEXT+=$'**Context Status:** Automatically injected from project memory\n'
CONTEXT+=$'**Commands:** Use `/context/status` to check memory health, `/context/optimize` to run cleanup\n\n'

# Output context (to stdout for Claude Code to inject)
echo -e "$CONTEXT"

log_debug "SessionStart hook completed, context injected"
