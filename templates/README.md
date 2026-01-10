# Project Templates

Three pre-configured templates for different project types, each with a complete CLAUDE.md structure and domain-specific rules.

## Quick Comparison

| Template | Best For | Size | Rules | Setup |
|----------|----------|------|-------|-------|
| Minimal | Small projects, scripts | ~1KB | 1 | < 1 min |
| Full-Stack | Web applications, APIs | ~3KB | 3 | < 2 min |
| Data Science | ML/research projects | ~2KB | 2 | < 2 min |

## Installation

```bash
./install.sh --template minimal      # Minimal
./install.sh --template full-stack   # Full-Stack
./install.sh --template data-science # Data Science
```

## Templates Overview

### Minimal
- Perfect for small projects and learning
- Core CLAUDE.md structure with example rule
- Customizable as project grows
- See: `minimal/README.md`

### Full-Stack
- Web applications with backend/frontend
- Includes API standards and component guidelines
- Pre-configured for FastAPI + React stack
- See: `full-stack/README.md`

### Data Science
- ML projects and data analysis
- Jupyter notebook standards included
- Model development patterns documented
- See: `data-science/README.md`

## See Also

- [docs/LAYER_1_MEMORY.md](../docs/LAYER_1_MEMORY.md) - Complete reference
- [ARCHITECTURE.md](../ARCHITECTURE.md) - System overview

**Created**: 2026-01-09
