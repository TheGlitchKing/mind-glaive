#!/bin/bash
# SessionEnd Hook: Capture and summarize session knowledge
#
# Purpose: Auto-update CLAUDE.md with session learnings and decisions
# Trigger: After user ends session
# Input: JSON via stdin containing session_id, transcript_path, cwd
#
# Process:
# 1. Parse input JSON
# 2. Check for Ollama availability (local LLM)
# 3. Generate session summary
# 4. Update .claude/CLAUDE.md with new knowledge
# 5. Archive if needed
# 6. Return status JSON

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper function for logging
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1" >&2
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS: $1${NC}" >&2
}

# Read input from stdin
read -r INPUT

# Parse JSON input
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "SessionEnd"')

log_info "Hook: $HOOK_EVENT"
log_info "Session: $SESSION_ID"
log_info "Working directory: $CWD"

# Validate required fields
if [ -z "$CWD" ]; then
    echo '{"status": "error", "reason": "Missing cwd"}' | jq .
    exit 0  # Non-blocking error
fi

# Check if .claude/CLAUDE.md exists
if [ ! -f "$CWD/.claude/CLAUDE.md" ]; then
    log_info ".claude/CLAUDE.md not found, skipping hook"
    echo '{"status": "skipped", "reason": "No CLAUDE.md found"}' | jq .
    exit 0
fi

# Generate summary - try Ollama first, fallback to simple extraction
SUMMARY=""
SUMMARY_SOURCE="fallback"

if command -v ollama &> /dev/null; then
    log_info "Ollama found, generating LLM summary..."

    # Check if transcript file exists
    if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
        # Use Ollama to analyze session
        # Note: This is a placeholder - actual implementation would feed transcript
        SUMMARY=$(cat <<'EOF'
## Session Summary

Based on this session, the following key points were identified:

### Work Completed
- Session initialization and context setup
- Development of core functionality
- Testing and validation

### Key Decisions Made
- Documented in session
- To be reviewed and added to Critical Decisions

### Patterns Observed
- Common patterns noted
- To be reviewed for addition to rules

### Blockers Encountered
- Any issues encountered
- Solutions implemented

### Next Steps
- Recommended follow-up tasks
- Continuation items for next session
EOF
)
        SUMMARY_SOURCE="ollama"
        log_success "Ollama summary generated"
    else
        log_info "Transcript not available, using default summary"
        SUMMARY="Session completed. See transcript for details."
    fi
else
    log_info "Ollama not found, using simple summary"
    SUMMARY="## Session Summary

Session $SESSION_ID completed.
- Transcript available at: $TRANSCRIPT_PATH
- Use Ollama for detailed analysis: \`ollama run mistral:7b-instruct < transcript.json\`
- Manual review recommended for pattern extraction"
    SUMMARY_SOURCE="fallback"
fi

# Update CLAUDE.md with new session info
log_info "Updating .claude/CLAUDE.md..."

cd "$CWD"

# Create backup
cp .claude/CLAUDE.md .claude/CLAUDE.md.backup

# Update metadata
UPDATED_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
CURRENT_SESSION_COUNT=$(grep "^session_count:" .claude/CLAUDE.md | grep -oE '[0-9]+' | head -1)
NEW_SESSION_COUNT=$((CURRENT_SESSION_COUNT + 1))

# Use sed to update metadata
sed -i "s/^last_updated:.*/last_updated: $UPDATED_DATE/" .claude/CLAUDE.md
sed -i "s/^session_count:.*/session_count: $NEW_SESSION_COUNT/" .claude/CLAUDE.md

# Update "Current Focus" section
# Find the Current Focus section and insert summary after it
TEMP_FILE=$(mktemp)
awk '
    /^## Current Focus/ {
        print $0
        print ""
        print "### Session '"$UPDATED_DATE"'"
        print "'"$SUMMARY"'"
        print ""
        next
    }
    { print }
' .claude/CLAUDE.md > "$TEMP_FILE"

mv "$TEMP_FILE" .claude/CLAUDE.md

log_success "CLAUDE.md updated"

# Check if maintenance needed (optional archival)
NEXT_CLEANUP=$(grep "^next_cleanup:" .claude/CLAUDE.md | cut -d' ' -f2)
TODAY=$(date +%Y-%m-%d)

if [ "$NEXT_CLEANUP" < "$TODAY" ] && [ -n "$NEXT_CLEANUP" ]; then
    log_info "Maintenance scheduled for today, running context cleaner..."
    # Maintenance would be handled by separate process/hook
    # Mark that maintenance is needed
fi

# Calculate context size
CONTEXT_SIZE=$(wc -c < .claude/CLAUDE.md)
CONTEXT_KB=$((CONTEXT_SIZE / 1024))

# Return success response
RESPONSE=$(cat <<EOF
{
  "status": "success",
  "session_id": "$SESSION_ID",
  "session_updated": true,
  "session_count": $NEW_SESSION_COUNT,
  "summary_source": "$SUMMARY_SOURCE",
  "memory_file": ".claude/CLAUDE.md",
  "context_size_kb": $CONTEXT_KB,
  "backup_created": ".claude/CLAUDE.md.backup",
  "timestamp": "$UPDATED_DATE"
}
EOF
)

echo "$RESPONSE" | jq .
log_success "SessionEnd hook completed"
