#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const INSTALL_SCRIPT = path.join(__dirname, '..', 'install.sh');
const UNINSTALL_SCRIPT = path.join(__dirname, '..', 'uninstall.sh');

// Colors for output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

function showHelp() {
  console.log(`
${colors.blue}mind-glaive CLI${colors.reset}

${colors.green}Usage:${colors.reset}
  mind-glaive install [--scope user|project] [--template template-name]
  mind-glaive uninstall [--scope user|project]
  mind-glaive status
  mind-glaive help

${colors.green}Commands:${colors.reset}
  install     Install mind-glaive plugin
  uninstall   Uninstall mind-glaive plugin
  status      Show installation status
  help        Show this help message

${colors.green}Install Options:${colors.reset}
  --scope {user|project}    Install scope (default: user)
                            user     - Install globally (~/.claude/)
                            project  - Install in current project (.claude/)

  --template {template}     Template type (default: minimal)
                            minimal      - Small projects, learning (1KB)
                            full-stack   - Web applications (8KB)
                            data-science - ML/research projects (6KB)

${colors.green}Examples:${colors.reset}
  mind-glaive install --scope user --template full-stack
  mind-glaive install --scope project --template minimal
  mind-glaive uninstall --scope user
  mind-glaive status

${colors.green}After Installation:${colors.reset}
  Run these commands in Claude Code:
    /context/status     - Show context health
    /context/optimize   - Run maintenance
    /learn/from-session - Extract patterns
  `);
}

function checkBash() {
  try {
    execSync('bash --version', { stdio: 'ignore' });
    return true;
  } catch (e) {
    return false;
  }
}

function checkInstallation(scope) {
  const installDir = scope === 'user'
    ? path.join(process.env.HOME || process.env.USERPROFILE, '.claude')
    : '.claude';

  const claudeMdPath = path.join(installDir, 'CLAUDE.md');
  const hooksPath = path.join(installDir, 'hooks.json');

  return fs.existsSync(claudeMdPath) && fs.existsSync(hooksPath);
}

function showStatus() {
  console.log(`\n${colors.blue}mind-glaive Installation Status${colors.reset}\n`);

  const userInstalled = checkInstallation('user');
  const projectInstalled = checkInstallation('project');

  console.log(`User Scope (~/.claude/):     ${userInstalled ? colors.green + '✓ Installed' : colors.yellow + '✗ Not installed'}${colors.reset}`);
  console.log(`Project Scope (./.claude/):  ${projectInstalled ? colors.green + '✓ Installed' : colors.yellow + '✗ Not installed'}${colors.reset}`);

  if (!userInstalled && !projectInstalled) {
    console.log(`\n${colors.yellow}Run: mind-glaive install${colors.reset}`);
  }
  console.log();
}

function runInstall(args) {
  if (!checkBash()) {
    console.error(`${colors.red}❌ Error: Bash is required but not found${colors.reset}`);
    console.error(`${colors.yellow}Windows users: Install WSL2 or Git Bash${colors.reset}`);
    process.exit(1);
  }

  const scope = args.includes('--scope') ? args[args.indexOf('--scope') + 1] : 'user';
  const template = args.includes('--template') ? args[args.indexOf('--template') + 1] : 'minimal';

  console.log(`${colors.blue}Installing mind-glaive...${colors.reset}`);
  console.log(`  Scope: ${scope}`);
  console.log(`  Template: ${template}\n`);

  try {
    execSync(`bash "${INSTALL_SCRIPT}" --scope ${scope} --template ${template}`, {
      stdio: 'inherit',
      cwd: path.dirname(INSTALL_SCRIPT)
    });
  } catch (error) {
    console.error(`${colors.red}❌ Installation failed${colors.reset}`);
    process.exit(1);
  }
}

function runUninstall(args) {
  if (!checkBash()) {
    console.error(`${colors.red}❌ Error: Bash is required but not found${colors.reset}`);
    process.exit(1);
  }

  const scope = args.includes('--scope') ? args[args.indexOf('--scope') + 1] : 'user';

  console.log(`${colors.blue}Uninstalling mind-glaive...${colors.reset}`);
  console.log(`  Scope: ${scope}\n`);

  try {
    execSync(`bash "${UNINSTALL_SCRIPT}" --scope ${scope}`, {
      stdio: 'inherit',
      cwd: path.dirname(UNINSTALL_SCRIPT)
    });
  } catch (error) {
    console.error(`${colors.red}❌ Uninstallation failed${colors.reset}`);
    process.exit(1);
  }
}

// Main
const args = process.argv.slice(2);
const command = args[0];

switch (command) {
  case 'install':
    runInstall(args.slice(1));
    break;

  case 'uninstall':
    runUninstall(args.slice(1));
    break;

  case 'status':
    showStatus();
    break;

  case 'help':
  case '--help':
  case '-h':
  case undefined:
    showHelp();
    break;

  default:
    console.error(`${colors.red}Unknown command: ${command}${colors.reset}`);
    console.log(`Run 'mind-glaive help' for usage information`);
    process.exit(1);
}
