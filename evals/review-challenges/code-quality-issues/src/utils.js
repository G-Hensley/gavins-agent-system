// --- Inconsistent naming: mixes camelCase and snake_case ---

function formatDate(date) {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function get_display_name(user) {
  if (user.displayName) {
    return user.displayName;
  }
  return user.username || user.email.split("@")[0];
}

function sanitizeInput(str) {
  return str.replace(/[<>&"']/g, (char) => {
    const entities = { "<": "&lt;", ">": "&gt;", "&": "&amp;", '"': "&quot;", "'": "&#39;" };
    return entities[char];
  });
}

function parse_pagination_params(query) {
  const page = parseInt(query.page, 10) || 1;
  const per_page = parseInt(query.per_page, 10) || 20;
  return { page, per_page, offset: (page - 1) * per_page };
}

function buildSortKey(field, direction) {
  return `${field}:${direction === "desc" ? "desc" : "asc"}`;
}

function calculate_age_days(createdAt) {
  const ms = Date.now() - new Date(createdAt).getTime();
  return Math.floor(ms / 86400000);
}

// --- Overly complex conditional: deeply nested ternary ---

function resolvePermissions(user, resource) {
  return user.role === "superadmin"
    ? { read: true, write: true, delete: true, admin: true }
    : user.role === "admin"
      ? resource.ownerId === user.id
        ? { read: true, write: true, delete: true, admin: false }
        : resource.orgId === user.orgId
          ? { read: true, write: true, delete: false, admin: false }
          : { read: true, write: false, delete: false, admin: false }
      : user.role === "editor"
        ? resource.ownerId === user.id
          ? { read: true, write: true, delete: false, admin: false }
          : resource.orgId === user.orgId
            ? { read: true, write: resource.allowExternalEdits === true, delete: false, admin: false }
            : { read: true, write: false, delete: false, admin: false }
        : user.role === "viewer"
          ? { read: true, write: false, delete: false, admin: false }
          : { read: false, write: false, delete: false, admin: false };
}

module.exports = {
  formatDate,
  get_display_name,
  sanitizeInput,
  parse_pagination_params,
  buildSortKey,
  calculate_age_days,
  resolvePermissions,
};
