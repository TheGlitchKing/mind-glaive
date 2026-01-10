---
paths: ["backend/migrations/**/*.py", "backend/app/models/**/*.py", "backend/app/db/**/*.py"]
priority: 9
description: Database schema design and query patterns
tags: [backend, database, sql, orm]
---

# Database Patterns & Best Practices

Standards for schema design, migrations, and ORM usage with PostgreSQL + SQLAlchemy.

## Schema Design Principles

1. **Primary Keys**: Use `id: UUID` as primary key in all tables
2. **Timestamps**: Include `created_at` and `updated_at` in all tables
3. **Soft Deletes**: Use `deleted_at` nullable timestamp instead of hard deletes
4. **Foreign Keys**: Always include proper FK constraints with CASCADE/RESTRICT
5. **Indexes**: Index foreign keys, frequently searched columns, and sort keys

```python
# Example model
class User(Base):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    email: Mapped[str] = mapped_column(unique=True, index=True)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )
    deleted_at: Mapped[Optional[datetime]] = mapped_column(nullable=True)
```

## Query Best Practices

**Do**:
- Use parameterized queries (ORM handles this)
- Load relationships explicitly with `joinedload` or `selectinload`
- Use pagination for large result sets
- Add query timeouts to prevent runaway queries

**Don't**:
- N+1 queries (use eager loading)
- Load entire tables without filters
- Use raw SQL unless absolutely necessary
- Store passwords or secrets in database

## Migrations

Use Alembic for schema changes:

```bash
alembic revision -m "add user email unique constraint"
# Edit migration file, then:
alembic upgrade head
```

Always:
- Test migrations in development first
- Provide backward-compatible migrations
- Document any data transformations
- Review for performance impact

---

**Priority**: 9 (high priority)
**Tags**: backend, database, sql
**Applies To**: All database-related code
