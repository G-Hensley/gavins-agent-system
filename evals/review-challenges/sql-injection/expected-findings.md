# Expected Findings

## Critical: String-Concatenated SQL in Search Endpoint

- **Location**: `GET /api/products/search` (line ~109)
- **Code**: `"SELECT * FROM products WHERE name LIKE '%" + q + "%'"`
- **Issue**: User-supplied query parameter `q` is concatenated directly into a SQL string. An attacker can terminate the LIKE clause and inject arbitrary SQL.
- **Example payload**: `q=' OR 1=1 --`
- **Fix**: Use parameterized query with `?` placeholder: `db.prepare("SELECT * FROM products WHERE name LIKE ?").all('%' + q + '%')`

## High: Template Literal SQL Injection in Review Endpoint

- **Location**: `POST /api/products/review` (line ~141)
- **Code**: `` VALUES (${productId}, '${reviewerName}', ${rating}, '${comment}') ``
- **Issue**: All four user-supplied fields from the request body are interpolated into the SQL string via template literals. This is functionally identical to string concatenation. The `reviewerName` and `comment` fields are especially dangerous since they're string-typed and can break out of the single quotes.
- **Example payload**: `reviewerName: "admin'; DROP TABLE reviews; --"`
- **Fix**: Use parameterized query: `db.prepare("INSERT INTO reviews (product_id, reviewer_name, rating, comment) VALUES (?, ?, ?, ?)").run(productId, reviewerName, rating, comment)`
- **Note**: The rating validation (1-5 range check) provides partial protection for the `rating` field but does NOT protect `productId`, `reviewerName`, or `comment`.

## Medium: ORDER BY Injection in Product Listing

- **Location**: `GET /api/products` (line ~67)
- **Code**: `` query += ` ORDER BY ${sort}` ``
- **Issue**: The `sort` query parameter is interpolated directly into the ORDER BY clause. While the `category` parameter is correctly parameterized (using `?`), the sort column is not validated. Column names cannot be parameterized in SQL, but the value must be validated against an allowlist. An attacker can use this to extract data via boolean-based or error-based blind injection.
- **Example payload**: `sort=CASE WHEN (SELECT length(password) FROM users)>5 THEN name ELSE price END`
- **Fix**: Validate against an allowlist of permitted column names:
  ```js
  const ALLOWED_SORT_COLUMNS = ["name", "price", "category", "created_at"];
  const sortColumn = ALLOWED_SORT_COLUMNS.includes(sort) ? sort : "name";
  query += ` ORDER BY ${sortColumn}`;
  ```

## False Positive Check: Clean Endpoint

- **Location**: `GET /api/products/:id` (line ~80)
- **Code**: `db.prepare("SELECT * FROM products WHERE id = ?").get(req.params.id)`
- **Status**: Properly parameterized. Both queries in this handler use `?` placeholders.
- **Expected result**: The reviewer should NOT flag this endpoint. If it does, that counts as a false positive (-2 points).
