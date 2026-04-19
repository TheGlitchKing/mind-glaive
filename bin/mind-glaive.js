#!/usr/bin/env node

import { program } from "commander";
import { registerUpdateCommands } from "@theglitchking/claude-plugin-runtime";
import { createRequire } from "node:module";

const require_ = createRequire(import.meta.url);
const { version } = require_("../package.json");

program
  .name("mind-glaive")
  .description("Eliminate context rot in Claude Code with intelligent memory, auto-learning hooks, and specialized subagents.")
  .version(version);

registerUpdateCommands(program, {
  packageName: "@theglitchking/mind-glaive",
  pluginName: "mind-glaive",
  configFile: "mind-glaive.json",
});

function deprecationNotice(name) {
  console.error(`\n⚠️  'mind-glaive ${name}' was removed in v2.0.0.\n`);
  console.error(`Install via the Claude Code plugin marketplace:`);
  console.error(`  /plugin marketplace add TheGlitchKing/mind-glaive`);
  console.error(`  /plugin install mind-glaive@mind-glaive-marketplace\n`);
  console.error(`Or at the project level via npm:`);
  console.error(`  npm install --save-dev @theglitchking/mind-glaive\n`);
  console.error(`See the v2.0.0 CHANGELOG for migration details:`);
  console.error(`  https://github.com/TheGlitchKing/mind-glaive/blob/main/CHANGELOG.md\n`);
}

for (const name of ["install", "uninstall"]) {
  program
    .command(name)
    .description(`[removed in v2.0.0] use the marketplace or npm install`)
    .option("--scope <scope>")
    .option("--template <template>")
    .allowUnknownOption(true)
    .action(() => { deprecationNotice(name); process.exit(0); });
}

program.parse();
