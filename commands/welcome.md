---
description: Welcome to mind-glaive! Verify installation and learn next steps
---

# Welcome to mind-glaive

✅ **Installation Successful!**

mind-glaive has been installed and is ready to use.

---

## 🚀 Quick Start

### 1. Check Your Context
```
/context/status
```
Shows memory size, rules count, and health metrics.

### 2. Learn From Your Session
```
/learn/from-session
```
Extracts patterns and learnings from your current work.

### 3. Mine Your Codebase
```
/learn/from-codebase
```
Discovers patterns and generates rule suggestions.

### 4. Optimize When Needed
```
/context/optimize
```
Identifies stale content and suggests cleanup when context grows.

### 5. Resume Your Work
```
/resume/last-task
```
Continue from where you left off with automatic context injection.

---

## 📚 Available Commands

| Command | Purpose |
|---------|---------|
| `/context/status` | Show memory health & metrics |
| `/context/optimize` | Get cleanup recommendations |
| `/context/reset [template]` | Fresh start (backs up first) |
| `/learn/from-session` | Extract session patterns |
| `/learn/from-codebase` | Mine codebase for patterns |
| `/resume/last-task` | Continue previous work |
| `/resume/branch` | Load branch-specific context |

---

## 🎯 How It Works

**mind-glaive** automatically:
- 📸 Captures context at session end
- 💾 Injects relevant context at session start
- 🧠 Learns from your corrections (3+ occurrences = auto-rule)
- 🗂️ Archives old decisions to keep memory focused
- 🔍 Discovers patterns in your codebase

---

## 📁 Where It's Stored

Your project context is in `.claude/`:
```
.claude/
├── CLAUDE.md           # Your project context
├── rules/              # Project-specific rules
├── archives/           # Historical decisions
└── commands/           # Custom commands
```

---

## 💡 Best Practices

1. **Keep context focused** - Archive decisions >90 days old
2. **Run `/context/status` weekly** - Monitor memory size
3. **Use `/context/optimize` monthly** - Clean up when > 50KB
4. **Enable auto-learning** - Let patterns emerge from corrections
5. **Review archives quarterly** - Keep valuable history accessible

---

## 📖 Learn More

For detailed information, see:
- **README.md** - Project overview and features
- **docs/CLEANUP_GUIDE.md** - Memory management guide
- **docs/ARCHITECTURE.md** - System design (in docs/)
- **commands/README.md** - Command reference

---

## ✨ You're All Set!

Start using mind-glaive with:
```
/context/status
```

Questions? Check the documentation in the plugin repository:
https://github.com/TheGlitchKing/mind-glaive

Happy coding! 🚀
