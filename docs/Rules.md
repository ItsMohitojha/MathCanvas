# MathCanvas — Agent Rules and Coding Standards

**Version:** 1.0
**Status:** Approved
**Last Updated:** 2026-06-12
**Owner:** Architecture
**Audience:** All AI Coding Agents
**Enforcement:** Mandatory — violations require immediate correction
**References:** [TRD.md](file:///d:/MathCanvas/TRD.md), [Schema.md](file:///d:/MathCanvas/Schema.md), [Structure.md](file:///d:/MathCanvas/Structure.md), [UI_UX.md](file:///d:/MathCanvas/UI_UX.md)

---

## 1. Coding Standards

### 1.1 Dart/Flutter Standards

| Rule | Specification |
|------|--------------|
| Language version | Latest stable Dart SDK |
| Formatting | `dart format` (default settings, line length 80) |
| Linting | `analysis_options.yaml` with `flutter_lints` (all rules enabled) |
| Naming: Files | `snake_case.dart` |
| Naming: Classes | `PascalCase` |
| Naming: Variables/Functions | `camelCase` |
| Naming: Constants | `camelCase` (Dart convention, not SCREAMING_SNAKE) |
| Naming: Enums | `PascalCase` for type, `camelCase` for values |
| Naming: Private | Prefix with underscore `_` |
| Naming: Providers | `camelCase` + `Provider` suffix (e.g., `canvasStateProvider`) |
| Naming: Notifiers | `PascalCase` + `Notifier` suffix (e.g., `CanvasStateNotifier`) |
| Imports | Use relative imports within the same package. Use `package:` for cross-package. |
| Import order | 1) dart: 2) package: (third-party) 3) package:mathcanvas (project) 4) relative |
| Max file length | 300 lines (excluding generated code). Split if longer. |
| Max function length | 50 lines. Extract sub-functions if longer. |
| Max parameters | 5 positional parameters. Use named parameters beyond 3. |
| Documentation | All public APIs must have `///` doc comments. |
| Null safety | Sound null safety. Never use `!` without documenting why null is impossible. |
| `dynamic` | Forbidden except for JSON deserialization boundaries. |
| `print()` | Forbidden. Use `Logger` from the `logging` package. |
| `debugPrint()` | Allowed only in debug-only code guarded by `kDebugMode`. |

### 1.2 Python Standards

| Rule | Specification |
|------|--------------|
| Language version | Python 3.11+ |
| Formatting | `black` (default settings, line length 88) |
| Linting | `ruff` with default rules |
| Type hints | Required for all function signatures |
| Naming: Files | `snake_case.py` |
| Naming: Classes | `PascalCase` |
| Naming: Variables/Functions | `snake_case` |
| Naming: Constants | `SCREAMING_SNAKE_CASE` |
| Naming: Private | Prefix with underscore `_` |
| Imports | Use absolute imports. Group: 1) stdlib 2) third-party 3) local |
| Max file length | 300 lines. Split into modules if longer. |
| Max function length | 50 lines. |
| Documentation | All public functions must have docstrings (Google style). |
| `eval()` | **ABSOLUTELY FORBIDDEN** — use `sympy.parsing.sympy_parser.parse_expr`. |
| `exec()` | **ABSOLUTELY FORBIDDEN**. |
| `print()` | Forbidden in production code. Use `logging` module. |

### 1.3 SQL Standards

| Rule | Specification |
|------|--------------|
| Keywords | UPPERCASE (`SELECT`, `FROM`, `WHERE`, `INSERT`, etc.) |
| Table names | `snake_case`, plural (e.g., `notebooks`, `strokes`) |
| Column names | `snake_case` (e.g., `created_at`, `notebook_id`) |
| Index names | `idx_{table}_{columns}` (e.g., `idx_strokes_notebook_id`) |
| Parameterization | Always use `?` placeholders. Never concatenate strings into queries. |
| Migrations | Forward-only, non-destructive, idempotent |

---

## 2. Architecture Rules

### 2.1 Layer Rules

