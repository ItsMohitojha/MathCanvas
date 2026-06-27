# MathCanvas — Repository Structure and Governance

**Version:** 1.0
**Status:** Approved
**Last Updated:** 2026-06-12
**Owner:** Architecture
**Audience:** All AI Coding Agents
**Enforcement:** Mandatory
**References:** [TRD.md](file:///d:/MathCanvas/TRD.md), [Rules.md](file:///d:/MathCanvas/Rules.md)

---

## 1. Repository Philosophy

### 1.1 Core Principles

1. **Predictability:** Any developer (human or AI) should be able to find any file by its purpose, without searching.
2. **Modularity:** Each feature is self-contained. Adding, removing, or modifying a feature does not require touching unrelated code.
3. **Consistency:** The same patterns are used everywhere. Once you understand one feature module, you understand all of them.
4. **Discoverability:** The folder structure itself is documentation. Names communicate purpose.
5. **Governance:** Every file has a home. No orphan files. No ambiguity about where new code belongs.

### 1.2 Anti-Patterns

The following structural patterns are **explicitly forbidden**:

| Anti-Pattern | Problem | Correct Approach |
|-------------|---------|-----------------|
| `utils/` catch-all folder | Becomes a dumping ground | Put utilities in the feature that uses them, or `core/` if truly shared |
| `helpers/` folder | Same as utils | Same as above |
| `misc/` or `common/` folder | Undefined scope | Use `core/` for cross-cutting, `shared/` for shared widgets |
| `models/` at root level | Unclear ownership | Models belong inside their feature's `domain/models/` |
| Deep nesting (>4 levels) | Hard to navigate | Flatten where possible |
| Circular feature imports | Coupling | Use `core/` or Riverpod for cross-feature communication |

---

## 2. Repository Layout

### 2.1 Top-Level Structure

```
MathCanvas/                          # Repository root
├── frontend/                        # Flutter application (Dart)
├── backend/                         # FastAPI application (Python)
├── docs/                            # Project documentation
├── .agent/                          # Agent-specific skills & rules
│   └── skills/                      # Custom local agent skills
│       └── find-docs/               # Documentation lookup skill
├── .github/                         # GitHub configuration
│   └── workflows/                   # CI/CD workflows
├── .gitignore                       # Git ignore rules
└── README.md                        # Project overview and setup guide
```

### 2.2 Documentation Structure

```
docs/
├── PRD.md                           # Product Requirements Document
├── TRD.md                           # Technical Requirements Document
├── AppFlow.md                       # Application Flow and UX
├── Schema.md                        # Database Schema
├── ImplementationPlan.md            # Implementation Plan
├── Tracker.md                       # Project Tracker
├── Rules.md                         # Agent Rules and Standards
├── UI_UX.md                         # Design System
└── Structure.md                     # This file
```

> **Note:** During initial development, documentation files may reside at the repository root (`MathCanvas/`). Once the `docs/` directory is established in Phase 0, all documentation should be moved there. Both locations are valid references until migration is complete.

---

## 3. Frontend Structure

### 3.1 Complete Flutter Project Structure

```
frontend/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app/                               # App-level configuration
│   │   ├── app.dart                       # MaterialApp / ProviderScope wrapper
│   │   ├── router/
│   │   │   └── app_router.dart            # GoRouter configuration
│   │   └── theme/
│   │       ├── app_theme.dart             # ThemeData (light + dark)
│   │       ├── app_colors.dart            # Color tokens
│   │       ├── app_typography.dart        # Text styles
│   │       ├── app_spacing.dart           # Spacing constants
│   │       ├── app_borders.dart           # Border radius tokens
│   │       ├── app_shadows.dart           # Shadow tokens
│   │       └── app_icons.dart             # Icon size tokens
│   ├── core/                              # Cross-cutting shared code
│   │   ├── constants/
│   │   │   ├── app_constants.dart         # App-wide constants
│   │   │   └── api_constants.dart         # API URLs, ports, timeouts
│   │   ├── errors/
│   │   │   ├── app_exception.dart         # Base exception class
│   │   │   └── error_handler.dart         # Global error handler
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart    # BuildContext extensions
│   │   │   ├── string_extensions.dart     # String utilities
│   │   │   └── datetime_extensions.dart   # DateTime formatting
│   │   ├── logging/
│   │   │   └── app_logger.dart            # Logger configuration
│   │   ├── network/
│   │   │   ├── api_client.dart            # Dio HTTP client setup
│   │   │   ├── api_response.dart          # Common response envelope model
│   │   │   └── api_error.dart             # API error model
│   │   └── utils/
│   │       ├── uuid_generator.dart        # UUID generation utility
│   │       └── debouncer.dart             # Debounce utility for recognition timer
│   ├── features/                          # Feature modules
│   │   ├── canvas/                        # Canvas & stroke feature
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── stroke_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── stroke_entity.dart
│   │   │   │   └── repositories/
│   │   │   │       └── stroke_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   ├── stroke.dart
│   │   │   │   │   ├── stroke_point.dart
│   │   │   │   │   └── canvas_state.dart
│   │   │   │   └── repositories/
│   │   │   │       └── stroke_repository.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── canvas_state_provider.dart
│   │   │       ├── widgets/
│   │   │       │   ├── canvas_widget.dart
│   │   │       │   ├── canvas_background_painter.dart
│   │   │       │   ├── stroke_painter.dart
│   │   │       │   └── canvas_toolbar.dart
│   │   │       └── screens/
│   │   │           └── canvas_screen.dart
│   │   ├── recognition/                   # Handwriting recognition feature
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── expression_local_datasource.dart
│   │   │   │   │   └── expression_stroke_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── expression_entity.dart
│   │   │   │   │   └── expression_stroke_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── expression_repository_impl.dart
│   │   │   │   └── engines/
│   │   │   │       └── tflite_recognition_engine.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   ├── recognized_expression.dart
│   │   │   │   │   └── recognition_result.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── expression_repository.dart
│   │   │   │   └── engines/
│   │   │   │       └── recognition_engine.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── recognition_state_provider.dart
│   │   │       └── widgets/
│   │   │           ├── recognition_overlay_painter.dart
│   │   │           └── confidence_indicator.dart
│   │   ├── math_engine/                   # Math solving feature
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── result_local_datasource.dart
│   │   │   │   │   └── variable_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── result_entity.dart
│   │   │   │   │   └── variable_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   ├── math_repository_impl.dart
│   │   │   │   │   └── variable_repository_impl.dart
│   │   │   │   └── api/
│   │   │   │       └── math_api_client.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   ├── math_result.dart
│   │   │   │   │   └── variable.dart
│   │   │   │   └── repositories/
│   │   │   │       ├── math_repository.dart
│   │   │   │       └── variable_repository.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── math_state_provider.dart
│   │   │       └── widgets/
│   │   │           └── result_card.dart
│   │   ├── graph/                         # Graph display feature
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── graph_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── graph_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── graph_repository_impl.dart
│   │   │   │   └── api/
│   │   │   │       └── graph_api_client.dart
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   │   └── graph_data.dart
│   │   │   │   └── repositories/
│   │   │   │       └── graph_repository.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── graph_state_provider.dart
│   │   │       └── widgets/
│   │   │           ├── graph_card.dart
│   │   │           └── graph_chart_painter.dart
│   │   └── notebook/                      # Notebook management feature
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── notebook_local_datasource.dart
│   │       │   ├── models/
│   │       │   │   └── notebook_entity.dart
│   │       │   └── repositories/
│   │       │       └── notebook_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── models/
│   │       │   │   └── notebook.dart
│   │       │   └── repositories/
│   │       │       └── notebook_repository.dart
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── notebook_state_provider.dart
│   │           ├── widgets/
│   │           │   ├── notebook_card.dart
│   │           │   ├── notebook_empty_state.dart
│   │           │   ├── rename_dialog.dart
│   │           │   └── delete_confirmation_dialog.dart
│   │           └── screens/
│   │               └── home_screen.dart
│   └── shared/                            # Shared across features
│       ├── database/
│       │   ├── database_provider.dart     # SQLite database singleton provider
│       │   └── database_migrations.dart   # Schema migration runner
│       └── widgets/
│           ├── app_loading_indicator.dart  # Shared loading widget
│           ├── app_error_widget.dart       # Shared error display
│           └── app_snackbar.dart           # Shared snackbar helper
├── test/                                  # Tests (mirrors lib/ structure)
│   ├── unit/
│   │   ├── features/
│   │   │   ├── canvas/
│   │   │   │   ├── domain/
│   │   │   │   │   └── models/
│   │   │   │   │       └── stroke_test.dart
│   │   │   │   └── data/
│   │   │   │       └── repositories/
│   │   │   │           └── stroke_repository_impl_test.dart
│   │   │   ├── recognition/
│   │   │   ├── math_engine/
│   │   │   ├── graph/
│   │   │   └── notebook/
│   │   ├── core/
│   │   └── shared/
│   └── widget/
│       ├── features/
│       │   ├── canvas/
│       │   │   └── presentation/
│       │   │       └── widgets/
│       │   │           └── canvas_widget_test.dart
│       │   ├── notebook/
│       │   │   └── presentation/
│       │   │       ├── screens/
│       │   │       │   └── home_screen_test.dart
│       │   │       └── widgets/
│       │   │           └── notebook_card_test.dart
│       │   └── ...
│       └── shared/
├── integration_test/                       # Integration tests
│   └── app_test.dart
├── assets/                                # Static assets
│   ├── fonts/                             # Font files
│   │   ├── Inter/
│   │   └── StixTwoMath/
│   ├── images/                            # Image assets
│   │   ├── empty_state.svg               # Empty notebook illustration
│   │   └── app_icon.png                  # App icon source
│   └── models/                            # ML model files
│       └── math_symbols.tflite           # TFLite recognition model
├── android/                               # Android platform files
├── ios/                                   # iOS platform files
├── pubspec.yaml                           # Flutter dependencies
├── analysis_options.yaml                  # Dart lint configuration
└── build.yaml                             # Build runner configuration
```

### 3.2 Feature Module Pattern

Every feature module follows the same internal structure:

```
feature_name/
├── data/                              # Implementation layer
│   ├── datasources/                   # Raw data access (SQLite, API)
│   │   └── {name}_local_datasource.dart
│   ├── models/                        # Data transfer objects / entities
│   │   └── {name}_entity.dart
│   ├── repositories/                  # Repository implementations
│   │   └── {name}_repository_impl.dart
│   └── api/                           # API client wrappers (if applicable)
│       └── {name}_api_client.dart
├── domain/                            # Contract/interface layer
│   ├── models/                        # Domain models (freezed)
│   │   └── {name}.dart
│   ├── repositories/                  # Abstract repository interfaces
│   │   └── {name}_repository.dart
│   └── engines/                       # Abstract engine interfaces (if applicable)
│       └── {name}_engine.dart
└── presentation/                      # UI layer
    ├── providers/                     # Riverpod providers and notifiers
    │   └── {name}_state_provider.dart
    ├── widgets/                       # Feature-specific widgets
    │   └── {name}_widget.dart
    └── screens/                       # Full screens (if the feature has one)
        └── {name}_screen.dart
```

---

## 4. Backend Structure

### 4.1 Complete FastAPI Project Structure

```
backend/
├── main.py                            # FastAPI application entry, Uvicorn config
├── requirements.txt                   # Python dependencies (pinned)
├── pyproject.toml                     # Python project metadata, linting config
├── api/
│   ├── __init__.py
│   ├── routes/
│   │   ├── __init__.py
│   │   ├── health.py                  # GET /health
│   │   ├── info.py                    # GET /api/v1/info
│   │   ├── parse.py                   # POST /api/v1/parse
│   │   ├── solve.py                   # POST /api/v1/solve, /evaluate, /simplify
│   │   └── graph.py                   # POST /api/v1/graph
│   └── models/
│       ├── __init__.py
│       ├── requests.py                # Pydantic request models
│       └── responses.py               # Pydantic response models
├── engine/
│   ├── __init__.py
│   ├── parser.py                      # LaTeX → SymPy expression converter
│   ├── solver.py                      # SymPy computation wrapper
│   └── grapher.py                     # Plotly graph generator
├── core/
│   ├── __init__.py
│   ├── config.py                      # App configuration (port, timeouts)
│   ├── errors.py                      # Custom exception classes
│   └── logging.py                     # Logging configuration
└── tests/
    ├── __init__.py
    ├── conftest.py                    # Shared test fixtures
    ├── test_parser.py                 # Parser unit tests
    ├── test_solver.py                 # Solver unit tests
    ├── test_grapher.py                # Grapher unit tests
    ├── test_api_health.py             # Health endpoint tests
    ├── test_api_parse.py              # Parse endpoint tests
    ├── test_api_solve.py              # Solve endpoint tests
    └── test_api_graph.py              # Graph endpoint tests
```

### 4.2 Backend Module Rules

1. **`api/routes/`** — One file per endpoint group. Each file defines a FastAPI `APIRouter`.
2. **`api/models/`** — Pydantic models for request validation and response serialization.
3. **`engine/`** — Pure computation. No HTTP, no Pydantic. Functions accept and return plain Python types.
4. **`core/`** — Shared infrastructure. Configuration, error definitions, logging setup.
5. **`tests/`** — Tests mirror source structure. `conftest.py` provides shared fixtures.

---

## 5. Naming Conventions

### 5.1 File Naming

| Category | Convention | Examples |
|----------|-----------|---------|
| Dart files | `snake_case.dart` | `canvas_widget.dart`, `stroke_repository.dart` |
| Python files | `snake_case.py` | `solver.py`, `test_parser.py` |
| Test files (Dart) | `{source_name}_test.dart` | `stroke_test.dart`, `canvas_widget_test.dart` |
| Test files (Python) | `test_{source_name}.py` | `test_solver.py`, `test_api_parse.py` |
| Generated files (Dart) | `{source_name}.g.dart`, `{source_name}.freezed.dart` | `stroke.g.dart`, `canvas_state.freezed.dart` |
| Documentation | `PascalCase.md` | `PRD.md`, `AppFlow.md`, `Schema.md` |
| Assets | `snake_case.{ext}` | `empty_state.svg`, `app_icon.png` |
| Directories | `snake_case` | `math_engine/`, `canvas/` |

### 5.2 Class Naming

| Category | Convention | Examples |
|----------|-----------|---------|
| Domain models | `PascalCase` | `Stroke`, `Notebook`, `MathResult` |
| Entity (data layer) | `{Model}Entity` | `StrokeEntity`, `NotebookEntity` |
| Repository interface | `{Name}Repository` | `StrokeRepository`, `NotebookRepository` |
| Repository implementation | `{Name}RepositoryImpl` | `StrokeRepositoryImpl` |
| Data source | `{Name}LocalDatasource` | `StrokeLocalDatasource` |
| API client | `{Name}ApiClient` | `MathApiClient`, `GraphApiClient` |
| Provider | `{name}Provider` (camelCase) | `canvasStateProvider`, `notebookListProvider` |
| Notifier | `{Name}StateNotifier` | `CanvasStateNotifier` |
| Screen | `{Name}Screen` | `HomeScreen`, `CanvasScreen` |
| Widget | `{Name}Widget` or descriptive name | `CanvasWidget`, `NotebookCard` |
| Painter | `{Name}Painter` | `StrokePainter`, `CanvasBackgroundPainter` |
| State (freezed) | `{Name}State` | `CanvasState`, `RecognitionState` |

### 5.3 Variable and Function Naming

| Category | Convention | Examples |
|----------|-----------|---------|
| Dart variables | `camelCase` | `strokeWidth`, `viewportOffset` |
| Dart functions | `camelCase` | `addPoint()`, `calculateBoundingBox()` |
| Dart constants | `camelCase` | `defaultStrokeWidth`, `maxZoomLevel` |
| Python variables | `snake_case` | `stroke_width`, `viewport_offset` |
| Python functions | `snake_case` | `add_point()`, `calculate_bounding_box()` |
| Python constants | `SCREAMING_SNAKE` | `DEFAULT_STROKE_WIDTH`, `MAX_ZOOM_LEVEL` |
| Database columns | `snake_case` | `notebook_id`, `created_at` |
| API paths | `kebab-case` (by convention) or `snake_case` | `/api/v1/solve` |

---

## 6. Import Rules

### 6.1 Dart Import Rules

```dart
// Order (separated by blank lines):
// 1. dart: SDK imports
import 'dart:math';
import 'dart:ui';

// 2. package: third-party imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 3. package:mathcanvas project imports (absolute)
import 'package:mathcanvas/core/constants/app_constants.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';

// 4. Relative imports (within same feature)
import '../models/canvas_state.dart';
import 'stroke_painter.dart';
```

### 6.2 Import Restrictions

| From | May Import | Must NOT Import |
|------|-----------|----------------|
| `presentation/` | `domain/`, `core/`, `shared/` | `data/` (any feature) |
| `domain/` | Nothing (self-contained) | `data/`, `presentation/`, `core/` (except models used as value objects) |
| `data/` | `domain/` (interfaces), `core/` | `presentation/` |
| `core/` | dart:, third-party packages | Any feature |
| `shared/` | `core/`, dart:, third-party | Any feature |
| Feature A | `core/`, `shared/` | Feature B (use providers for cross-feature) |

### 6.3 Python Import Rules

```python
# Order (separated by blank lines):
# 1. Standard library
import logging
from typing import Optional

# 2. Third-party
from fastapi import APIRouter
from sympy import symbols, solve

# 3. Local
from engine.solver import MathSolver
from api.models.requests import SolveRequest
```

---

## 7. Dependency Rules

### 7.1 Package Dependencies

| Rule | Description |
|------|-------------|
| Adding a dependency | Must be documented in [TRD.md](file:///d:/MathCanvas/TRD.md) technology matrix |
| Removing a dependency | Must be documented in change log |
| Version ranges | Use `^` (caret) syntax in `pubspec.yaml` |
| Version pinning | Exact versions in `requirements.txt` (Python) |
| License | Only MIT, BSD, Apache 2.0 licensed packages |
| No abandoned packages | Package must have commit activity within 12 months |

### 7.2 Internal Dependencies

```mermaid
graph TD
    subgraph "Allowed Dependencies"
        core["core/"]
        shared["shared/"]
        canvas["features/canvas/"]
        recognition["features/recognition/"]
        math["features/math_engine/"]
        graph["features/graph/"]
        notebook["features/notebook/"]
    end

    canvas --> core
    recognition --> core
    math --> core
    graph --> core
    notebook --> core
    shared --> core

    canvas --> shared
    recognition --> shared
    math --> shared
    graph --> shared
    notebook --> shared

    %% Cross-feature via providers only (dashed)
    recognition -.->|"via provider"| canvas
    math -.->|"via provider"| recognition
    graph -.->|"via provider"| math
```

---

## 8. Ownership Rules

### 8.1 File Ownership

Each directory has a designated owner (an AI agent role). The owner is responsible for:

1. Maintaining code quality within their area.
2. Reviewing changes proposed by other agents.
3. Ensuring compliance with architecture patterns.
4. Keeping documentation current.

| Directory | Owner | Reviewer |
|-----------|-------|----------|
| `frontend/lib/app/` | Agent-Frontend | Agent-QA |
| `frontend/lib/core/` | Agent-Frontend | Agent-QA |
| `frontend/lib/features/canvas/` | Agent-Frontend | Agent-QA |
| `frontend/lib/features/recognition/` | Agent-Frontend | Agent-QA |
| `frontend/lib/features/math_engine/` | Agent-Frontend | Agent-Backend |
| `frontend/lib/features/graph/` | Agent-Frontend | Agent-Backend |
| `frontend/lib/features/notebook/` | Agent-Frontend | Agent-QA |
| `frontend/lib/shared/` | Agent-Frontend | Agent-QA |
| `backend/` | Agent-Backend | Agent-QA |
| `docs/` | Agent-Docs | All agents |

### 8.2 Cross-Ownership Protocol

If Agent-Backend needs to modify a file in `frontend/lib/features/math_engine/data/api/`:
1. Agent-Backend proposes the change.
2. Agent-Frontend reviews the impact on the feature module.
3. Change proceeds if no architectural concerns.

---

## 9. File Creation Rules

### 9.1 Before Creating a New File

Every agent must perform these checks before creating a new file:

1. **Search for existing files** that might serve the same purpose.
   ```
   Grep the codebase for: the class name, the function name, and related keywords.
   ```
2. **Check if the functionality belongs in an existing file.** If the file would have < 50 lines, consider adding to an existing file.
3. **Verify the file location matches the structure.** Refer to Section 3 and Section 4.
4. **Verify the file name follows naming conventions.** Refer to Section 5.

### 9.2 File Creation Checklist

- [ ] Searched for existing files with similar purpose
- [ ] File location matches the documented structure
- [ ] File name follows naming conventions
- [ ] File has a header comment explaining its purpose
- [ ] File is added to the correct feature module
- [ ] If creating a new directory, it follows the structure pattern
- [ ] [Structure.md](file:///d:/MathCanvas/Structure.md) is updated if the new file creates a new pattern

---

## 10. Refactoring Rules

### 10.1 When to Refactor

| Trigger | Action |
|---------|--------|
| File exceeds 300 lines | Split into multiple files by responsibility |
| Function exceeds 50 lines | Extract sub-functions |
| Code duplicated in 3+ places | Extract to `core/` or shared utility |
| Feature module is too large | Split into sub-features |
| Import chain is circular | Introduce interface in `domain/` |

### 10.2 Refactoring Protocol

1. **Document the need.** Add a technical debt item to [Tracker.md](file:///d:/MathCanvas/Tracker.md).
2. **Plan the refactoring.** Define source files, target files, and the transformation.
3. **Update tests first.** Ensure existing tests still pass after refactoring.
4. **Refactor.** Move code, update imports, run tests.
5. **Update documentation.** If structure changed, update [Structure.md](file:///d:/MathCanvas/Structure.md).
6. **Verify no broken imports.** Run `dart analyze`.

### 10.3 Refactoring Restrictions

| Forbidden | Why |
|-----------|-----|
| Refactoring during a feature sprint | Delays feature delivery. Schedule separately. |
| Renaming public APIs without updating all consumers | Breaks other agents' code |
| Moving files without updating imports | Build errors |
| Refactoring without test coverage | No safety net |

---

## 11. File Size Limits

| File Type | Max Lines | Action When Exceeded |
|-----------|----------|---------------------|
| Dart source file | 300 | Split by responsibility |
| Python source file | 300 | Split into modules |
| Test file | 500 | Split by test group |
| Configuration file | 200 | Use includes/imports |
| Documentation file | No limit | Use sections and table of contents |

### 11.1 Splitting Strategy

When a file exceeds limits:

**Domain model file (e.g., `stroke.dart` at 350 lines):**
- Split: `stroke.dart` (core model) + `stroke_point.dart` (sub-model) + `stroke_extensions.dart` (utility extensions)

**Widget file (e.g., `canvas_widget.dart` at 400 lines):**
- Split: `canvas_widget.dart` (main widget) + `canvas_gesture_handler.dart` (gesture logic) + `canvas_overlay_layer.dart` (overlay rendering)

**Test file (e.g., `stroke_test.dart` at 600 lines):**
- Split: `stroke_model_test.dart` + `stroke_persistence_test.dart` + `stroke_rendering_test.dart`

---

## 12. Folder Creation Rules

### 12.1 When to Create a New Folder

| Situation | Create Folder? | Rule |
|-----------|---------------|------|
| New feature module | Yes | Must follow feature module pattern (Section 3.2) |
| 3+ files with shared purpose | Yes | Group into descriptive folder |
| Single file needs isolation | No | Keep in parent directory |
| Temporary/scratch files | No | Use `/tmp` or exclude from git |

### 12.2 Folder Naming

1. **Use `snake_case`.**
2. **Use plural nouns for collections:** `models/`, `widgets/`, `screens/`, `providers/`.
3. **Use singular nouns for specific features:** `canvas/`, `recognition/`, `notebook/`.
4. **Never use:** `new/`, `old/`, `temp/`, `backup/`, `v2/`, `misc/`, `other/`.

---

## 13. Architecture Compliance Rules

### 13.1 Compliance Checks

Every code change must satisfy these architectural rules:

| Check | Verification Method |
|-------|-------------------|
| Layer isolation | No `data/` imports in `presentation/`. Run `dart analyze`. |
| Feature isolation | No cross-feature imports except via `core/` or providers. Grep check. |
| State management | All mutable state goes through Riverpod. Grep for non-provider `setState`. |
| Database access | All DB access goes through DAO → Repository → Provider. Grep check. |
| API access | All API calls go through `api_client.dart`. Grep for raw `dio` usage. |
| Theme compliance | No hardcoded colors or text styles. Grep for `Color(0x`, `TextStyle(fontSize:`. |
| Naming | All files follow naming conventions. File name check. |
| Structure | All files are in correct directories. Path check. |

### 13.2 Automated Compliance (CI)

```yaml
# .github/workflows/compliance.yml (conceptual)
checks:
  - name: Layer violations
    command: "grep -r 'import.*data/' frontend/lib/*/presentation/ && exit 1 || exit 0"
  - name: Hardcoded colors
    command: "grep -rn 'Color(0x' frontend/lib/ --include='*.dart' | grep -v 'app_colors.dart' && exit 1 || exit 0"
  - name: Print statements
    command: "grep -rn 'print(' frontend/lib/ --include='*.dart' | grep -v '_test.dart' && exit 1 || exit 0"
  - name: Dart analyze
    command: "cd frontend && flutter analyze"
  - name: Python lint
    command: "cd backend && ruff check ."
```

---

## 14. Structure Validation Checklist

Before every sprint review, validate:

```markdown
## Structure Validation Checklist

### Feature Modules
- [ ] Every feature follows the data/domain/presentation pattern
- [ ] No feature imports another feature directly
- [ ] All models are in domain/models/
- [ ] All repository interfaces are in domain/repositories/
- [ ] All repository implementations are in data/repositories/
- [ ] All providers are in presentation/providers/
- [ ] All widgets are in presentation/widgets/
- [ ] All screens are in presentation/screens/

### Core Module
- [ ] core/ contains only cross-cutting utilities
- [ ] core/ does not import any feature
- [ ] No business logic in core/

### Shared Module
- [ ] shared/ contains only reusable widgets and database config
- [ ] shared/ does not import any feature

### Backend
- [ ] Routes are in api/routes/
- [ ] Models are in api/models/
- [ ] Engine logic is in engine/
- [ ] No HTTP code in engine/ files
- [ ] Tests are in tests/

### Naming
- [ ] All files are snake_case
- [ ] All classes follow naming conventions
- [ ] No forbidden filenames (helpers_final.dart, etc.)

### Sizes
- [ ] No source file exceeds 300 lines
- [ ] No test file exceeds 500 lines
- [ ] No function exceeds 50 lines
```

---

## 15. Good and Bad Examples

### 15.1 File Naming

| ✅ Good | ❌ Bad | Why |
|---------|--------|-----|
| `stroke_repository.dart` | `strokeRepository.dart` | Dart files use snake_case |
| `stroke_repository_impl.dart` | `stroke_repo.dart` | Don't abbreviate; include `_impl` for implementations |
| `canvas_state.dart` | `canvas_state_v2.dart` | No version suffixes |
| `recognition_engine.dart` | `helper_new.dart` | Descriptive name, no `helper` or `new` |
| `graph_chart_painter.dart` | `random_utils.dart` | Specific name, no `random` or `utils` |
| `math_api_client.dart` | `api.dart` | Feature-specific name, not generic |

### 15.2 File Location

| ✅ Good | ❌ Bad |
|---------|--------|
| `features/canvas/domain/models/stroke.dart` | `lib/models/stroke.dart` |
| `features/canvas/presentation/widgets/canvas_widget.dart` | `lib/widgets/canvas_widget.dart` |
| `features/canvas/data/repositories/stroke_repository_impl.dart` | `lib/repositories/stroke_repository_impl.dart` |
| `core/extensions/context_extensions.dart` | `features/canvas/utils/helpers.dart` |
| `shared/widgets/app_loading_indicator.dart` | `lib/common/loading.dart` |

### 15.3 Import Patterns

```dart
// ✅ Good: Presentation imports from domain
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/repositories/stroke_repository.dart';

// ❌ Bad: Presentation imports from data
import 'package:mathcanvas/features/canvas/data/datasources/stroke_local_datasource.dart';
import 'package:mathcanvas/features/canvas/data/models/stroke_entity.dart';

// ✅ Good: Feature uses core
import 'package:mathcanvas/core/constants/api_constants.dart';

// ❌ Bad: Feature imports another feature
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
// (Instead, use a shared provider or core abstraction)

// ✅ Good: Cross-feature via provider
// In recognition provider:
final strokes = ref.watch(canvasStateProvider).strokes;
// canvasStateProvider is in the Riverpod provider graph, not a direct import
```

### 15.4 Code Organization

```dart
// ✅ Good: Single responsibility, clear purpose
// File: features/canvas/presentation/widgets/canvas_toolbar.dart
class CanvasToolbar extends ConsumerWidget {
  // Only toolbar rendering and interaction logic
}

// ❌ Bad: Multiple responsibilities
// File: features/canvas/canvas_everything.dart
class CanvasManager {
  // Renders canvas AND manages strokes AND handles recognition AND saves data
  // This should be 4+ separate classes
}
```

### 15.5 Directory Creation

```
✅ Good: Follows feature module pattern
features/
  canvas/
    data/
    domain/
    presentation/

❌ Bad: Flat structure with no organization
features/
  canvas_widget.dart
  canvas_state.dart
  canvas_repo.dart
  canvas_model.dart
  canvas_db.dart

❌ Bad: Meaningless directory names
features/
  canvas/
    new/
    old/
    temp/
    v2/
    misc/
```

---

*End of Structure.md*
