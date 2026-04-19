# Changelog

## [2.0.1] — 2026-04-19

### Fixed
- Skills restructured into per-skill subdirectories
  (`skills/<name>/SKILL.md`) so they are actually discoverable by
  Claude Code's plugin loader and by the runtime's skill-symlink
  postinstall. In 2.0.0 they were flat `.md` files at `skills/*.md`
  which neither path could pick up.

  ```
  skills/context-maintenance.md        →  skills/context-maintenance/SKILL.md
  skills/pattern-learning.md           →  skills/pattern-learning/SKILL.md
  skills/SKILL_MIND_GLAIVE_SETUP.md    →  skills/mind-glaive-setup/SKILL.md
  ```
- `scripts/link-skills.js` flipped `skillsDir: null` → `"skills"` so
  postinstall now symlinks the three skills into
  `<project>/.claude/skills/`.

### README
- v1 install instructions (`mind-glaive install --scope user --template
  full-stack`) rewritten to reflect the v2 flow (marketplace or
  project-level npm install). Added an Update management section.

---

## [2.0.0] — 2026-04-19

### Breaking changes

- **Package is now ESM** (`"type": "module"`). Node >= 20.
- **Hand-rolled `install|uninstall` subcommands removed.** They now
  print a migration pointer and exit 0 so existing automation doesn't
  silently break. Use the Claude Code plugin marketplace or npm
  install instead.
- Root-level `plugin.json` removed — manifest is now only at
  `.claude-plugin/plugin.json`.
- Marketplace source switched from `github` to `npm` (`@theglitchking/mind-glaive`).

### Migration

```bash
# Install via the marketplace
/plugin marketplace add TheGlitchKing/mind-glaive
/plugin install mind-glaive@mind-glaive-marketplace

# Or at the project level
npm install --save-dev @theglitchking/mind-glaive
```

### Added

- Adopts `@theglitchking/claude-plugin-runtime@^0.1.0`.
- **Postinstall** writes default `.claude/mind-glaive.json` (updatePolicy:
  nudge) and registers a SessionStart update-check hook in
  `.claude/settings.json` (with plugin-vs-npm dedup).
- **Slash + CLI subcommands:**
  - `/mind-glaive:update` / `mind-glaive update`
  - `/mind-glaive:policy [auto|nudge|off]` / `mind-glaive policy`
  - `/mind-glaive:status` / `mind-glaive status`
  - `/mind-glaive:relink` / `mind-glaive relink`

### Env-var opt-outs

| Variable | Effect |
|---|---|
| `MIND_GLAIVE_UPDATE_POLICY` | One-shot policy override |
| `MIND_GLAIVE_SKIP_HOOK_REGISTER=1` | Skip writing the SessionStart hook |

---

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-03

### Added
- NPM distribution under `@theglitchking/mind-glaive` scope
- CLI wrapper (`mind-glaive`) for easy command-line access
- NPM installation method: `npm install -g @theglitchking/mind-glaive`
- New commands:
  - `mind-glaive install` - Install the plugin with options
  - `mind-glaive uninstall` - Uninstall the plugin
  - `mind-glaive status` - Check installation status
  - `mind-glaive help` - Show help and usage information
- Postinstall messaging with quick start instructions
- Enhanced README with NPM installation section

### Changed
- Package now available via NPM in addition to Claude marketplace and direct installation
- Improved installation workflow with multi-channel distribution

### Maintained
- All existing functionality from v1.0.0 preserved
- Bash-based installer (`install.sh`) remains the core installation mechanism
- Claude marketplace installation method unchanged
- No breaking changes for existing users

## [1.0.0] - 2026-01-09

### Added
- Initial release of mind-glaive plugin
- 8-layer architecture for context management
- Intelligent memory hierarchy (CLAUDE.md, rules, archives)
- Context-preserving hooks (SessionStart, SessionEnd, PreToolUse, PostToolUse, PreCompact)
- Specialized subagents (context-cleaner, test-runner, doc-miner)
- Slash commands (/context/status, /context/optimize, /learn/*, /resume/*)
- MCP servers for external knowledge (project-kb, codebase-rag)
- Automated maintenance skills
- Pattern detection and auto-rule generation
- Three project templates (minimal, full-stack, data-science)
- Multi-scope support (user-global, project-local)
- Claude Code marketplace distribution
- Comprehensive documentation and examples

[1.1.0]: https://github.com/TheGlitchKing/mind-glaive/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/TheGlitchKing/mind-glaive/releases/tag/v1.0.0
