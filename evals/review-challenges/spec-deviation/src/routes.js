const express = require("express");
const db = require("./db");

const app = express();
app.use(express.json());

// REQ-1: GET /tasks — list all tasks with optional filtering
app.get("/tasks", (req, res) => {
  let tasks = db.getAllTasks();

  // REQ-3 (PARTIAL): status filter works, priority filter is missing
  const { status } = req.query;
  if (status) {
    tasks = tasks.filter((t) => t.status === status);
  }

  res.json(tasks);
});

// REQ-1: GET /tasks/:id — get single task
app.get("/tasks/:id", (req, res) => {
  const task = db.getTaskById(req.params.id);
  if (!task) {
    return res.status(404).json({ error: "Task not found" });
  }
  res.json(task);
});

// REQ-1: POST /tasks — create a new task
app.post("/tasks", (req, res) => {
  const { title, description, status } = req.body;

  if (!title || typeof title !== "string" || title.trim().length === 0) {
    return res.status(400).json({ error: "Title is required" });
  }

  const validStatuses = ["todo", "in-progress", "done"];
  if (status && !validStatuses.includes(status)) {
    return res.status(400).json({ error: `Invalid status. Must be one of: ${validStatuses.join(", ")}` });
  }

  // REQ-2 (MISSING): priority field is not accepted or stored
  const task = db.createTask({ title: title.trim(), description, status });
  res.status(201).json(task);
});

// REQ-1: PUT /tasks/:id — update an existing task
app.put("/tasks/:id", (req, res) => {
  const existing = db.getTaskById(req.params.id);
  if (!existing) {
    return res.status(404).json({ error: "Task not found" });
  }

  const { title, description, status } = req.body;
  const updates = {};

  if (title !== undefined) {
    if (typeof title !== "string" || title.trim().length === 0) {
      return res.status(400).json({ error: "Title must be a non-empty string" });
    }
    updates.title = title.trim();
  }

  if (description !== undefined) {
    updates.description = description;
  }

  if (status !== undefined) {
    const validStatuses = ["todo", "in-progress", "done"];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ error: `Invalid status. Must be one of: ${validStatuses.join(", ")}` });
    }
    // REQ-4 (VIOLATED): no transition validation — any status accepted
    updates.status = status;
  }

  // REQ-2 (MISSING): priority field is not accepted or stored in updates
  const updated = db.updateTask(req.params.id, updates);
  res.json(updated);
});

// REQ-1: DELETE /tasks/:id — delete a task
app.delete("/tasks/:id", (req, res) => {
  const task = db.getTaskById(req.params.id);
  if (!task) {
    return res.status(404).json({ error: "Task not found" });
  }

  // REQ-5 (MISSING): no guard against deleting in-progress tasks
  db.deleteTask(req.params.id);
  res.status(204).send();
});

const PORT = process.env.PORT || 3000;

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Task Manager API running on port ${PORT}`);
  });
}

module.exports = app;
