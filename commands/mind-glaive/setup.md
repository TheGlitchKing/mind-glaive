---
description: Complete mind-glaive setup in one command - initializes hooks and enables plugin
---

# Setup mind-glaive for This Project

Complete one-command setup that:
1. Initializes hooks in `.claude/` (creates hooks.json, scripts/)
2. Enables the mind-glaive plugin
3. Shows welcome message with next steps

## Usage

```
/mind-glaive/setup [template]
```

**Templates:**
- `minimal` (default) - Lightweight for small projects
- `full-stack` - For web applications
- `data-science` - For ML/research projects

## Examples

```
/mind-glaive/setup
/mind-glaive/setup full-stack
/mind-glaive/setup data-science
```

## What It Does

1. **Find mind-glaive repo** - Locates installed plugin directory
2. **Run install.sh** - Initializes project with hooks and configuration
3. **Enable plugin** - Activates mind-glaive for this project
4. **Show welcome** - Displays quick start guide

## After Setup

You'll see:
- ✅ Installation complete message
- 📁 Project context initialized (`.claude/CLAUDE.md`)
- 🎣 Hooks activated (SessionStart, SessionEnd, PreCompact)
- 📝 Slash commands ready

Then run:

```
/context/status
```

To check your context health!

---

**Need help?** Run `/welcome` anytime to see all available commands.
