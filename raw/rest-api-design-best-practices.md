# REST API Design Best Practices

*By Sarah Chen, 2026-03-15*

## Introduction

REST (Representational State Transfer) remains the dominant architectural style for web APIs. This article summarizes current best practices for designing REST APIs that are consistent, maintainable, and developer-friendly.

## URL Structure

- Use nouns, not verbs: `/users` not `/getUsers`.
- Use plural nouns: `/users` not `/user`.
- Nest for relationships: `/users/{id}/orders`.
- Keep URLs shallow — max 3 levels deep.
- Use kebab-case for multi-word paths: `/order-items` not `/orderItems`.

## HTTP Methods

| Method | Purpose | Idempotent |
|--------|---------|------------|
| GET    | Read    | Yes        |
| POST   | Create  | No         |
| PUT    | Replace | Yes        |
| PATCH  | Update  | No         |
| DELETE | Remove  | Yes        |

## Status Codes

Use standard HTTP status codes consistently:
- **200** OK — successful GET/PUT/PATCH
- **201** Created — successful POST
- **204** No Content — successful DELETE
- **400** Bad Request — validation error
- **401** Unauthorized — missing or invalid auth
- **403** Forbidden — valid auth but insufficient permissions
- **404** Not Found — resource doesn't exist
- **409** Conflict — duplicate or state conflict
- **422** Unprocessable Entity — semantic validation failure
- **500** Internal Server Error — unexpected server failure

## Error Response Format

Always return structured error responses:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email address is required",
    "details": [
      {
        "field": "email",
        "reason": "required"
      }
    ]
  }
}
```

## Pagination

For list endpoints, use cursor-based pagination over offset-based:

```
GET /users?cursor=abc123&limit=20
```

Response should include navigation links:

```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "def456",
    "has_more": true
  }
}
```

Offset-based pagination (`?page=2&per_page=20`) is simpler but performs poorly on large datasets due to `OFFSET` queries.

## Versioning

Prefer URL path versioning (`/v1/users`) over header-based versioning. It's explicit, easy to test, and works with any HTTP client. Header versioning (`Accept: application/vnd.api+json;version=1`) is more "pure" REST but harder to discover and debug.

## Authentication

Use Bearer tokens in the Authorization header:

```
Authorization: Bearer <token>
```

Never pass tokens as query parameters — they appear in server logs and browser history.

## Rate Limiting

Return rate limit info in response headers:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1620000000
```

Return **429 Too Many Requests** when limits are exceeded.

## Key Takeaways

1. Consistency matters more than perfection — pick conventions and stick to them.
2. Design for the consumer, not the database schema.
3. Use standard HTTP semantics — don't reinvent status codes or methods.
4. Plan for pagination and rate limiting from day one.
5. Version your API from the first release.
