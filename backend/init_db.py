import sqlite3
import os

DB_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "mathcanvas.db"))

def init_db():
    print(f"Initializing SQLite database at: {DB_PATH}")
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Configure WAL mode and Foreign Keys
    cursor.execute("PRAGMA journal_mode = WAL;")
    cursor.execute("PRAGMA foreign_keys = ON;")
    cursor.execute("PRAGMA synchronous = NORMAL;")
    cursor.execute("PRAGMA cache_size = 2000;")
    
    # Schema Version Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS schema_version (
        version     INTEGER NOT NULL,
        applied_at  INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
        description TEXT
    );
    ''')
    cursor.execute("INSERT INTO schema_version (version, description) VALUES (1, 'Initial schema');")
    
    # Notebooks Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS notebooks (
        id          TEXT PRIMARY KEY NOT NULL,
        name        TEXT NOT NULL DEFAULT 'Untitled Notebook',
        created_at  INTEGER NOT NULL,
        updated_at  INTEGER NOT NULL,
        viewport_x  REAL NOT NULL DEFAULT 0.0,
        viewport_y  REAL NOT NULL DEFAULT 0.0,
        zoom_level  REAL NOT NULL DEFAULT 1.0
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_notebooks_updated_at ON notebooks(updated_at DESC);")
    
    # Strokes Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS strokes (
        id            TEXT PRIMARY KEY NOT NULL,
        notebook_id   TEXT NOT NULL,
        points_json   TEXT NOT NULL,
        color         TEXT NOT NULL DEFAULT '#000000',
        stroke_width  REAL NOT NULL DEFAULT 2.0,
        created_at    INTEGER NOT NULL,
        bbox_min_x    REAL NOT NULL,
        bbox_min_y    REAL NOT NULL,
        bbox_max_x    REAL NOT NULL,
        bbox_max_y    REAL NOT NULL,
        FOREIGN KEY (notebook_id) REFERENCES notebooks(id) ON DELETE CASCADE
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_strokes_notebook_id ON strokes(notebook_id);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_strokes_bbox ON strokes(notebook_id, bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_strokes_created_at ON strokes(notebook_id, created_at);")
    
    # Expressions Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS expressions (
        id                TEXT PRIMARY KEY NOT NULL,
        notebook_id       TEXT NOT NULL,
        raw_latex         TEXT NOT NULL,
        parsed_expression TEXT,
        expression_type   TEXT NOT NULL DEFAULT 'unknown',
        confidence        REAL NOT NULL DEFAULT 0.0,
        bbox_min_x        REAL NOT NULL,
        bbox_min_y        REAL NOT NULL,
        bbox_max_x        REAL NOT NULL,
        bbox_max_y        REAL NOT NULL,
        created_at        INTEGER NOT NULL,
        updated_at        INTEGER NOT NULL,
        FOREIGN KEY (notebook_id) REFERENCES notebooks(id) ON DELETE CASCADE
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_expressions_notebook_id ON expressions(notebook_id);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_expressions_type ON expressions(notebook_id, expression_type);")
    
    # Results Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS results (
        id             TEXT PRIMARY KEY NOT NULL,
        expression_id  TEXT NOT NULL UNIQUE,
        result_type    TEXT NOT NULL,
        value          TEXT NOT NULL,
        latex          TEXT NOT NULL,
        numeric_value  REAL,
        computed_at    INTEGER NOT NULL,
        FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_results_expression_id ON results(expression_id);")
    
    # Expression Strokes Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS expression_strokes (
        expression_id  TEXT NOT NULL,
        stroke_id      TEXT NOT NULL,
        PRIMARY KEY (expression_id, stroke_id),
        FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE,
        FOREIGN KEY (stroke_id) REFERENCES strokes(id) ON DELETE CASCADE
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_expression_strokes_stroke ON expression_strokes(stroke_id);")
    
    # Graphs Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS graphs (
        id              TEXT PRIMARY KEY NOT NULL,
        expression_id   TEXT NOT NULL,
        graph_data_json TEXT NOT NULL,
        variable        TEXT NOT NULL DEFAULT 'x',
        x_range_min     REAL NOT NULL DEFAULT -10.0,
        x_range_max     REAL NOT NULL DEFAULT 10.0,
        num_points      INTEGER NOT NULL DEFAULT 500,
        generated_at    INTEGER NOT NULL,
        FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_graphs_expression_id ON graphs(expression_id);")
    
    # Variables Table
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS variables (
        id             TEXT PRIMARY KEY NOT NULL,
        notebook_id    TEXT NOT NULL,
        name           TEXT NOT NULL,
        value          TEXT NOT NULL,
        expression_id  TEXT,
        updated_at     INTEGER NOT NULL,
        FOREIGN KEY (notebook_id) REFERENCES notebooks(id) ON DELETE CASCADE,
        FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE SET NULL,
        UNIQUE(notebook_id, name)
    );
    ''')
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_variables_notebook_id ON variables(notebook_id);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_variables_name ON variables(notebook_id, name);")
    
    conn.commit()
    conn.close()
    print("Database initialization complete.")

if __name__ == "__main__":
    init_db()
