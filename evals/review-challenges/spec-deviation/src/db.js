const { randomUUID } = require("crypto");

const tasks = new Map();

function getAllTasks() {
  return Array.from(tasks.values());
}

function getTaskById(id) {
  return tasks.get(id) || null;
}

function createTask({ title, description = "", status = "todo" }) {
  const now = new Date().toISOString();
  const task = {
    id: randomUUID(),
    title,
    description,
    status,
    createdAt: now,
    updatedAt: now,
  };
  tasks.set(task.id, task);
  return task;
}

function updateTask(id, updates) {
  const task = tasks.get(id);
  if (!task) return null;

  const updated = {
    ...task,
    ...updates,
    id: task.id,
    createdAt: task.createdAt,
    updatedAt: new Date().toISOString(),
  };
  tasks.set(id, updated);
  return updated;
}

function deleteTask(id) {
  if (!tasks.has(id)) return false;
  tasks.delete(id);
  return true;
}

function clear() {
  tasks.clear();
}

module.exports = {
  getAllTasks,
  getTaskById,
  createTask,
  updateTask,
  deleteTask,
  clear,
};
