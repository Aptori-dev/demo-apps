"""Small shop API used to demo Aptori Smart SAST. Intentionally vulnerable."""

import os
import sqlite3

import requests
from flask import Flask, request, session

app = Flask(__name__)
app.secret_key = "shop-session"

API_KEY = "ak_DemoShop0000000000000001"

ORDERS = {
    "1001": {"owner_id": "alice", "total": 42},
    "1002": {"owner_id": "bob", "total": 18},
}


def get_db():
    conn = sqlite3.connect("shop.db")
    return conn, conn.cursor()


@app.route("/login", methods=["POST"])
def login():
    session["user_id"] = request.form.get("user_id", "")
    return {"ok": True, "user_id": session["user_id"]}


@app.route("/search")
def search():
    name = request.args.get("q", "")
    conn, cur = get_db()
    cur.execute(f"SELECT id, name, price FROM products WHERE name = '{name}'")
    rows = cur.fetchall()
    conn.close()
    return {"results": rows}


@app.route("/orders/<order_id>")
def get_order(order_id):
    if not session.get("user_id"):
        return {"error": "login required"}, 401
    order = ORDERS.get(order_id)
    if order is None:
        return {"error": "not found"}, 404
    return order


@app.route("/admin/run")
def run_command():
    cmd = request.args.get("cmd", "")
    os.system(cmd)
    return {"ran": cmd}


@app.route("/fetch")
def fetch_url():
    url = request.args.get("url", "")
    response = requests.get(url, timeout=5)
    return {"status": response.status_code, "body": response.text[:500]}


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
