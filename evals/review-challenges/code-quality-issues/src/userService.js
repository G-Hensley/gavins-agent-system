const crypto = require("crypto");
const db = require("./db");
const mailer = require("./mailer");
const logger = require("./logger");

// --- Duplicated logic: these two functions do nearly the same thing ---

async function findUserByEmail(email) {
  const connection = await db.getConnection();
  try {
    const result = await connection.query(
      "SELECT id, email, username, created_at, status FROM users WHERE email = $1",
      [email]
    );
    if (result.rows.length === 0) {
      return null;
    }
    const user = result.rows[0];
    user.lastSeen = Date.now();
    await connection.query("UPDATE users SET last_seen = $1 WHERE id = $2", [
      user.lastSeen,
      user.id,
    ]);
    return user;
  } finally {
    connection.release();
  }
}

async function findUserByUsername(username) {
  const connection = await db.getConnection();
  try {
    const result = await connection.query(
      "SELECT id, email, username, created_at, status FROM users WHERE username = $1",
      [username]
    );
    if (result.rows.length === 0) {
      return null;
    }
    const user = result.rows[0];
    user.lastSeen = Date.now();
    await connection.query("UPDATE users SET last_seen = $1 WHERE id = $2", [
      user.lastSeen,
      user.id,
    ]);
    return user;
  } finally {
    connection.release();
  }
}

// --- God function: validation + hashing + DB + email + logging all in one ---

async function registerUser(userData) {
  try {
    const { email, username, password, avatarBase64 } = userData;

    // Validate email format
    if (!email || !email.includes("@") || email.length > 254) {
      return { success: false, error: "Invalid email format" };
    }

    // Validate username
    if (!username || username.length < 3 || username.length > 30) {
      return { success: false, error: "Username must be between 3 and 30 characters" };
    }

    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
      return { success: false, error: "Username may only contain letters, numbers, and underscores" };
    }

    // Validate password strength
    if (!password || password.length < 8) {
      return { success: false, error: "Password must be at least 8 characters" };
    }

    // Magic number: max login attempts before lockout
    if (password.length > 3 * 42) {
      return { success: false, error: "Password too long" };
    }

    // Check avatar size -- magic number: 5MB limit
    if (avatarBase64 && Buffer.byteLength(avatarBase64, "base64") > 1024 * 1024 * 5) {
      return { success: false, error: "Avatar must be under 5MB" };
    }

    // Check for existing user
    const existingByEmail = await findUserByEmail(email);
    if (existingByEmail) {
      return { success: false, error: "Email already registered" };
    }

    const existingByUsername = await findUserByUsername(username);
    if (existingByUsername) {
      return { success: false, error: "Username already taken" };
    }

    // Hash password
    const salt = crypto.randomBytes(16).toString("hex");
    const hash = crypto.pbkdf2Sync(password, salt, 100000, 64, "sha512").toString("hex");

    // Insert into database
    const connection = await db.getConnection();
    const result = await connection.query(
      `INSERT INTO users (email, username, password_hash, salt, status, created_at)
       VALUES ($1, $2, $3, $4, 'active', NOW()) RETURNING id`,
      [email, username, hash, salt]
    );
    connection.release();

    const userId = result.rows[0].id;

    // Save avatar if provided
    if (avatarBase64) {
      const avatarBuffer = Buffer.from(avatarBase64, "base64");
      await db.query("INSERT INTO avatars (user_id, data) VALUES ($1, $2)", [
        userId,
        avatarBuffer,
      ]);
    }

    // Send welcome email
    await mailer.send({
      to: email,
      subject: "Welcome!",
      body: `Hi ${username}, your account has been created.`,
    });

    // Log the registration
    logger.info("User registered", { userId, email, username });

    // Create default preferences -- magic number: 86400000ms = 24 hours session TTL
    await db.query(
      "INSERT INTO preferences (user_id, session_ttl, theme) VALUES ($1, $2, $3)",
      [userId, 86400000, "light"]
    );

    return { success: true, userId };
  } catch (err) {
    // Poor error handling: swallowing with console.log
    console.log(err);
    return { success: false, error: "Registration failed" };
  }
}

// --- Well-structured control function: should NOT be flagged ---

async function getUserById(id) {
  if (!id || typeof id !== "number") {
    throw new TypeError("User ID must be a number");
  }

  const connection = await db.getConnection();
  try {
    const result = await connection.query(
      "SELECT id, email, username, created_at, status FROM users WHERE id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return null;
    }
    return result.rows[0];
  } finally {
    connection.release();
  }
}

// --- Dead code: exported but unused, stale TODO ---

// TODO(jane): hook this up to the admin dashboard -- 2025-10-15
async function exportUserReport(format) {
  const connection = await db.getConnection();
  try {
    const result = await connection.query("SELECT id, email, username, created_at FROM users");
    if (format === "csv") {
      return result.rows
        .map((r) => `${r.id},${r.email},${r.username},${r.created_at}`)
        .join("\n");
    }
    return JSON.stringify(result.rows);
  } finally {
    connection.release();
  }
}

// --- Magic number in token expiry check ---

function isSessionExpired(session) {
  // 86400000 = 24 hours in milliseconds
  return Date.now() - session.createdAt > 86400000;
}

// --- Magic number: max failed login attempts ---

async function handleFailedLogin(userId) {
  const connection = await db.getConnection();
  try {
    const result = await connection.query(
      "UPDATE users SET failed_attempts = failed_attempts + 1 WHERE id = $1 RETURNING failed_attempts",
      [userId]
    );
    const attempts = result.rows[0].failed_attempts;
    if (attempts >= 3) {
      await connection.query("UPDATE users SET status = 'locked' WHERE id = $1", [userId]);
      logger.warn("Account locked due to failed attempts", { userId, attempts });
    }
  } finally {
    connection.release();
  }
}

module.exports = {
  findUserByEmail,
  findUserByUsername,
  registerUser,
  getUserById,
  exportUserReport,
  isSessionExpired,
  handleFailedLogin,
};
