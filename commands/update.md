---
description: Update mind-glaive to the latest version (runs npm update + re-links skills)
allowed-tools: Bash(npx:*)
---

Run `npx --no @theglitchking/mind-glaive update` and report the before/after versions to the user. If the project doesn't have a local install, fall back to `npx -y @theglitchking/mind-glaive update` and note that in your summary.
