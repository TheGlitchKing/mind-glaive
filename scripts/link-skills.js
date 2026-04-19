#!/usr/bin/env node
// Postinstall — delegates to @theglitchking/claude-plugin-runtime.

import { runPostinstall } from "@theglitchking/claude-plugin-runtime";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");

try {
  runPostinstall({
    packageName: "@theglitchking/mind-glaive",
    pluginName: "mind-glaive",
    configFile: "mind-glaive.json",
    skillsDir: null,
    packageRoot,
    hookCommand:
      "node ./node_modules/@theglitchking/mind-glaive/hooks/session-start.js",
  });
} catch (err) {
  console.warn(`[mind-glaive] postinstall failed: ${err?.message || err}`);
}
