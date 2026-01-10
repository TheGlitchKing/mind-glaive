# Development Guide

Contributing to the Context Preservation System.

## Project Structure

```
.
├── README.md                 # Project overview
├── ARCHITECTURE.md           # System design
├── ROADMAP.md               # Implementation timeline
├── IMPLEMENTATION_GUIDE.md   # Build instructions
├── LICENSE                  # MIT License
│
├── docs/                    # Layer-specific documentation
│   ├── LAYER_1_MEMORY.md
│   ├── LAYER_2_HOOKS.md
│   ├── LAYER_3_SUBAGENTS.md
│   ├── LAYER_4_COMMANDS.md
│   ├── LAYER_5_MCP.md
│   ├── LAYER_6_SKILLS.md
│   ├── LAYER_7_INTELLIGENCE.md
│   └── LAYER_8_DISTRIBUTION.md
│
├── templates/               # Project templates
│   ├── minimal/
│   ├── full-stack/
│   └── data-science/
│
├── scripts/                 # Hook implementations
│   ├── capture-session-knowledge.sh
│   ├── inject-session-context.sh
│   └── learn-from-corrections.sh
│
├── hooks/                   # Hook configurations
│   ├── default-hooks.json
│   ├── advanced-hooks.json
│   └── README.md
│
├── agents/                  # Subagent definitions
│   ├── context-cleaner.md
│   ├── test-runner.md
│   ├── doc-miner.md
│   └── README.md
│
├── commands/                # Slash commands
│   ├── context/
│   ├── learn/
│   ├── resume/
│   └── README.md
│
├── skills/                  # Automated skills
│   ├── context-maintenance.md
│   ├── pattern-learning.md
│   └── README.md
│
├── mcp-servers/            # MCP server implementations
│   ├── project-kb/
│   ├── codebase-rag/
│   └── README.md
│
├── examples/               # Real-world examples
│   ├── archives/
│   └── ...
│
├── tests/                  # Test suite
│   ├── test-install.sh
│   ├── test-uninstall.sh
│   └── README.md
│
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
└── plugin.json             # Plugin manifest
```

## Code Style

### Bash Scripts
```bash
#!/bin/bash
set -e  # Exit on error

# Clear comments
# Use absolute paths
# Quote variables: "$VAR"
# Function documentation
```

### Python
```python
#!/usr/bin/env python3
"""Module docstring."""

def function_name(param: Type) -> Type:
    """Function docstring with type hints."""
    pass
```

### YAML/Markdown
```yaml
---
field: value
list:
  - item1
  - item2
---

# Header

Content here
```

## Testing

### Run Tests
```bash
# Validate scripts
shellcheck scripts/*.sh

# Validate JSON
jq . hooks/default-hooks.json

# Test installation
./install.sh --scope project --template minimal
```

### Manual Testing
```bash
# Start Claude Code
claude

# Test commands
/context/status
/context/optimize
/learn/from-codebase

# Check context
cat .claude/CLAUDE.md
```

## Adding New Features

### New Layer
1. Create `docs/LAYER_X_NAME.md`
2. Create component files (agents/, commands/, skills/, etc.)
3. Add to ROADMAP.md
4. Update ARCHITECTURE.md
5. Test thoroughly
6. Document in README.md

### New Slash Command
1. Create `commands/{group}/{name}.md`
2. Add YAML frontmatter
3. Implement (bash or LLM delegation)
4. Document in `commands/README.md`
5. Test with `/name`

### New Subagent
1. Create `agents/{name}.md`
2. Define in YAML frontmatter
3. Write system prompt
4. Specify tools and model
5. Document behavior
6. Add to `agents/README.md`

## Commit Guidelines

Format:
```
type(scope): brief description

Detailed explanation of changes.

- File changes
- What was tested
- Related issues/docs
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`

Scopes: `layer1`, `layer2`, `hooks`, `commands`, `agents`, etc.

Example:
```
feat(layer4): add context/status command

Implements context health reporting command.

- Add commands/context/status.md
- Show memory size, rules, sessions
- Provide optimization recommendations
- Test with real project context

Closes #42
```

## Version Numbering

Semantic versioning: MAJOR.MINOR.PATCH

- **MAJOR**: Architecture changes or major features
- **MINOR**: New features or components
- **PATCH**: Bug fixes

Current: v1.0.0 (Initial release with all 8 layers)

## Release Process

1. Update version in `plugin.json`
2. Update `CHANGELOG.md`
3. Test on all platforms (macOS, Linux, Windows/WSL)
4. Create git tag: `git tag v1.0.0`
5. Push to GitHub: `git push origin v1.0.0`
6. Create GitHub release with notes

## Documentation

Every feature needs:
- ✅ Code comments (what, not why)
- ✅ YAML frontmatter (for agents, commands, skills)
- ✅ README in component directory
- ✅ Usage examples
- ✅ Related layer documentation
- ✅ Troubleshooting section

## Performance Targets

- SessionStart hook: < 10s
- SessionEnd hook: < 30s
- Context size: < 50KB per session
- Rule match time: < 100ms
- Pattern detection: < 60s
- Test coverage: > 70%

## Getting Help

- Check [README.md](README.md) for overview
- Read [ARCHITECTURE.md](ARCHITECTURE.md) for design
- See layer-specific docs in `docs/`
- Review examples in `examples/`
- Check tests in `tests/`

## Support

Report issues on GitHub.
Suggest improvements via discussions.
