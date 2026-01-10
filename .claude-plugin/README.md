# mind-glaive Marketplace

Official marketplace for **mind-glaive** - a production-ready Claude Code plugin that eliminates context rot through intelligent memory management, auto-learning hooks, and specialized subagents.

## About This Marketplace

This marketplace contains:
- **mind-glaive v1.0.0** - The complete context preservation system plugin

## Installing From This Marketplace

### Method 1: Add Marketplace in Claude Code

Within a Claude Code session, add this marketplace:

```
/plugin marketplace add TheGlitchKing/mind-glaive
```

Or using the shorthand:

```
/plugin market add TheGlitchKing/mind-glaive
```

Then install the plugin:

```
/plugin install mind-glaive
```

### Method 2: Direct Installation (Without Marketplace)

Clone and install directly:

```bash
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive
./install.sh --scope user --template full-stack
```

## What is mind-glaive?

**mind-glaive** is an intelligent Claude Code plugin that solves context rot through:

- **8-Layer Architecture**: Memory hierarchy, hooks, subagents, commands, MCP servers, skills, intelligence, and distribution
- **Automatic Context Capture**: SessionStart/End hooks capture and inject knowledge automatically
- **Specialized Subagents**: Isolate verbose operations and mine patterns from your codebase
- **7 Slash Commands**: Manage context, learn from sessions, and resume work
- **Knowledge Base**: SQLite database + semantic search for persistent knowledge
- **Auto-Learning**: Learns from repeated corrections and auto-generates rules at 3+ occurrences

## Features

✅ **Intelligent Memory Hierarchy**
- CLAUDE.md template with YAML frontmatter
- Modular rules with glob pattern matching
- Archive system for historical knowledge
- Session tracking and metadata management

✅ **Context Preservation**
- SessionStart hook: Auto-injects relevant context
- SessionEnd hook: Captures learning automatically
- PreToolUse hook: Detects verbose operations
- PostToolUse hook: Learns from corrections

✅ **User Interface**
- 7 slash commands for context management
- Subagent delegation for complex tasks
- Clear status reporting
- Resume functionality for interrupted work

✅ **Knowledge Base**
- SQLite project-kb for session storage
- Semantic codebase-rag for pattern discovery
- MCP server integration
- Ready for Ollama local embeddings

## Installation Requirements

- Claude Code v1.0.0+
- Git (for cloning)
- Bash shell
- Optional: Ollama for local LLM summarization

## Supported Platforms

- ✅ macOS
- ✅ Linux
- ✅ Windows (WSL2)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/TheGlitchKing/mind-glaive.git
cd mind-glaive

# Install globally (all your projects)
./install.sh --scope user --template full-stack

# Start Claude Code
claude

# Check installation
/context/status
```

## Project Templates

Choose during installation:

- **minimal** - Lightweight setup for small projects (1KB)
- **full-stack** - Complete structure for web apps (8KB)
- **data-science** - ML/research project configuration (6KB)

## Documentation

- [README.md](https://github.com/TheGlitchKing/mind-glaive/blob/main/README.md) - Project overview
- [ARCHITECTURE.md](https://github.com/TheGlitchKing/mind-glaive/blob/main/ARCHITECTURE.md) - 8-layer design
- [IMPLEMENTATION_GUIDE.md](https://github.com/TheGlitchKing/mind-glaive/blob/main/IMPLEMENTATION_GUIDE.md) - Build instructions
- [docs/LAYER_1_MEMORY.md](https://github.com/TheGlitchKing/mind-glaive/blob/main/docs/LAYER_1_MEMORY.md) - Memory system guide

## Commands

Once installed, you can use:

```bash
/context/status          # Show memory health metrics
/context/optimize        # Run cleanup and optimization
/context/reset           # Clear and reinitialize context

/learn/from-session      # Extract patterns from current session
/learn/from-codebase     # Mine patterns from codebase

/resume/last-task        # Continue from previous session
/resume/branch           # Load branch-specific context
```

## Support

- **Issues**: https://github.com/TheGlitchKing/mind-glaive/issues
- **Documentation**: https://github.com/TheGlitchKing/mind-glaive/tree/main/docs
- **Examples**: https://github.com/TheGlitchKing/mind-glaive/tree/main/examples

## License

MIT License - See [LICENSE](https://github.com/TheGlitchKing/mind-glaive/blob/main/LICENSE) file

## Version

Current: **1.0.0** (Production Ready)

---

**Repository**: https://github.com/TheGlitchKing/mind-glaive
**Author**: TheGlitchKing
**Status**: Production Ready ✅
