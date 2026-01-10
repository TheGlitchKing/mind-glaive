---
paths: ["**/*.py"]
priority: 5
description: Example rule demonstrating structure and best practices
tags: [python, example]
---

# Example Rule - Python Style Guide

This is an example rule file showing the recommended structure for all rules.

## Key Features of This Rule

- **YAML Frontmatter**: Defines when this rule is activated via glob patterns
- **Path Matching**: Uses `paths` field with glob syntax (supports brace expansion)
- **Priority System**: Higher number = loaded first (relevant when multiple rules match)
- **Context Efficiency**: Kept under 2KB to minimize memory overhead
- **Progressive Disclosure**: Links to detailed documentation, not inline

## When This Rule Applies

This rule activates when you're working with Python files matching `**/*.py`.

Other glob pattern examples:
- Single pattern: `src/**/*.ts`
- Multiple patterns: `{src,lib}/**/*.{ts,tsx}`
- Specific directory: `backend/app/api/**/*.py`
- Negation: Use exclude patterns in rule matchers

## Rule Content Guidelines

✅ **Do**:
- Be specific ("Use 4-space indentation" not "Format properly")
- Include practical examples
- Reference external docs for detailed info
- Keep under 2KB total
- Use clear markdown formatting
- Add tags for categorization

❌ **Don't**:
- Include very long examples
- Repeat content from other rules
- Use vague language
- Exceed 2KB limit

## Example

```python
# Good: Specific docstring format
def calculate_sum(numbers: list[int]) -> int:
    """Calculate sum of numbers.

    Args:
        numbers: List of integers to sum

    Returns:
        The sum of all numbers
    """
    return sum(numbers)
```

## References

- See `docs/LAYER_1_MEMORY.md` for complete rule system documentation
- Check `.claude/rules/` directory for more examples by domain
- Refer to project CLAUDE.md for Critical Decisions that impact rules

---

**Priority**: 5 (standard priority)
**Tags**: python, example
**Last Updated**: 2026-01-09
