# Hooks Configuration

Configuration files for Claude Code hooks that automate context capture and injection.

## Overview

Two configurations provided:

### default-hooks.json
**Minimal configuration** for Layer 1-2 integration:
- SessionStart: Inject context at session beginning
- SessionEnd: Capture context at session end
- PreCompact: Capture context before context window compaction

**Time overhead**: < 40 seconds per session
**Setup**: Ready to use

### advanced-hooks.json
**Full-featured configuration** for Layers 2-7:
- SessionStart: Context injection
- SessionEnd: Knowledge capture and archival
- PreCompact: Capture context before compaction
- PreToolUse: Verbose operation delegation
- PostToolUse: Pattern learning and rule generation

**Time overhead**: ~60 seconds per session
**Setup**: Requires Ollama and full implementation

## Installation

### Using Default Hooks

```bash
# Copy to Claude Code hooks directory
cp hooks/default-hooks.json ~/.claude/hooks.json

# Or for project-specific hooks
cp hooks/default-hooks.json .claude/hooks.json
```

### Using Advanced Hooks

```bash
# Requires Ollama installation first
ollama pull mistral:7b-instruct

# Then configure
cp hooks/advanced-hooks.json ~/.claude/hooks.json
```

## Hook Details

### SessionStart Hook

**When**: Triggered when session begins
**What it does**:
1. Loads `.claude/CLAUDE.md`
2. Checks current git branch
3. Finds recently modified files
4. Matches glob patterns against rules
5. Injects relevant context

**Output**: Markdown context injected into conversation

**Performance**: < 10 seconds (cached after first run)

### SessionEnd Hook

**When**: Triggered when session ends
**What it does**:
1. Analyzes conversation transcript
2. Extracts decisions and learnings (with Ollama)
3. Updates `.claude/CLAUDE.md` metadata
4. Appends session summary to "Current Focus"
5. Archives old content if needed

**Output**: JSON status response

**Performance**: 20-30 seconds (depends on Ollama)

### PreCompact Hook

**When**: Triggered before Claude Code compacts the conversation window
**What it does**:
1. Captures session context before window reduction
2. Saves decisions and learnings immediately
3. Prevents loss of context during compaction
4. Updates `.claude/CLAUDE.md` with latest state

**Why it matters**: Ensures no knowledge is lost when conversation becomes too long and needs compression.

**Triggers**:
- Manual: When user runs `/compact` command
- Automatic: When context window fills up

**Output**: JSON status response

**Performance**: 20-30 seconds (background operation)

### PreToolUse Hook (Advanced)

**When**: Before running tool (test, log commands, etc.)
**What it does**:
1. Detects verbose operations
2. Decides whether to delegate to subagent
3. Keeps main context clean

**Pattern matching**:
```json
"matcher": "Bash(npm test|pytest|docker.*logs)"
```

### PostToolUse Hook (Advanced)

**When**: After tool completes (especially Edit)
**What it does**:
1. Tracks pattern of corrections
2. Detects 3+ occurrence patterns
3. Generates `.claude/rules/` file
4. Updates "Common Patterns" in CLAUDE.md

**Tracking**: Maintains JSON history of corrections

## Environment Variables

Available in hooks:

- `${CLAUDE_PLUGIN_ROOT}`: Plugin directory path
- `${CLAUDE_PROJECT_DIR}`: Project root directory
- `${CWD}`: Current working directory

## Timeout Recommendations

- SessionStart: 10 seconds (must complete)
- SessionEnd: 30 seconds (background)
- PreCompact: 30 seconds (background, before compaction)
- PreToolUse: 5 seconds (fast decision)
- PostToolUse: 15 seconds (pattern analysis)

## Ollama Integration

Hooks automatically detect Ollama:

```bash
# Install Ollama
curl https://ollama.ai/install.sh | sh

# Pull required models
ollama pull mistral:7b-instruct  # For session summarization
ollama pull nomic-embed-text     # For semantic search (Layer 5)
```

**Fallback**: If Ollama unavailable, hooks use basic extraction

## Customization

### Adding Custom Hooks

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "pattern",
        "hooks": [
          {
            "type": "command",
            "command": "path/to/script.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### Creating Custom Hook Scripts

Template:

```bash
#!/bin/bash
set -e

# Read input
read -r INPUT
CWD=$(echo "$INPUT" | jq -r '.cwd')

cd "$CWD"

# Do work...

# Return JSON
echo '{"status": "success", "custom_field": "value"}' | jq .
```

## Troubleshooting

### Hooks Not Running

1. Check configuration file syntax: `jq . hooks/default-hooks.json`
2. Verify script paths are absolute
3. Ensure scripts are executable: `chmod +x scripts/*.sh`
4. Check Claude Code logs for errors

### Slow Session Start

1. Reduce PreToolUse matchers
2. Optimize rule glob patterns
3. Archive old CLAUDE.md content (> 50KB triggers slowdown)
4. Check git performance: `git status` slow?

### Ollama Not Used

1. Verify installation: `ollama --version`
2. Check model available: `ollama list`
3. Start daemon: `ollama serve` (if not running)
4. Hook will fallback to basic summary if unavailable

## Performance Benchmarks

| Hook | Time | Status |
|------|------|--------|
| SessionStart | 5-10s | Critical |
| SessionEnd | 20-30s | Background |
| PreCompact | 20-30s | Background (on-demand) |
| PreToolUse | 2-5s | Decision |
| PostToolUse | 10-15s | Learning |

**Total per session**: < 60 seconds overhead
**PreCompact**: Only runs when context window fills up or on `/compact` command

## See Also

- [docs/LAYER_2_HOOKS.md](../docs/LAYER_2_HOOKS.md) - Complete documentation
- [scripts/](../scripts/) - Hook implementation files
- [ARCHITECTURE.md](../ARCHITECTURE.md) - Hook lifecycle

**Created**: 2026-01-09
**Status**: Production Ready
