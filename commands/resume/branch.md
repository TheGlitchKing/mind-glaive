---
description: Load branch-specific context and recent commits
allowed-tools: Bash, Read
---

# Resume Branch

Load context specific to current git branch.

This command:
1. Identifies current branch
2. Loads branch-specific context file (if exists)
3. Shows recent commits on this branch
4. Lists active developers/changes
5. Displays branch-specific rules
6. Suggests relevant work

**Branch Context File**:
- Location: `.claude/context/branch-{branch-name}.md`
- Format: Markdown describing branch focus
- Auto-loaded by SessionStart hook

**Example**:
```markdown
# Branch: feature/user-auth

## Focus
- Implementing JWT authentication
- Adding password reset flow
- Setting up session management

## Related Rules
- See .claude/rules/backend/api-standards.md
- See .claude/rules/backend/database-patterns.md

## Blockers
- Password reset email integration pending

## Reviewers
- @alice (auth expert)
- @bob (security review)
```

!bash
#!/bin/bash

if ! command -v git &> /dev/null; then
    echo "Git not found"
    exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
CONTEXT_FILE=".claude/context/branch-$BRANCH.md"

echo "## Branch Context: $BRANCH"
echo ""

# Show branch context file if exists
if [ -f "$CONTEXT_FILE" ]; then
    echo "### Branch Focus"
    echo ""
    cat "$CONTEXT_FILE"
    echo ""
else
    echo "No branch-specific context found"
    echo "Create: $CONTEXT_FILE"
    echo ""
fi

# Show recent commits
echo "### Recent Commits"
echo ""
git log --oneline -5 | sed 's/^/  - /'

# Show changed files
echo ""
echo "### Files Changed (This Branch)"
echo ""
git diff --name-only main..HEAD 2>/dev/null | head -n 10 | sed 's/^/  - /' || echo "  (No main branch)"

Provide summary of branch context and suggest how to proceed with the current branch's work.