| Rule ID | Rule | Enforcement |
|---------|------|-------------|
| AR-01 | Presentation layer must not import data layer. | Static analysis |
| AR-02 | Domain layer must not import any other layer. | Static analysis |
| AR-03 | Data layer may import domain layer (for interfaces). | Allowed |
| AR-04 | Presentation layer communicates with data layer only through Riverpod providers. | Code review |
| AR-05 | All repositories must be defined as abstract interfaces in the domain layer. | Code review |
| AR-06 | All repositories must be implemented in the data layer. | Code review |
| AR-07 | All state must be managed through Riverpod providers. | Code review |
| AR-08 | No global mutable state. | Static analysis |

### 2.2 Dependency Rules

| Rule ID | Rule |
|---------|------|
| DR-01 | No circular dependencies between features. |
| DR-02 | Shared code goes in `core/` or `shared/`. |
| DR-03 | Features must not import from other features directly. Shared dependencies go through `core/` or Riverpod providers. |
| DR-04 | New package dependencies require documentation update in [TRD.md](file:///d:/MathCanvas/TRD.md). |
| DR-05 | No pinned dependency versions unless required for compatibility. Use `^` ranges. |

### 2.3 Component Communication

| Rule ID | Rule |
|---------|------|
| CC-01 | Flutter ↔ Python communication is HTTP REST only (no FFI, no WebSocket, no gRPC). |
| CC-02 | All API requests use the `dio` HTTP client. |
| CC-03 | All API responses follow the common envelope format (see [TRD.md §9.2](file:///d:/MathCanvas/TRD.md)). |
| CC-04 | All API errors are caught and displayed to the user — never silently swallowed. |

---

## 3. Documentation Rules

| Rule ID | Rule |
|---------|------|
| DOC-01 | Every public Dart class, method, and property must have `///` documentation comments. |
| DOC-02 | Every public Python function must have a Google-style docstring. |
| DOC-03 | Every new file must have a file-level comment explaining its purpose. |
| DOC-04 | Architecture changes require an ADR entry in [Tracker.md](file:///d:/MathCanvas/Tracker.md). |
| DOC-05 | Schema changes require [Schema.md](file:///d:/MathCanvas/Schema.md) update BEFORE code changes. |
| DOC-06 | API endpoint changes require [TRD.md](file:///d:/MathCanvas/TRD.md) update BEFORE code changes. |
| DOC-07 | New features require user story in [PRD.md](file:///d:/MathCanvas/PRD.md). |
| DOC-08 | UI changes require update to [UI_UX.md](file:///d:/MathCanvas/UI_UX.md) and/or [AppFlow.md](file:///d:/MathCanvas/AppFlow.md). |
| DOC-09 | Structural changes require update to [Structure.md](file:///d:/MathCanvas/Structure.md). |
| DOC-10 | No TODO comments in committed code. Create a task in [Tracker.md](file:///d:/MathCanvas/Tracker.md) instead. |

---

## 4. Git Rules

### 4.1 Commit Messages

Format: `<type>(<scope>): <description>`

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, no logic change |
| `refactor` | Code restructuring, no behavior change |
| `test` | Adding or updating tests |
| `chore` | Build, CI, dependency updates |
| `perf` | Performance improvement |

**Examples:**
```
feat(canvas): implement pinch-to-zoom with focal point
fix(strokes): resolve crash when stroke has zero points
docs(schema): add migration strategy section
test(solver): add unit tests for quadratic equation solving
refactor(recognition): extract stroke grouping into separate class
```

**Rules:**
- Subject line: max 72 characters, lowercase, no period.
- Body: optional, wrap at 80 characters, explain "why" not "what".
- Reference task IDs where applicable (e.g., `Refs: P2-05`).

### 4.2 Commit Scope

| Scope | Files |
|-------|-------|
| `canvas` | `features/canvas/**` |
| `strokes` | `features/canvas/stroke/**` |
| `recognition` | `features/recognition/**` |
| `math` | `features/math_engine/**` |
| `graph` | `features/graph/**` |
| `notebook` | `features/notebook/**` |
| `core` | `core/**` |
| `app` | `app/**` |
| `api` | `backend/api/**` |
| `solver` | `backend/engine/solver.py` |
| `parser` | `backend/engine/parser.py` |
| `grapher` | `backend/engine/grapher.py` |
| `schema` | Database schema changes |
| `deps` | Dependency updates |
| `ci` | CI/CD changes |

---

## 5. Branch Rules

### 5.1 Branch Strategy

| Branch | Purpose | Protected | Merge From |
|--------|---------|-----------|-----------|
| `main` | Production-ready code | Yes | `develop` via PR |
| `develop` | Integration branch | Yes | Feature branches via PR |
| `feature/<name>` | Feature development | No | `develop` |
| `fix/<name>` | Bug fixes | No | `develop` |
| `docs/<name>` | Documentation updates | No | `develop` |

### 5.2 Branch Naming

Format: `<type>/<phase>-<short-description>`

**Examples:**
```
feature/p1-canvas-engine
feature/p2-stroke-capture
feature/p3-recognition-pipeline
fix/p2-stroke-zero-points-crash
docs/p0-update-schema
```

### 5.3 Branch Rules

| Rule | Specification |
|------|--------------|
| Direct commits to `main` | Forbidden |
| Direct commits to `develop` | Forbidden |
| Feature branch lifetime | Max 1 week (prefer shorter) |
| Merge strategy | Squash merge to `develop`, merge commit to `main` |
| Delete after merge | Yes — delete feature branches after merge |

---

## 6. Testing Requirements

### 6.1 Test Coverage Targets

| Layer | Coverage Target | Enforcement |
|-------|----------------|-------------|
| Domain models | ≥ 95% | CI check |
| Repository implementations | ≥ 90% | CI check |
| State notifiers | ≥ 85% | CI check |
| API endpoints (backend) | ≥ 90% | CI check |
| Engine modules (backend) | ≥ 90% | CI check |
| Widgets/Screens | ≥ 70% | CI check |
| Overall (frontend) | ≥ 80% | CI check |
| Overall (backend) | ≥ 90% | CI check |

### 6.2 Test Categories

| Category | Framework | Location | Naming |
|----------|-----------|----------|--------|
| Unit (Dart) | flutter_test | `frontend/test/unit/` | `*_test.dart` |
| Widget (Dart) | flutter_test | `frontend/test/widget/` | `*_test.dart` |
| Integration (Dart) | integration_test | `frontend/integration_test/` | `*_test.dart` |
| Unit (Python) | pytest | `backend/tests/` | `test_*.py` |
| API (Python) | pytest + httpx | `backend/tests/` | `test_api_*.py` |

### 6.3 Test Rules

| Rule ID | Rule |
|---------|------|
| TR-01 | Every new feature must include tests. No exceptions. |
| TR-02 | Every bug fix must include a regression test. |
| TR-03 | Tests must be independent — no test may depend on another test's execution. |
| TR-04 | Tests must not use real I/O (network, file system) — use mocks. |
| TR-05 | Tests must be deterministic — no flaky tests. |
| TR-06 | Test files mirror the source file structure. |
| TR-07 | Tests must not use `sleep()` or fixed delays. Use proper async patterns. |
| TR-08 | Test names must describe the scenario: `test_[method]_[scenario]_[expected]`. |
| TR-09 | Never remove a test without documented justification and approval. |

### 6.4 Test Examples

**Dart unit test:**
```dart
// test/unit/features/canvas/domain/models/stroke_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';

void main() {
  group('Stroke', () {
    test('boundingBox_withMultiplePoints_calculatesCorrectBounds', () {
      final stroke = Stroke(
        id: 'test-id',
        notebookId: 'notebook-id',
        points: [
          StrokePoint(x: 10, y: 20, timestamp: 0, pressure: 1.0),
          StrokePoint(x: 30, y: 40, timestamp: 1, pressure: 1.0),
        ],
        color: '#000000',
        strokeWidth: 2.0,
        createdAt: DateTime.now(),
      );

      expect(stroke.boundingBox.left, 10);
      expect(stroke.boundingBox.top, 20);
      expect(stroke.boundingBox.right, 30);
      expect(stroke.boundingBox.bottom, 40);
    });
  });
}
```

**Python unit test:**
```python
# backend/tests/test_solver.py
import pytest
from engine.solver import MathSolver

class TestMathSolver:
    def test_evaluate_arithmetic_returns_numeric_result(self):
        solver = MathSolver()
        result = solver.evaluate("2 + 3 * 4")
        assert result.value == "14"
        assert result.numeric == 14.0

    def test_solve_linear_equation_returns_solution(self):
        solver = MathSolver()
        result = solver.solve("2*x + 4 - 8", variables=["x"])
        assert result.solutions[0].variable == "x"
        assert result.solutions[0].value == "2"
```

---

## 7. Security Requirements

| Rule ID | Rule |
|---------|------|
| SEC-01 | Never use `eval()`, `exec()`, or equivalent in any language. |
| SEC-02 | Always use parameterized SQL queries. Never concatenate user input into SQL. |
| SEC-03 | Sanitize all inputs to the SymPy parser. Use `parse_expr` with restricted transformations. |
| SEC-04 | FastAPI must bind to `127.0.0.1` only — never `0.0.0.0`. |
| SEC-05 | All computation endpoints must have timeout limits. |
| SEC-06 | No telemetry, analytics, or data transmission in V1. |
| SEC-07 | No secrets, API keys, or credentials in source code. |
| SEC-08 | Validate all Pydantic models before processing. |
| SEC-09 | No file system access from API endpoints (except logging). |

---

## 8. API Requirements

| Rule ID | Rule |
|---------|------|
| API-01 | All endpoints follow REST conventions. |
| API-02 | All endpoints are versioned (`/api/v1/`). |
| API-03 | All responses use the common envelope format: `{success, result, error, computation_time_ms}`. |
| API-04 | All request bodies are validated via Pydantic models. |
| API-05 | All error responses include structured error with `code`, `message`, and `details`. |
| API-06 | Error codes are defined constants, not magic strings. |
| API-07 | API documentation is maintained in [TRD.md](file:///d:/MathCanvas/TRD.md). |
| API-08 | New endpoints require TRD update before implementation. |
| API-09 | Breaking API changes require version increment (`/api/v2/`). |
| API-10 | All endpoints have timeout limits (default: 10s). |

---

## 9. Database Requirements

| Rule ID | Rule |
|---------|------|
| DB-01 | Never modify schema without updating [Schema.md](file:///d:/MathCanvas/Schema.md) first. |
| DB-02 | All schema changes require a migration script. |
| DB-03 | Migrations are forward-only (no rollbacks). |
| DB-04 | Migrations must be idempotent (`IF NOT EXISTS`). |
| DB-05 | All queries use parameterized statements (`?` placeholders). |
| DB-06 | All database operations go through DAO → Repository → Provider. |
| DB-07 | No raw database access from UI widgets. |
| DB-08 | Foreign keys must be ON (`PRAGMA foreign_keys = ON`). |
| DB-09 | WAL mode must be enabled. |
| DB-10 | New tables require index planning documented in [Schema.md](file:///d:/MathCanvas/Schema.md). |
| DB-11 | Batch operations for performance-critical writes (e.g., auto-save). |

---

## 10. UI Requirements

| Rule ID | Rule |
|---------|------|
| UI-01 | All colors must come from the design token system defined in [UI_UX.md](file:///d:/MathCanvas/UI_UX.md). |
| UI-02 | No hardcoded colors in widget code. Use `Theme.of(context)` or design tokens. |
| UI-03 | All text styles must use the typography system defined in [UI_UX.md](file:///d:/MathCanvas/UI_UX.md). |
| UI-04 | All spacing values must use the spacing system defined in [UI_UX.md](file:///d:/MathCanvas/UI_UX.md). |
| UI-05 | Touch targets must be ≥ 44×44 logical pixels. |
| UI-06 | All interactive elements must have unique, descriptive IDs for testing. |
| UI-07 | All screens must support both light and dark themes. |
| UI-08 | Animations must be ≤ 300ms for transitions, ≤ 150ms for micro-interactions. |
| UI-09 | No `Scaffold` without an `AppBar` or explicit justification. |
| UI-10 | Error messages must be user-friendly — no technical jargon. |
| UI-11 | Loading states must be displayed for operations > 500ms. |
| UI-12 | Empty states must follow the pattern defined in [AppFlow.md](file:///d:/MathCanvas/AppFlow.md). |

---

## 11. Performance Requirements

| Rule ID | Rule | Target |
|---------|------|--------|
| PERF-01 | Stroke rendering latency | < 16ms (60fps) |
| PERF-02 | Canvas pan/zoom frame rate | ≥ 60fps |
| PERF-03 | API round-trip (evaluate) | < 500ms |
| PERF-04 | API round-trip (solve) | < 2s |
| PERF-05 | API round-trip (graph) | < 3s |
| PERF-06 | App cold start | < 3s |
| PERF-07 | Notebook load (1000 strokes) | < 500ms |
| PERF-08 | Database write (single stroke) | < 50ms |
| PERF-09 | Memory (Flutter) | < 250MB |
| PERF-10 | Memory (Python) | < 200MB |
| PERF-11 | No janky frames during drawing | 0 frames > 16ms |
| PERF-12 | Viewport culling must be active | Only visible strokes rendered |

---

## 12. Agent Coordination Rules

### 12.1 Communication

| Rule ID | Rule |
|---------|------|
| COORD-01 | Agents must read [Tracker.md](file:///d:/MathCanvas/Tracker.md) before starting work to check for blockers. |
| COORD-02 | Agents must update [Tracker.md](file:///d:/MathCanvas/Tracker.md) when starting, completing, or blocking on a task. |
| COORD-03 | Agents must update the Activity Log when making significant changes. |
| COORD-04 | Before creating a new file, search for existing files that might serve the purpose. |
| COORD-05 | Before creating a new utility function, search for existing utility functions. |
| COORD-06 | Cross-feature changes require notification to the owning agent. |

### 12.2 Conflict Resolution

| Rule ID | Rule |
|---------|------|
| COORD-07 | If two agents need to modify the same file, coordinate via [Tracker.md](file:///d:/MathCanvas/Tracker.md). |
| COORD-08 | Interface changes (abstract classes, API contracts) require agreement from all consuming agents. |
| COORD-09 | Schema changes require approval from Agent-Frontend and Agent-Backend. |
| COORD-10 | Architecture disagreements are resolved by ADR vote, documented in [Tracker.md](file:///d:/MathCanvas/Tracker.md). |

### 12.3 Handoff Protocol

When one agent's work enables another agent to start:

1. Completing agent marks task as 🟢 Complete in [Tracker.md](file:///d:/MathCanvas/Tracker.md).
2. Completing agent verifies all acceptance criteria are met.
3. Completing agent documents any deviations or notes.
4. Receiving agent reads the completion notes before starting dependent work.

---

## 13. Forbidden Actions

These actions are **absolutely prohibited**. Any agent performing these actions must immediately revert and explain.

| ID | Forbidden Action | Reason |
|----|-----------------|--------|
| FA-01 | Using `eval()` or `exec()` in Python | Security: arbitrary code execution |
| FA-02 | Concatenating strings into SQL queries | Security: SQL injection |
| FA-03 | Committing directly to `main` or `develop` | Process: bypasses review |
| FA-04 | Implementing features not in [PRD.md](file:///d:/MathCanvas/PRD.md) | Scope: unapproved work |
| FA-05 | Removing tests without documented approval | Quality: reduces coverage |
| FA-06 | Bypassing acceptance criteria | Quality: feature incomplete |
| FA-07 | Adding cloud/network dependencies | Architecture: offline-first requirement |
| FA-08 | Adding user account/auth code | Scope: not in V1 |
| FA-09 | Using global mutable state | Architecture: Riverpod manages state |
| FA-10 | Importing data layer from presentation layer | Architecture: layer violation |
| FA-11 | Hardcoding colors, sizes, or strings | Maintainability: use design tokens |
| FA-12 | Creating files with names like `*_v2`, `*_new`, `*_final` | Naming: use meaningful versioned names |
| FA-13 | Adding `TODO` comments | Process: use Tracker.md for task tracking |
| FA-14 | Using `print()` in production code | Logging: use proper logging framework |
| FA-15 | Storing secrets or API keys in source code | Security: use environment config |
| FA-16 | Binding FastAPI to `0.0.0.0` | Security: exposes API to network |
| FA-17 | Modifying generated files (*.g.dart, *.freezed.dart) | Tooling: regenerated on build |
| FA-18 | Disabling lint rules without justification | Quality: enforces standards |

---

## 14. Definition of Done

A feature or task is "Done" when ALL of the following are true:

### 14.1 Code

- [ ] Code compiles with zero errors.
- [ ] Code passes `dart format` (Flutter) or `black` (Python) with no changes.
- [ ] Code passes all lint rules with zero warnings.
- [ ] No `TODO` comments in committed code.
- [ ] All public APIs have documentation comments.
- [ ] File length ≤ 300 lines.
- [ ] Function length ≤ 50 lines.

### 14.2 Tests

- [ ] Unit tests written for all business logic.
- [ ] Widget tests written for all new UI components.
- [ ] All tests pass.
- [ ] Test coverage meets or exceeds target for the component.
- [ ] No flaky tests.

### 14.3 Documentation

- [ ] All relevant documentation files updated.
- [ ] ADR created if architecture changed.
- [ ] Schema.md updated if database changed.
- [ ] TRD.md updated if API changed.
- [ ] Tracker.md updated with task status.

### 14.4 Review

- [ ] Code reviewed (self-review minimum for AI agents).
- [ ] Acceptance criteria verified.
- [ ] No regression in existing features.

---

## 15. Pull Request Checklist

Every pull request must include this checklist (copy into PR description):

```markdown
## PR Checklist

### Code Quality
- [ ] Code compiles with zero errors
- [ ] `dart format` / `black` applied
- [ ] All lint rules pass
- [ ] No `TODO` comments
- [ ] No hardcoded colors, strings, or magic numbers
- [ ] Public APIs documented

### Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated (if UI changed)
- [ ] All tests pass
- [ ] No flaky tests introduced

### Documentation
- [ ] [Tracker.md](file:///d:/MathCanvas/Tracker.md) updated
- [ ] [Schema.md](file:///d:/MathCanvas/Schema.md) updated (if DB changed)
- [ ] [TRD.md](file:///d:/MathCanvas/TRD.md) updated (if API changed)
- [ ] [UI_UX.md](file:///d:/MathCanvas/UI_UX.md) updated (if design changed)
- [ ] [AppFlow.md](file:///d:/MathCanvas/AppFlow.md) updated (if flow changed)
- [ ] ADR created (if architecture changed)

### Architecture
- [ ] No layer violations
- [ ] No circular dependencies
- [ ] No forbidden actions (see Rules.md §13)
- [ ] File structure matches [Structure.md](file:///d:/MathCanvas/Structure.md)

### Performance
- [ ] No N+1 database queries introduced
- [ ] No unnecessary widget rebuilds
- [ ] Canvas operations maintain 60fps
```

---

## 16. Code Review Checklist

When reviewing code (including self-review):

```markdown
## Code Review Checklist

### Correctness
- [ ] Does the code do what it's supposed to?
- [ ] Are edge cases handled?
- [ ] Are errors handled gracefully?

### Architecture
- [ ] Does the code follow the layer architecture?
- [ ] Are dependencies flowing in the correct direction?
- [ ] Is the code in the correct feature module?

### Style
- [ ] Does naming follow conventions?
- [ ] Is the code readable without excessive comments?
- [ ] Are functions focused (single responsibility)?

### Security
- [ ] No `eval()` or unsafe execution?
- [ ] No SQL injection vulnerability?
- [ ] No hardcoded secrets?

### Performance
- [ ] No unnecessary allocations in hot paths?
- [ ] No blocking operations on the UI thread?
- [ ] Database queries use indexes?

### Testing
- [ ] Are tests meaningful (not just covering lines)?
- [ ] Are edge cases tested?
- [ ] Are error paths tested?
```

---

## 17. Documentation Checklist

When updating documentation:

```markdown
## Documentation Checklist

### Content
- [ ] Information is accurate and current
- [ ] No ambiguous language
- [ ] No placeholder text or TBD sections
- [ ] Examples are correct and runnable

### Cross-References
- [ ] Links to other documents are valid
- [ ] Referenced section numbers are correct
- [ ] No orphaned references

### Format
- [ ] Markdown renders correctly
- [ ] Mermaid diagrams render correctly
- [ ] Tables are properly formatted
- [ ] Code blocks have language specifiers

### Consistency
- [ ] Terminology matches other documents
- [ ] Version numbers are consistent
- [ ] Dates are updated
```

---

## 18. Mandatory Rules Summary

These are the non-negotiable rules that override all other guidelines:

> 1. **Never modify schema without updating Schema.md**
> 2. **Never implement undocumented features**
> 3. **Never remove tests without approval**
> 4. **Never bypass acceptance criteria**
> 5. **Every feature requires tests**
> 6. **Every architecture change requires ADR entry**
> 7. **Every breaking change requires documentation updates**
> 8. **Never use eval() or exec()**
> 9. **Never concatenate strings into SQL**
> 10. **Never commit directly to main or develop**

---

*End of Rules.md*
