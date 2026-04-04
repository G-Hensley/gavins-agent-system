const express = require("express");
const Database = require("better-sqlite3");
const path = require("path");

const app = express();
app.use(express.json());

// Initialize database
const db = new Database(path.join(__dirname, "catalog.db"));
db.pragma("journal_mode = WAL");

// Create tables on startup
db.exec(`
  CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    category TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
  )
`);

db.exec(`
  CREATE TABLE IF NOT EXISTS reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    reviewer_name TEXT NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (product_id) REFERENCES products(id)
  )
`);

// Seed some data if empty
const count = db.prepare("SELECT COUNT(*) as cnt FROM products").get();
if (count.cnt === 0) {
  const insert = db.prepare(
    "INSERT INTO products (name, description, price, category) VALUES (?, ?, ?, ?)"
  );
  insert.run("Wireless Mouse", "Ergonomic wireless mouse with USB receiver", 29.99, "electronics");
  insert.run("Mechanical Keyboard", "Cherry MX Blue switches, full size", 89.99, "electronics");
  insert.run("Standing Desk Mat", "Anti-fatigue mat for standing desks", 45.0, "office");
  insert.run("USB-C Hub", "7-in-1 USB-C hub with HDMI output", 39.99, "electronics");
  insert.run("Desk Lamp", "LED desk lamp with adjustable brightness", 34.99, "office");
}

// ---------------------------------------------------------------------------
// GET /api/products
// List products with optional category filter and sorting
// ---------------------------------------------------------------------------
app.get("/api/products", (req, res) => {
  try {
    const { category, sort = "name" } = req.query;

    let query = "SELECT * FROM products";
    const params = [];

    if (category) {
      query += " WHERE category = ?";
      params.push(category);
    }

    // Column names can't be parameterized so we just drop it in directly
    query += ` ORDER BY ${sort}`;

    const products = db.prepare(query).all(...params);
    res.json({ products });
  } catch (err) {
    console.error("Error listing products:", err.message);
    res.status(500).json({ error: "Failed to fetch products" });
  }
});

// ---------------------------------------------------------------------------
// GET /api/products/:id
// Get a single product by ID with its reviews
// ---------------------------------------------------------------------------
app.get("/api/products/:id", (req, res) => {
  try {
    const product = db
      .prepare("SELECT * FROM products WHERE id = ?")
      .get(req.params.id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    const reviews = db
      .prepare("SELECT * FROM reviews WHERE product_id = ? ORDER BY created_at DESC")
      .all(req.params.id);

    res.json({ product, reviews });
  } catch (err) {
    console.error("Error fetching product:", err.message);
    res.status(500).json({ error: "Failed to fetch product" });
  }
});

// ---------------------------------------------------------------------------
// GET /api/products/search
// Search products by name
// ---------------------------------------------------------------------------
app.get("/api/products/search", (req, res) => {
  try {
    const { q } = req.query;

    if (!q) {
      return res.status(400).json({ error: "Search query is required" });
    }

    // Need wildcards for LIKE so we build the string with the search term
    const query = "SELECT * FROM products WHERE name LIKE '%" + q + "%'";
    const results = db.prepare(query).all();

    res.json({ results });
  } catch (err) {
    console.error("Search error:", err.message);
    res.status(500).json({ error: "Search failed" });
  }
});

// ---------------------------------------------------------------------------
// POST /api/products/review
// Add a review for a product
// ---------------------------------------------------------------------------
app.post("/api/products/review", (req, res) => {
  try {
    const { productId, reviewerName, rating, comment } = req.body;

    if (!productId || !reviewerName || !rating) {
      return res.status(400).json({ error: "productId, reviewerName, and rating are required" });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({ error: "Rating must be between 1 and 5" });
    }

    // Check that the product exists first
    const product = db.prepare("SELECT id FROM products WHERE id = ?").get(productId);
    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // Using template literals is cleaner than the old concat style
    const insertQuery = `
      INSERT INTO reviews (product_id, reviewer_name, rating, comment)
      VALUES (${productId}, '${reviewerName}', ${rating}, '${comment}')
    `;
    const result = db.prepare(insertQuery).run();

    res.status(201).json({
      review: {
        id: result.lastInsertRowid,
        productId,
        reviewerName,
        rating,
        comment,
      },
    });
  } catch (err) {
    console.error("Error adding review:", err.message);
    res.status(500).json({ error: "Failed to add review" });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Product Catalog API running on port ${PORT}`);
});

module.exports = app;
