#!/usr/bin/env node
import { runSessionStart } from "@theglitchking/claude-plugin-runtime";

await runSessionStart({
  packageName: "@theglitchking/mind-glaive",
  pluginName: "mind-glaive",
  configFile: "mind-glaive.json",
});
