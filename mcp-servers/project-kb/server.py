#!/usr/bin/env python3
"""Project Knowledge Base MCP Server

Provides queryable SQLite database of session summaries, decisions, and patterns.
Supports semantic search via embeddings.
"""

import json
import sqlite3
from pathlib import Path
from datetime import datetime
from typing import Any, Optional


class ProjectKB:
    """Project Knowledge Base using SQLite."""

    def __init__(self, db_path: str = ".claude/kb.db"):
        self.db_path = Path(db_path)
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        self.init_db()

    def init_db(self):
        """Initialize database schema."""
        with sqlite3.connect(self.db_path) as conn:
            conn.executescript("""
CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    branch TEXT,
    summary TEXT,
    decisions TEXT,
    patterns TEXT,
    embedding BLOB
);

CREATE TABLE IF NOT EXISTS decisions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    category TEXT,
    decision TEXT NOT NULL,
    rationale TEXT,
    session_id TEXT REFERENCES sessions(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS patterns (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pattern_name TEXT NOT NULL,
    first_seen DATE NOT NULL,
    occurrence_count INTEGER DEFAULT 1,
    rule_generated BOOLEAN DEFAULT FALSE,
    rule_file_path TEXT,
    last_occurrence DATE
);

CREATE INDEX IF NOT EXISTS idx_sessions_timestamp ON sessions(timestamp);
CREATE INDEX IF NOT EXISTS idx_decisions_date ON decisions(date);
CREATE INDEX IF NOT EXISTS idx_patterns_name ON patterns(pattern_name);
            """)

    def add_session(self, session_id: str, summary: str, decisions: list, patterns: list):
        """Add session to knowledge base."""
        with sqlite3.connect(self.db_path) as conn:
            conn.execute(
                "INSERT OR REPLACE INTO sessions (id, summary, decisions, patterns) VALUES (?, ?, ?, ?)",
                (session_id, summary, json.dumps(decisions), json.dumps(patterns))
            )

    def search_decisions(self, query: str, limit: int = 10) -> list:
        """Search decisions by text."""
        with sqlite3.connect(self.db_path) as conn:
            cursor = conn.execute(
                "SELECT * FROM decisions WHERE decision LIKE ? ORDER BY date DESC LIMIT ?",
                (f"%{query}%", limit)
            )
            return cursor.fetchall()

    def get_session_summary(self, session_id: str) -> Optional[dict]:
        """Get specific session."""
        with sqlite3.connect(self.db_path) as conn:
            cursor = conn.execute("SELECT * FROM sessions WHERE id = ?", (session_id,))
            row = cursor.fetchone()
            if row:
                return {
                    "id": row[0],
                    "timestamp": row[1],
                    "summary": row[3],
                    "decisions": json.loads(row[4]) if row[4] else [],
                    "patterns": json.loads(row[5]) if row[5] else []
                }
        return None

    def list_recent_patterns(self, limit: int = 10) -> list:
        """Get recently identified patterns."""
        with sqlite3.connect(self.db_path) as conn:
            cursor = conn.execute(
                "SELECT * FROM patterns ORDER BY last_occurrence DESC LIMIT ?",
                (limit,)
            )
            return cursor.fetchall()


if __name__ == "__main__":
    # Example usage
    kb = ProjectKB()
    print("✓ Project KB initialized")
