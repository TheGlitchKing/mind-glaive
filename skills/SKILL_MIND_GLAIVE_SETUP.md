---
name: mind-glaive-setup
description: Initialize mind-glaive for a project with one command
triggers:
  - /mind-glaive/setup
  - setup mind-glaive
---

# mind-glaive Setup Skill

Automates the complete mind-glaive initialization for a project.

## Triggers

- `/mind-glaive/setup [template]`
- `setup mind-glaive`

## What It Does

When invoked, this skill:

1. **Detects mind-glaive location**
   - Finds the installed plugin in `~/.claude/plugins/cache/mind-glaive-marketplace/mind-glaive/1.0.0/`
   - Or uses `${CLAUDE_PLUGIN_ROOT}` environment variable

2. **Runs install.sh**
   ```bash
   ${PLUGIN_DIR}/install.sh --scope project --template [template]
   ```
   - Creates `.claude/` structure
   - Copies `hooks.json` to `.claude/hooks.json`
   - Copies hook scripts to `.claude/scripts/`
   - Makes scripts executable

3. **Enables the plugin**
   ```bash
   /plugin enable mind-glaive
   ```

4. **Shows welcome**
   ```bash
   /welcome
   ```

## Input Parameters

- `template` (optional, default: `minimal`)
  - `minimal` - Small projects, learning
  - `full-stack` - Web applications
  - `data-science` - ML/research projects

## Output

Success message showing:
- ✅ Installation location
- ✅ Template used
- ✅ Hooks initialized
- ✅ Plugin enabled
- ✅ Next steps

## Error Handling

If install.sh fails:
- Show error message
- Provide troubleshooting steps
- Suggest manual installation: `./install.sh --scope project --template minimal`

## Example Execution

```
User: /mind-glaive/setup full-stack

Skill executes:
1. Find mind-glaive plugin directory
2. Run: /path/to/mind-glaive/install.sh --scope project --template full-stack
3. Enable plugin
4. Show welcome message

Output:
✅ mind-glaive initialized for RE-InvestorHub
   Template: full-stack
   Location: /mnt/e/docker-containers/RE-InvestorHub/.claude/
   Hooks: Active (SessionStart, SessionEnd, PreCompact)
   Status: Ready to use!

Run: /welcome for quick start guide
```

## Code Implementation

This skill should:

```python
# 1. Get plugin root from environment
plugin_root = os.environ.get('CLAUDE_PLUGIN_ROOT')
if not plugin_root:
    # Try to find it in standard location
    plugin_root = f"{os.path.expanduser('~')}/.claude/plugins/cache/mind-glaive-marketplace/mind-glaive/1.0.0"

# 2. Get template from user input (default: minimal)
template = user_input.get('template', 'minimal')

# 3. Run installer
result = subprocess.run(
    [f"{plugin_root}/install.sh", "--scope", "project", "--template", template],
    cwd=os.getcwd(),
    capture_output=True,
    text=True
)

if result.returncode != 0:
    return error(f"Installation failed: {result.stderr}")

# 4. Enable plugin (via Claude Code API or Bash)
enable_result = subprocess.run(
    ["/plugin", "enable", "mind-glaive"],
    capture_output=True,
    text=True
)

# 5. Show welcome
show_welcome()

return success(f"✅ mind-glaive setup complete!")
```

## Integration Notes

- This is a **user-facing skill** that simplifies the 2-step setup
- Runs via slash command or natural language trigger
- Requires bash access to execute install.sh
- Requires Claude Code API access to enable plugin
