# Changelog

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
