---
description: Clear all project context and reinitialize with default template
allowed-tools: Bash
argument-hint: [template-name]
---

# Context Reset

Clear all project context and start fresh.

**Options**:
- `minimal` - Start with minimal template (default)
- `full-stack` - Start with full-stack template
- `data-science` - Start with data-science template
- `keep-decisions` - Keep critical decisions, reset rest

**Warning**: This action is irreversible! Archives current context to `.claude/CLAUDE.md.backup`

!bash
#!/bin/bash

TEMPLATE="${1:-minimal}"

echo "🔄 Context Reset"
echo ""

if [ ! -d ".claude" ]; then
    echo "No .claude directory found"
    exit 1
fi

# Backup current context
echo "Backing up current context to .claude/CLAUDE.md.backup..."
cp .claude/CLAUDE.md .claude/CLAUDE.md.backup || true

# Clear context
echo "Clearing context..."
rm -rf .claude/CLAUDE.md .claude/rules/* 2>/dev/null || true

# Initialize from template
echo "Initializing new template: $TEMPLATE"

TEMPLATE_PATH="../../templates/$TEMPLATE/CLAUDE.md"
if [ -f "$TEMPLATE_PATH" ]; then
    cp "$TEMPLATE_PATH" .claude/CLAUDE.md
    echo "✓ Template copied"
else
    echo "⚠️  Template not found: $TEMPLATE"
    echo "Available: minimal, full-stack, data-science"
    exit 1
fi

# Copy rules if available
RULES_PATH="../../templates/$TEMPLATE/rules"
if [ -d "$RULES_PATH" ]; then
    cp -r "$RULES_PATH"/* .claude/rules/ 2>/dev/null || true
    echo "✓ Rules initialized"
fi

echo ""
echo "✅ Context reset complete!"
echo "📦 Backup saved to: .claude/CLAUDE.md.backup"
echo "📋 Next: /memory to customize your context"

Analyze and confirm the reset was successful. Show what was backed up and what's now initialized.
