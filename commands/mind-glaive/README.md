# mind-glaive Commands

Quick commands for managing mind-glaive in your projects.

## Setup Command (Most Important!)

### `/mind-glaive/setup` - One-Command Installation

After installing the plugin from the marketplace, run this **once per project**:

```
/mind-glaive/setup
```

This automatically:
1. ✅ Initializes project hooks (`.claude/hooks.json`)
2. ✅ Enables the mind-glaive plugin
3. ✅ Shows the welcome guide

**With template selection:**

```
/mind-glaive/setup full-stack
/mind-glaive/setup data-science
```

### Why One Command?

Normally mind-glaive requires 2 steps:
```bash
./install.sh --scope project --template minimal  # Terminal
/plugin enable mind-glaive                         # Claude Code
```

But `/mind-glaive/setup` does both automatically from within Claude Code!

## Workflow

**For all collaborators:**

```
1. Install plugin (once per person):
   /plugin install TheGlitchKing/mind-glaive

2. Initialize project (once per project):
   /mind-glaive/setup

3. Verify it works:
   /context/status
```

That's it! 🎉

## Available Commands

| Command | Purpose | When to Use |
|---------|---------|------------|
| `/mind-glaive/setup` | Initialize hooks + enable plugin | After marketplace install |
| `/welcome` | Show setup guide | Anytime, to review steps |
| `/context/status` | Check context health | Regularly, monitor memory usage |
| `/context/optimize` | Clean up old context | When context > 50KB |

## Troubleshooting

**If `/mind-glaive/setup` fails:**

```bash
# Fall back to manual setup:
cd /path/to/mind-glaive
./install.sh --scope project --template minimal
# Then in Claude:
/plugin enable mind-glaive
```

**If hooks still don't work:**

1. Check `.claude/hooks.json` exists:
   ```bash
   ls -la .claude/hooks.json
   ```

2. Check scripts are executable:
   ```bash
   ls -la .claude/scripts/
   ```

3. Restart Claude Code and try again

---

For more details, see `/welcome` or the main README.md
