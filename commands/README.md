# Slash Commands

Custom commands for context preservation system.

## Overview

7 commands organized in 3 groups:

### Context Commands
- `/context/status` - Check memory health
- `/context/optimize` - Run cleanup
- `/context/reset` - Clear and reinitialize

### Learn Commands
- `/learn/from-session` - Extract session learnings
- `/learn/from-codebase` - Mine codebase patterns

### Resume Commands
- `/resume/last-task` - Continue previous work
- `/resume/branch` - Load branch context

## Storage

Place files in:
- **Project scope**: `.claude/commands/`
- **User scope**: `~/.claude/commands/`
- **Plugin scope**: Plugin directory (auto-discovered)

## File Structure

Commands use YAML frontmatter:

```yaml
---
description: What this command does (max 100 chars)
allowed-tools: Read, Bash, Write
argument-hint: [arg1, arg2]
model: claude-3-5-haiku-20241022
disable-model-invocation: false
---

# Command Name

Markdown content describing the command.

!bash
#!/bin/bash
# Optional: inline bash execution

Your bash script here
```

## Command Details

### /context/status

**Purpose**: Show context health metrics

**Output**:
- Memory file sizes
- Session count
- Last update time
- Active rules
- Recommendations

**Time**: < 5 seconds

### /context/optimize

**Purpose**: Run context cleaner subagent

**Output**:
- Stale sections identified
- Duplicate rules found
- Size analysis
- Specific cleanup recommendations

**Time**: 30-60 seconds

### /context/reset

**Purpose**: Clear context and reinitialize

**Arguments**:
- `minimal` - Small projects
- `full-stack` - Web applications
- `data-science` - ML projects
- `keep-decisions` - Keep critical decisions

**Action**: Creates backup, resets context, initializes template

**Time**: < 5 seconds

### /learn/from-session

**Purpose**: Extract learnings from current session

**Output**:
- Decisions made
- Patterns discovered
- Proposed CLAUDE.md updates
- New rule suggestions

**Time**: < 10 seconds

### /learn/from-codebase

**Purpose**: Mine codebase for patterns

**Process**:
1. Scan for 3+ occurrence patterns
2. Validate consistency
3. Generate rule suggestions
4. Provide code examples

**Output**: Discovery report with actionable recommendations

**Time**: 60-120 seconds (depends on codebase size)

### /resume/last-task

**Purpose**: Show what you were working on

**Output**:
- Current branch
- Recent changes
- Current focus items
- Recent decisions
- Suggested next steps

**Time**: < 5 seconds

### /resume/branch

**Purpose**: Load branch-specific context

**Process**:
1. Detect current branch
2. Load `.claude/context/branch-{name}.md`
3. Show recent commits
4. Show changed files
5. Suggest relevant work

**Output**: Branch context and recent activity

**Time**: < 5 seconds

## Usage Examples

```bash
# Check context health
/context/status

# Run cleanup
/context/optimize

# Reset to fresh start
/context/reset full-stack

# Extract this session's learnings
/learn/from-session

# Find patterns in code
/learn/from-codebase

# Continue previous work
/resume/last-task

# Load branch context
/resume/branch
```

## Creating Custom Commands

Template:

```yaml
---
description: Brief description (max 100 chars)
allowed-tools: Read, Bash, Write
argument-hint: [arg-name]
---

# Command Name

Description of what this command does.

Instructions for Claude to follow.

!bash
#!/bin/bash
# Optional bash execution

# Your script here
```

**Naming**:
- Start with `/` in descriptions
- Use slash-separated subcommands: `/context/status`
- Descriptive names: `/check-memory` not `/cm`

**Descriptions**:
- Start with verb: "Show...", "Run...", "Extract..."
- Include key trigger words
- Be specific: "Check memory health" not "Help with memory"

## Command Execution

### With Bash

Commands with `!bash` block execute shell code:

```yaml
!bash
#!/bin/bash
echo "Hello from command"
```

### With LLM

Commands without bash block delegate to Claude:

```markdown
Analyze the following context and provide recommendations...
```

## Advanced Features

### Arguments

Receive command arguments:

```yaml
---
argument-hint: [file-path]
---

Use the provided file path: $1
```

### File References

Use `@` prefix:

```
Review @src/config.json
Check @.claude/CLAUDE.md
```

### Permissions

Control tool access:

```yaml
allowed-tools: Read, Bash(git:*)
```

Restrict to specific patterns.

## Troubleshooting

### Command Not Found
- Check file in correct directory
- Verify syntax: `\`\`yaml ... \`\`\``
- Ensure description field present

### Command Too Slow
- Reduce scope of analysis
- Simplify bash execution
- Use subagent for complex logic

### Command Fails
- Check allowed-tools list
- Verify file paths
- Check bash syntax

## Performance

| Command | Time |
|---------|------|
| /context/status | 2-5s |
| /context/optimize | 30-60s |
| /context/reset | <5s |
| /learn/from-session | 5-10s |
| /learn/from-codebase | 60-120s |
| /resume/last-task | <5s |
| /resume/branch | <5s |

## See Also

- [ARCHITECTURE.md](../ARCHITECTURE.md) - Layer 4 overview
- [docs/LAYER_4_COMMANDS.md](../docs/LAYER_4_COMMANDS.md) - Full documentation
- [agents/](../agents/) - Subagent definitions

**Created**: 2026-01-09
**Status**: Production Ready
