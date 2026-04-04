# Task Manager API Specification

## Overview

A REST API for managing tasks. Built with Express.js and an in-memory data store.

## Requirements

### REQ-1: CRUD Endpoints

The API must expose the following endpoints:

| Method | Path | Description |
|--------|------|-------------|
| GET | `/tasks` | List all tasks |
| GET | `/tasks/:id` | Get a single task by ID |
| POST | `/tasks` | Create a new task |
| PUT | `/tasks/:id` | Update an existing task |
| DELETE | `/tasks/:id` | Delete a task |

- `POST /tasks` returns `201 Created` with the created task.
- `GET /tasks/:id` returns `404 Not Found` if the task does not exist.
- `PUT /tasks/:id` returns `404 Not Found` if the task does not exist.
- `DELETE /tasks/:id` returns `204 No Content` on success, `404 Not Found` if the task does not exist.

### REQ-2: Task Fields

Every task must contain the following fields:

| Field | Type | Description |
|-------|------|-------------|
| `id` | string (UUID) | Auto-generated unique identifier |
| `title` | string | Required. Task title. |
| `description` | string | Optional. Defaults to empty string. |
| `status` | enum | One of: `todo`, `in-progress`, `done`. Defaults to `todo`. |
| `priority` | enum | One of: `low`, `medium`, `high`. Defaults to `medium`. |
| `createdAt` | ISO 8601 string | Auto-generated on creation |
| `updatedAt` | ISO 8601 string | Auto-updated on every modification |

### REQ-3: Filtering

`GET /tasks` must support the following query parameters for filtering:

| Parameter | Type | Behavior |
|-----------|------|----------|
| `status` | string | Return only tasks matching this status |
| `priority` | string | Return only tasks matching this priority |

Both filters can be used together. Invalid filter values should be ignored (return all tasks).

### REQ-4: Status Transitions

Status changes must follow a strict forward-only progression:

```
todo -> in-progress -> done
```

Rules:
- A task in `todo` can only transition to `in-progress`.
- A task in `in-progress` can only transition to `done`.
- A task in `done` cannot transition to any other status.
- Attempting an invalid transition must return `422 Unprocessable Entity` with an error message describing the allowed transition.

### REQ-5: Delete Guard

A task that is currently `in-progress` must not be deleted. Attempting to delete an in-progress task must return `409 Conflict` with a message explaining that the task must be completed or reverted before deletion.
