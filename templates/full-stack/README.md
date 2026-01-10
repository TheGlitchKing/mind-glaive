# Full-Stack Template

Complete CLAUDE.md structure for web applications with backend, frontend, and database.

## When to Use

- Building web applications or APIs
- REST/GraphQL services with frontend
- Need separate backend/frontend guidance
- Working with SQL databases
- Team development with multiple developers

## Contents

- `CLAUDE.md` - Full-stack structure with Backend/Frontend/Database sections
- `rules/backend/api-standards.md` - REST API design patterns
- `rules/backend/database-patterns.md` - Database schema and queries
- `rules/frontend/component-structure.md` - React component organization

## Pre-Configured For

**Backend**:
- FastAPI, Django, or similar
- PostgreSQL, MySQL, etc.
- Async/await patterns

**Frontend**:
- React 18+ or Vue 3+
- TypeScript
- Component-based architecture

## Customization

### Add More Backend Rules
```bash
mkdir -p .claude/rules/backend
cp rules/backend/api-standards.md .claude/rules/backend/
```

### Add Testing Standards
Add section to CLAUDE.md:
```markdown
## Testing Standards

### Unit Tests
- Framework: pytest (backend), vitest (frontend)
- Coverage: > 80%

### Integration Tests
- E2E: Playwright or Cypress
```

## Size

- CLAUDE.md: ~3KB
- Rules: ~6KB total
- Target: < 50KB with all customizations

**Created**: 2026-01-09
