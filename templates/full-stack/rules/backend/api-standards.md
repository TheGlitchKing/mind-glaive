---
paths: ["backend/app/api/**/*.py", "server/**/*.py"]
priority: 10
description: API endpoint design standards and best practices
tags: [backend, api, fastapi, python]
---

# API Endpoint Standards

Guidelines for REST API design, error handling, and request/response formatting.

## Required Decorators

Every endpoint must include:

1. **Rate Limiting**: Prevent abuse and ensure fair resource usage
2. **Input Validation**: Use Pydantic models for all request bodies
3. **Error Handling**: Consistent error response format

```python
@router.post("/users")
@rate_limit(100, 60)  # 100 requests per 60 seconds
async def create_user(user: UserCreate) -> UserResponse:
    """Create a new user.

    Args:
        user: User creation data (validated by Pydantic)

    Returns:
        Created user with ID
    """
    try:
        return await service.create_user(user)
    except DuplicateEmailError:
        raise HTTPException(status_code=409, detail="Email already exists")
```

## Error Response Format

All errors must use standard format:

```json
{
  "error": "error_type",
  "message": "Human-readable error message",
  "status": 400,
  "timestamp": "2026-01-09T12:00:00Z"
}
```

## HTTP Status Codes

- **200**: Success with data
- **201**: Resource created
- **204**: Success without data
- **400**: Client error (invalid input)
- **401**: Authentication required
- **403**: Permission denied
- **404**: Not found
- **409**: Conflict (duplicate, etc.)
- **429**: Rate limited
- **500**: Server error (log and alert)

## Documentation

All endpoints must have:
- Docstring explaining purpose
- Parameter descriptions
- Response type hints
- Example usage (in docstring or OpenAPI)

---

**Priority**: 10 (high priority)
**Tags**: backend, api, fastapi
**Max Size**: 2KB
