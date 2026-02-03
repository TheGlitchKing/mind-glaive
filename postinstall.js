#!/usr/bin/env node

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m'
};

console.log(`
${colors.cyan}╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║              mind-glaive installed successfully!               ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝${colors.reset}

${colors.green}✓${colors.reset} Package installed: ${colors.blue}@theglitchking/mind-glaive${colors.reset}

${colors.yellow}Next Steps:${colors.reset}

  1. Run the installer to set up the plugin:
     ${colors.cyan}mind-glaive install --scope user --template full-stack${colors.reset}

     ${colors.blue}Scopes:${colors.reset}
       user    - Install globally (~/.claude/) for all projects
       project - Install locally (./.claude/) for this project only

     ${colors.blue}Templates:${colors.reset}
       minimal      - Small projects, learning (1KB)
       full-stack   - Web applications (8KB)  ${colors.yellow}← Recommended${colors.reset}
       data-science - ML/research projects (6KB)

  2. Check installation status:
     ${colors.cyan}mind-glaive status${colors.reset}

  3. After installation, use these Claude Code commands:
     ${colors.cyan}/context/status${colors.reset}     - Show context health metrics
     ${colors.cyan}/context/optimize${colors.reset}   - Run maintenance
     ${colors.cyan}/learn/from-session${colors.reset} - Extract patterns

${colors.yellow}Quick Start:${colors.reset}
  ${colors.cyan}mind-glaive help${colors.reset}

${colors.yellow}Documentation:${colors.reset}
  ${colors.blue}https://github.com/TheGlitchKing/mind-glaive${colors.reset}

`);
