---
paths: ["frontend/src/components/**/*.tsx", "frontend/src/**/*.jsx", "web/components/**/*.tsx"]
priority: 8
description: React component structure and patterns
tags: [frontend, react, typescript, components]
---

# Component Structure & Standards

Guidelines for React component organization, naming, and composition patterns.

## File Organization

```
src/components/
├── common/              # Reusable, app-agnostic components
│   ├── Button.tsx
│   └── Modal.tsx
├── features/            # Feature-specific components
│   ├── UserAuth/
│   │   ├── LoginForm.tsx
│   │   └── index.ts
│   └── Dashboard/
└── layouts/             # Page layout components
    ├── Header.tsx
    └── Sidebar.tsx
```

## Component Naming

- **PascalCase**: `UserCard`, `LoginButton`, `DashboardLayout`
- **Files match component names**: `UserCard.tsx` exports `UserCard`
- **Descriptive names**: `UserProfileCard` better than `Card`
- **Avoid generic names**: Not `Container`, not `Wrapper`

## Component Structure

```typescript
import React from "react";
import { UserData } from "@/types";
import styles from "./UserCard.module.css";

interface UserCardProps {
  user: UserData;
  onEdit?: (id: string) => void;
  loading?: boolean;
}

export function UserCard({
  user,
  onEdit,
  loading = false,
}: UserCardProps): React.ReactElement {
  return (
    <div className={styles.card}>
      <h3>{user.name}</h3>
      {/* content */}
    </div>
  );
}
```

## Best Practices

**Do**:
- Use TypeScript interfaces for props
- Destructure props in function signature
- Use proper loading/error states
- Export components as named exports
- Memoize expensive components with `React.memo`
- Use hooks for state (not class components)

**Don't**:
- Inline styles (use CSS modules)
- Large prop lists (consider component composition)
- Complex logic in render (extract to hooks)
- Default exports (use named exports)

## Reusable Components

Components in `common/` should:
- Have no business logic
- Accept flexible props
- Include TypeScript types
- Have no dependencies on app state
- Be thoroughly tested

---

**Priority**: 8 (standard priority)
**Tags**: frontend, react, typescript
**Applies To**: All React/TypeScript components
