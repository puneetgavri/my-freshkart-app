"""FreshCart: a tiny online shop, written with security mistakes on purpose.

Only for training. Never use this code in real life.
"""
import sqlite3

from flask import Flask, request

app = Flask(__name__)
DB = "shop.db"


def setup_db():
    """Create a small products table. One product is hidden (staff only)."""
    conn = sqlite3.connect(DB)
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("CREATE TABLE products (name TEXT, price REAL, hidden INTEGER)")
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?)",
        [
            ("apple", 0.50, 0),
            ("banana", 0.25, 0),
            ("staff-discount-code-90-percent-off", 0.00, 1),
        ],
    )
    conn.commit()
    conn.close()


@app.route("/product")
def product():
    name = request.args.get("name", "")
    conn = sqlite3.connect(DB)
    # PROBLEM: the user's text is glued straight into the SQL query.
    rows = conn.execute(
        f"SELECT name, price FROM products WHERE hidden = 0 AND name = '{name}'"
    ).fetchall()
    conn.close()
    return {"products": rows}


if __name__ == "__main__":
    setup_db()
    # PROBLEM: debug mode must never be on in production.
    app.run(port=5000, debug=True)
