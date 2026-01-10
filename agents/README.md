# Subagents

Specialized Claude Code subagents that handle isolated tasks, keeping main conversation focused.

## Overview

Three subagents for Layer 3 (Isolation):

| Agent | Purpose | Model | Mode |
|-------|---------|-------|------|
| context-cleaner | Analyze memory for stale/duplicate content | Haiku | Plan |
| test-runner | Execute tests, isolate verbose output | Haiku | AcceptEdits |
| doc-miner | Discover patterns, suggest new rules | Sonnet | Plan |

## Storage

Place files in:
- **Project scope**: `.claude/agents/`
- **User scope**: `~/.claude/agents/`
- **Plugin scope**: Plugin directory (auto-discovered)

## Loading Order

1. Plugin-provided agents
2. User-scope agents (`~/.claude/agents/`)
3. Project-scope agents (`.claude/agents/`)
4. CLI-provided agents (`--agents` flag)

## Subagent Definitions

### context-cleaner

**When invoked**:
- Manually: `/context/optimize`
- Automatically: When memory > 50KB or `next_cleanup` < today

**What it does**:
1. Analyzes `.claude/CLAUDE.md` and `.claude/rules/`
2. Identifies stale sections (> 90 days)
3. Finds duplicate/contradictory rules
4. Reports oversized files
5. Validates YAML frontmatter
6. Suggests specific cleanup actions

**Output**: Cleanup report with prioritized recommendations

**Time**: 30-60 seconds

### test-runner

**When invoked**:
- Manually: `Please run tests` (Claude delegates)
- Automatically: PreToolUse hook detects test command

**What it does**:
1. Executes test/build commands
2. Captures full output
3. Parses results
4. Extracts failed test names
5. Summarizes for main context (10-15 lines)
6. Preserves full logs for reference

**Output**: Clean summary + detailed logs

**Time**: Depends on test suite (5-60s)

### doc-miner

**When invoked**:
- Manually: `/learn/from-codebase`
- Automatically: Weekly scheduled task

**What it does**:
1. Scans codebase for patterns (3+ occurrences)
2. Validates consistency
3. Generates rule files
4. Suggests additions to CLAUDE.md
5. Provides code examples
6. Prioritizes by impact

**Output**: Discovery report with suggested rules

**Time**: 60-120 seconds (depends on codebase size)

## Frontmatter Configuration

All subagents use YAML frontmatter:

```yaml
---
name: agent-name
description: When Claude should delegate to this agent
tools: Read, Grep, Glob
model: haiku|sonnet|opus|inherit
permissionMode: plan|acceptEdits|dontAsk|bypassPermissions
---
```

### Required Fields
- `name`: Lowercase identifier (max 64 chars)
- `description`: When to use (max 1024 chars) - Claude reads this
- `tools`: Comma-separated tools available

### Optional Fields
- `model`: Override default model
- `permissionMode`: Permission handling behavior
- `skills`: Load skills into agent
- `hooks`: Agent-specific hooks

## Permission Modes

| Mode | Behavior |
|------|----------|
| `plan` | Read-only, asks permission for file reads |
| `acceptEdits` | Auto-accept file modifications |
| `dontAsk` | Auto-deny permissions |
| `bypassPermissions` | Skip all permission checks |

## Tool Access

Each subagent has specific tools:

### context-cleaner
```
Read - Read files
Grep - Search content
Glob - Find files by pattern
```
✅ Safe for audit-only work
❌ Cannot modify files

### test-runner
```
Bash - Run commands
Read - Read files
```
✅ Can execute tests
✅ Can modify files (for test setup)
❌ Limited tool set by design

### doc-miner
```
Read - Read files
Grep - Search content
Glob - Find files by pattern
```
✅ Safe for analysis
❌ Cannot modify files (suggests only)

## Integration

### SessionStart Hook
```bash
# SessionStart hook loads subagents
# Makes them available for delegation
```

### PreToolUse Hook
```bash
# Detects verbose commands
# Delegates to test-runner automatically
```

### Slash Commands
```bash
/context/optimize        # Delegates to context-cleaner
/learn/from-codebase     # Delegates to doc-miner
```

## Creating Custom Subagents

Template:

```yaml
---
name: custom-agent
description: Specific task this agent handles
tools: Read, Write, Grep
model: haiku
permissionMode: plan
---

# Custom Agent

Describe what this agent does and how to invoke it.

## Process

1. Step one
2. Step two
3. Step three

## Output Format

Explain expected output format.
```

## Testing Subagents

### Manual Testing

```bash
# Start Claude Code with agent
claude --agents .claude/agents/test-runner.md

# In conversation:
"Please run tests"  # Should delegate to test-runner
```

### Validation Checklist

- ✓ YAML frontmatter parses
- ✓ Description is clear and specific
- ✓ Tools list is accurate
- ✓ Model is valid (haiku/sonnet/opus/inherit)
- ✓ PermissionMode is valid
- ✓ Agent completes within time limits
- ✓ Output format is clear

## Best Practices

### Naming
- Use lowercase with hyphens
- Be descriptive: `context-cleaner` not `cleaner`
- Avoid generic names: not `agent1`

### Descriptions
- Start with verb: "Analyzes...", "Executes...", "Discovers..."
- Include trigger: "When you ask...", "When detecting..."
- Be specific: "Cleans up stale memory" not "Helps with cleanup"
- Max 1024 chars

### Tool Selection
- Only include tools needed
- Prefer read-only when possible
- Use `plan` mode for analysis
- Use `acceptEdits` only if necessary

### Model Selection
- `haiku` for fast, focused tasks
- `sonnet` for complex analysis
- `opus` for very complex reasoning
- `inherit` to use main conversation model

## Troubleshooting

### Subagent Not Invoked
- Check description matches context
- Verify agent file in correct directory
- Ensure YAML is valid
- Check tool access isn't too restrictive

### Subagent Too Slow
- Switch to `haiku` model
- Reduce tool access
- Optimize regex patterns
- Simplify output requirements

### Subagent Fails
- Check stderr output
- Verify tools are available
- Ensure permission mode correct
- Test file access paths

## See Also

- [ARCHITECTURE.md](../ARCHITECTURE.md) - Layer 3 overview
- [docs/LAYER_3_SUBAGENTS.md](../docs/LAYER_3_SUBAGENTS.md) - Full documentation
- [hooks/](../hooks/) - Hook integration

**Created**: 2026-01-09
**Status**: Production Ready
