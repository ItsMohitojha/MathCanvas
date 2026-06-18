import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  static const int currentVersion = 1;

  static final Map<int, List<String>> migrations = {
    1: [
      '''
      CREATE TABLE schema_version (
          version     INTEGER NOT NULL,
          applied_at  INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
          description TEXT
      );
      ''',
      "INSERT INTO schema_version (version, description) VALUES (1, 'Initial schema');",
      '''
      CREATE TABLE notebooks (
          id          TEXT PRIMARY KEY NOT NULL,
          name        TEXT NOT NULL DEFAULT 'Untitled Notebook',
          created_at  INTEGER NOT NULL,
          updated_at  INTEGER NOT NULL,
          viewport_x  REAL NOT NULL DEFAULT 0.0,
          viewport_y  REAL NOT NULL DEFAULT 0.0,
          zoom_level  REAL NOT NULL DEFAULT 1.0
      );
      ''',
      "CREATE INDEX idx_notebooks_updated_at ON notebooks(updated_at DESC);",
      '''
      CREATE TABLE strokes (
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
      ''',
      "CREATE INDEX idx_strokes_notebook_id ON strokes(notebook_id);",
      "CREATE INDEX idx_strokes_bbox ON strokes(notebook_id, bbox_min_x, bbox_min_y, bbox_max_x, bbox_max_y);",
      "CREATE INDEX idx_strokes_created_at ON strokes(notebook_id, created_at);",
      '''
      CREATE TABLE expressions (
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
      ''',
      "CREATE INDEX idx_expressions_notebook_id ON expressions(notebook_id);",
      "CREATE INDEX idx_expressions_type ON expressions(notebook_id, expression_type);",
      '''
      CREATE TABLE results (
          id             TEXT PRIMARY KEY NOT NULL,
          expression_id  TEXT NOT NULL UNIQUE,
          result_type    TEXT NOT NULL,
          value          TEXT NOT NULL,
          latex          TEXT NOT NULL,
          numeric_value  REAL,
          computed_at    INTEGER NOT NULL,
          FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE
      );
      ''',
      "CREATE INDEX idx_results_expression_id ON results(expression_id);",
      '''
      CREATE TABLE expression_strokes (
          expression_id  TEXT NOT NULL,
          stroke_id      TEXT NOT NULL,
          PRIMARY KEY (expression_id, stroke_id),
          FOREIGN KEY (expression_id) REFERENCES expressions(id) ON DELETE CASCADE,
          FOREIGN KEY (stroke_id) REFERENCES strokes(id) ON DELETE CASCADE
      );
      ''',
      "CREATE INDEX idx_expression_strokes_stroke ON expression_strokes(stroke_id);",
      '''
      CREATE TABLE graphs (
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
      ''',
      "CREATE INDEX idx_graphs_expression_id ON graphs(expression_id);",
      '''
      CREATE TABLE variables (
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
      ''',
      "CREATE INDEX idx_variables_notebook_id ON variables(notebook_id);",
      "CREATE INDEX idx_variables_name ON variables(notebook_id, name);"
    ]
  };

  static Future<void> migrate(Database db, int oldVersion, int newVersion) async {
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      final statements = migrations[version];
      if (statements != null) {
        for (final sql in statements) {
          await db.execute(sql);
        }
      }
    }
  }
}
