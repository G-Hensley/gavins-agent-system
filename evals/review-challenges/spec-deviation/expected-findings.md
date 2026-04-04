# Expected Findings

## REQ-1: CRUD Endpoints
**Expected verdict: COMPLIANT**

All five endpoints exist and return correct status codes:
- `GET /tasks` — returns task list
- `GET /tasks/:id` — returns task or 404
- `POST /tasks` — returns 201 with created task
- `PUT /tasks/:id` — returns updated task or 404
- `DELETE /tasks/:id` — returns 204 or 404

This is the control requirement. A reviewer flagging this as non-compliant is a false positive.

## REQ-2: Task Fields
**Expected verdict: NON-COMPLIANT**

The `priority` field is entirely absent from the implementation:
- `db.js` `createTask()` does not accept or store `priority`
- `routes.js` `POST /tasks` does not extract `priority` from the request body
- `routes.js` `PUT /tasks/:id` does not accept `priority` in updates
- No validation for the `priority` enum values (`low`, `medium`, `high`)
- The default value of `medium` specified in the spec is never applied

**Evidence locations:**
- `db.js` line ~13: `createTask` destructures `{ title, description, status }` — no `priority`
- `routes.js` line ~35: POST handler destructures `{ title, description, status }` — no `priority`
- `routes.js` line ~56: PUT handler destructures `{ title, description, status }` — no `priority`

## REQ-3: Filtering
**Expected verdict: PARTIAL**

Status filtering works correctly. Priority filtering is not implemented.

- `GET /tasks` reads `status` from query params and filters tasks
- `priority` query param is never read or used
- The spec requires both filters and states they can be combined

**Evidence locations:**
- `routes.js` line ~13: only `status` is destructured from `req.query`
- No code references `req.query.priority`

## REQ-4: Status Transitions
**Expected verdict: NON-COMPLIANT**

No transition validation exists. The PUT handler accepts any valid status value without checking the current status or enforcing the `todo -> in-progress -> done` progression.

- A task in `done` can be moved back to `todo`
- A task in `todo` can skip directly to `done`
- No `422 Unprocessable Entity` response is ever returned

This is the highest-severity finding because it violates a core business rule.

**Evidence locations:**
- `routes.js` line ~72: status is set directly with `updates.status = status` after only validating it's a member of the enum — no check against `existing.status`

## REQ-5: Delete Guard
**Expected verdict: NON-COMPLIANT**

The DELETE handler does not check the task's status before deleting. In-progress tasks are deleted the same as any other task. No `409 Conflict` response is ever returned.

**Evidence locations:**
- `routes.js` line ~83: after the 404 check, the handler immediately calls `db.deleteTask()` with no status check

## Summary

| Requirement | Expected Verdict |
|-------------|-----------------|
| REQ-1 | COMPLIANT |
| REQ-2 | NON-COMPLIANT |
| REQ-3 | PARTIAL |
| REQ-4 | NON-COMPLIANT |
| REQ-5 | NON-COMPLIANT |

**Totals: 1 compliant, 1 partial, 3 non-compliant**
