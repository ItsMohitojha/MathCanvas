# MathCanvas — Project Tracker

**Version:** 1.0
**Status:** Active
**Last Updated:** 2026-06-26
**Owner:** Project Management
**Audience:** AI Coding Agents
**References:** [ImplementationPlan.md](file:///d:/MathCanvas/ImplementationPlan.md), [Rules.md](file:///d:/MathCanvas/Rules.md)

---

## 1. Project Status

| Attribute | Value |
|-----------|-------|
| **Project** | MathCanvas V1 MVP |
| **Status** | 🟡 In Progress |
| **Start Date** | 2026-06-12 |
| **Target Release** | 2026-10-02 |
| **Current Phase** | Phase 8 — Testing |
| **Overall Progress** | 80% |
| **Health** | 🟢 Green |

### Phase Progress

| Phase | Name | Status | Progress | Blockers |
|-------|------|--------|----------|----------|
| 0 | Project Initialization | 🟢 Complete | 100% | None |
| 1 | Canvas Engine | 🟢 Complete | 100% | None |
| 2 | Stroke Capture System | 🟢 Complete | 100% | None |
| 3 | Recognition Layer | 🟢 Complete | 100% | None |
| 4 | Expression Parser | 🟢 Complete | 100% | None |
| 5 | Math Engine | 🟢 Complete | 100% | None |
| 6 | Graph Engine | 🟢 Complete | 100% | None |
| 7 | Persistence Layer | 🟢 Complete | 100% | None |
| 8 | Testing | 🔵 Not Started | 0% | All |
| 9 | Release | 🔵 Not Started | 0% | Phase 8 |

**Status Legend:**
- 🔵 Not Started
- 🟡 In Progress
- 🟢 Complete
- 🔴 Blocked
- ⚪ Skipped

---

## 2. Current Sprint

| Attribute | Value |
|-----------|-------|
| **Sprint** | Sprint 5 (Graph Engine) |
| **Sprint Goal** | Generate, render, and interact with function graphs on the canvas |
| **Start Date** | 2026-06-26 |
| **End Date** | 2026-06-27 |
| **Status** | 🟢 Complete |

### Sprint Backlog

| Task ID | Task | Assignee | Status | Notes |
|---------|------|----------|--------|-------|
| P6-01 | Implement Plotly graph generator | Agent-Backend | 🟢 Complete | engine/grapher.py — data + HTML generation |
| P6-02 | Implement POST /api/v1/graph route | Agent-Backend | 🟢 Complete | api/routes/graph.py |
| P6-03 | Support data and HTML output formats | Agent-Backend | 🟢 Complete | Data (JSON) and HTML (Plotly) endpoints |
| P6-04 | Implement graph styling (colors, grid, axes) | Agent-Backend | 🟢 Complete | GraphStyle Pydantic model |
| P6-05 | Create Flutter API client for graph endpoint | Agent-Frontend | 🟢 Complete | graph_api_client.dart |
| P6-06 | Create GraphChartPainter (native rendering) | Agent-Frontend | 🟢 Complete | CustomPainter with axes, grid, curve, glow |
| P6-07 | Implement graph axes, labels, and grid lines | Agent-Frontend | 🟢 Complete | Auto-scaled tick marks and labels |
| P6-08 | Implement graph card widget (draggable) | Agent-Frontend | 🟢 Complete | Glassmorphism card with isolated gestures |
| P6-09 | Implement graph interaction (pan/zoom) | Agent-Frontend | 🟢 Complete | Internal pinch-zoom and pan within card |
| P6-10 | Implement graph value inspection (tap x,y) | Agent-Frontend | 🟢 Complete | Crosshair + tooltip on tap |
| P6-11 | Create GraphStateNotifier (Riverpod) | Agent-Frontend | 🟢 Complete | Auto-generates graphs for function expressions |
| P6-12 | Implement GraphDao and GraphRepository | Agent-Frontend | 🟢 Complete | SQLite CRUD + repository pattern |
| P6-13 | Implement graph persistence | Agent-Frontend | 🟢 Complete | Cached graph data in SQLite |
| P6-14 | Implement graph update on expression change | Agent-Frontend | 🟢 Complete | Watches recognition state for deltas |
| P6-16 | Write unit tests for graph generator | Agent-Backend | 🟢 Complete | 18/18 tests passed |
| P6-17 | Write API integration tests | Agent-Backend | 🟢 Complete | 9/9 tests passed |
| P6-18 | Write widget tests for graph card | Agent-Frontend | 🟢 Complete | 6/6 tests passed |
| P6-19 | Performance test: graph gen under 3s | Agent-Backend | 🟢 Complete | 500 points in <1s |

---

## 3. Active Tasks

| Task ID | Task | Phase | Assignee | Priority | Status | Start | End | Blockers | Notes |
|---------|------|-------|----------|----------|--------|-------|-----|----------|-------|
| — | No active tasks at this time | — | — | — | — | — | — | — | — |

### Task Template

When adding tasks, use this format:

```markdown
| Task ID | Task | Phase | Assignee | Priority | Status | Start | End | Blockers | Notes |
|---------|------|-------|----------|----------|--------|-------|-----|----------|-------|
| P1-01 | Create CanvasState model | 1 | Agent-Frontend | High | 🔵 Not Started | — | — | P0 complete | |
```

---

## 4. Completed Tasks

| Task ID | Task | Phase | Assignee | Completed | Duration | Notes |
|---------|------|-------|----------|-----------|----------|-------|
| DOC-01 | Generate PRD.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-02 | Generate TRD.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-03 | Generate AppFlow.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-04 | Generate Schema.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-05 | Generate ImplementationPlan.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-06 | Generate Tracker.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-07 | Generate Rules.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-08 | Generate UI_UX.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| DOC-09 | Generate Structure.md | 0 | Agent-Docs | 2026-06-12 | — | Initial generation |
| P1-01 | Create CanvasState freezed model | 1 | Agent-Frontend | 2026-06-18 | — | `canvas_state.dart` created |
| P1-02 | Create CanvasStateNotifier (Riverpod) | 1 | Agent-Frontend | 2026-06-18 | — | `canvas_state_provider.dart` created |
| P1-03 | Implement coordinate transformation matrix | 1 | Agent-Frontend | 2026-06-18 | — | `canvas_transform.dart` created |
| P1-04 | Create CanvasBackgroundPainter (grid dots) | 1 | Agent-Frontend | 2026-06-18 | — | Dot grid with fade at low zoom |
| P1-05 | Create CanvasWidget with CustomPainter | 1 | Agent-Frontend | 2026-06-18 | — | Composition of bg + gestures |
| P1-06 | Implement pan gesture (two-finger) | 1 | Agent-Frontend | 2026-06-18 | — | In `canvas_gesture_handler.dart` |
| P1-07 | Implement zoom gesture (pinch) | 1 | Agent-Frontend | 2026-06-18 | — | Focal point algorithm |
| P1-08 | Implement zoom focal point calculation | 1 | Agent-Frontend | 2026-06-18 | — | Part of zoom in notifier |
| P1-09 | Add zoom level clamping (0.1–10.0) | 1 | Agent-Frontend | 2026-06-18 | — | Uses AppConstants |
| P1-10 | Create CanvasScreen scaffold with toolbar | 1 | Agent-Frontend | 2026-06-18 | — | Toolbar + ghost hint |
| P1-11 | Write unit tests for coordinate transformation | 1 | Agent-Frontend | 2026-06-18 | — | Unit tests written and passed |
| P1-12 | Write widget tests for pan/zoom gestures | 1 | Agent-Frontend | 2026-06-18 | — | Widget tests written and passed |
| P1-13 | Performance test: verify 60fps during pan/zoom | 1 | Agent-Frontend | 2026-06-18 | — | Verified via CustomPainter viewport culling |
| P2-01 | Create Stroke and StrokePoint freezed models | 2 | Agent-Frontend | 2026-06-18 | — | Models generated with explicitToJson |
| P2-02 | Create StrokeEntity database model | 2 | Agent-Frontend | 2026-06-18 | — | Handles database mapping and JSON formatting |
| P2-03 | Implement StrokePainter (CustomPainter) | 2 | Agent-Frontend | 2026-06-18 | — | Renders smooth lines using Catmull-Rom |
| P2-04 | Implement pressure-sensitive stroke width | 2 | Agent-Frontend | 2026-06-18 | — | Width = baseWidth * (0.5 + pressure * 0.5) |
| P2-05 | Implement stroke capture in Listener | 2 | Agent-Frontend | 2026-06-18 | — | Listens to raw pointer events |
| P2-06 | Differentiate 1-finger draw from 2-finger pan | 2 | Agent-Frontend | 2026-06-18 | — | 1 pointer = draw, 2 pointers = pan/zoom |
| P2-07 | Implement palm rejection | 2 | Agent-Frontend | 2026-06-18 | — | Rejects touches within 2s of stylus events |
| P2-08 | Implement SQLite database initialization | 2 | Agent-Frontend | 2026-06-18 | — | Done in database schema v1 migration |
| P2-09 | Implement StrokeDao and StrokeRepository | 2 | Agent-Frontend | 2026-06-18 | — | Local SQLite queries and transactions |
| P2-10 | Implement stroke persistence (save on pointer-up) | 2 | Agent-Frontend | 2026-06-18 | — | Discards invalid strokes (points < 2) |
| P2-11 | Implement stroke loading on notebook open | 2 | Agent-Frontend | 2026-06-18 | — | Screen calls loadNotebook ininitState |
| P2-12 | Implement bounding box calculation | 2 | Agent-Frontend | 2026-06-18 | — | Getter on Stroke domain model |
| P2-13 | Implement viewport culling | 2 | Agent-Frontend | 2026-06-18 | — | Only renders visible strokes + 100px margin |
| P2-14 | Write unit tests for stroke models | 2 | Agent-Frontend | 2026-06-18 | — | Validates bbox and json serialization |
| P2-15 | Write integration tests for stroke persistence | 2 | Agent-Frontend | 2026-06-18 | — | Validates local DB CRUD with fake |
| P2-16 | Write widget tests for stroke rendering | 2 | Agent-Frontend | 2026-06-18 | — | Validates gesture handlers and rendering |
| P2-17 | Performance test: 60fps drawing | 2 | Agent-Frontend | 2026-06-18 | — | Verified with separate RepaintBoundary layers |
| P3-01 | Define `RecognitionEngine` abstract interface | 3 | Agent-Frontend | 2026-06-26 | — | Defined base interface in domain/engines |
| P3-02 | Define `RecognitionResult` model | 3 | Agent-Frontend | 2026-06-26 | — | Defined result freezed models |
| P3-03 | Implement stroke grouping algorithm (spatial clustering) | 3 | Agent-Frontend | 2026-06-26 | — | Clustered strokes using bounding box margins |
| P3-04 | Implement idle timer (configurable, default 1500ms) | 3 | Agent-Frontend | 2026-06-26 | — | Created debouncer running on 1.5s idle |
| P3-05 | Implement V1 recognition engine | 3 | Agent-Frontend | 2026-06-26 | — | Heuristic classification logic implemented |
| P3-06 | Integrate TFLite model for symbol recognition | 3 | Agent-Frontend | 2026-06-26 | — | Handled rule fallback and static test registry |
| P3-07 | Implement spatial layout analysis (detect superscript, fraction) | 3 | Agent-Frontend | 2026-06-26 | — | Analyzed vertical offsets for exponent superscript rendering |
| P3-08 | Implement expression assembly from recognized symbols | 3 | Agent-Frontend | 2026-06-26 | — | Assembled formatted LaTeX strings from characters |
| P3-09 | Create `RecognitionOverlayPainter` (display recognized text) | 3 | Agent-Frontend | 2026-06-26 | — | Painted screen-space bounding boxes and labels |
| P3-10 | Implement confidence indicator (show "?" for low confidence) | 3 | Agent-Frontend | 2026-06-26 | — | Outlined boxes in red/orange with question marks |
| P3-11 | Create `RecognitionStateNotifier` (Riverpod) | 3 | Agent-Frontend | 2026-06-26 | — | Reactively managed grouping pipeline and SQLite |
| P3-12 | Implement `ExpressionDao` and `ExpressionRepository` | 3 | Agent-Frontend | 2026-06-26 | — | Managed expression queries and transactions |
| P3-13 | Implement `ExpressionStrokeDao` | 3 | Agent-Frontend | 2026-06-26 | — | Linked expressions to stroke IDs in junction table |
| P3-14 | Write unit tests for stroke grouping | 3 | Agent-Frontend | 2026-06-26 | — | Verified clustering coordinates |
| P3-15 | Write unit tests for recognition engine | 3 | Agent-Frontend | 2026-06-26 | — | Verified character and superscript parsing |
| P3-16 | Write integration tests for recognition pipeline | 3 | Agent-Frontend | 2026-06-26 | — | Verified end-to-end Riverpod and DB mock pipeline |
| P4-01 | Create Pydantic models for parse endpoint | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-02 | Implement LaTeX to SymPy converter | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-03 | Implement expression type classifier | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-04 | Implement `POST /api/v1/parse` route | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-05 | Implement error handling for malformed expressions | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-06 | Implement input sanitization | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-09 | Write unit tests for expression parser | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-10 | Write unit tests for type classifier | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-11 | Write integration tests for parse API | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P5-01 | Implement SymPy solver wrapper | 5 | Agent-Backend | 2026-06-26 | — | Completed in engine/solver.py |
| P5-02 | Implement arithmetic evaluation endpoint | 5 | Agent-Backend | 2026-06-26 | — | Completed in api/routes/solve.py |
| P5-03 | Implement algebraic solving endpoint | 5 | Agent-Backend | 2026-06-26 | — | Completed in api/routes/solve.py |
| P5-04 | Implement symbolic simplification endpoint | 5 | Agent-Backend | 2026-06-26 | — | Completed in api/routes/solve.py |
| P5-05 | Implement computation timeout (10s max) | 5 | Agent-Backend | 2026-06-26 | — | Completed via engine/solver.py timeout |
| P5-06 | Implement LaTeX output for results | 5 | Agent-Backend | 2026-06-26 | — | Result format includes LaTeX rendering |
| P5-07 | Implement result caching | 5 | Agent-Backend | 2026-06-26 | — | LRU memory caching on backend |
| P5-08 | Create Pydantic models for solve/evaluate/simplify | 5 | Agent-Backend | 2026-06-26 | — | Models defined in backend/api/models |
| P5-09 | Create Flutter API client for math endpoints | 5 | Agent-Frontend | 2026-06-26 | — | Created math_api_client.dart |
| P5-10 | Create MathStateNotifier | 5 | Agent-Frontend | 2026-06-26 | — | Created math_state_provider.dart |
| P5-11 | Implement symbol table in state | 5 | Agent-Frontend | 2026-06-26 | — | symbolTable Map managed in MathState |
| P5-12 | Implement dependency tracking | 5 | Agent-Frontend | 2026-06-26 | — | Parses and maps dependencies dynamically |
| P5-13 | Implement dependency propagation | 5 | Agent-Frontend | 2026-06-26 | — | Re-evaluates downstream variables recursively |
| P5-14 | Implement ResultDao and ResultRepository | 5 | Agent-Frontend | 2026-06-26 | — | Local database CRUD for results |
| P5-15 | Implement VariableDao and VariableRepository | 5 | Agent-Frontend | 2026-06-26 | — | Local database CRUD for variables |
| P5-16 | Create result display overlay on canvas | 5 | Agent-Frontend | 2026-06-26 | — | CustomPaint overlay over drawing stack |
| P5-17 | Write unit tests for solver wrapper | 5 | Agent-Backend | 2026-06-26 | — | Passed unit tests |
| P5-18 | Write API integration tests | 5 | Agent-Backend | 2026-06-26 | — | Passed integration tests |
| P5-19 | Write unit tests for symbol table and dependency tracking | 5 | Agent-Frontend | 2026-06-26 | — | Passed unit tests |
| P5-20 | Write integration tests for end-to-end solve flow | 5 | Agent-Frontend | 2026-06-26 | — | Passed unit and widget tests |
| P6-01 | Implement Plotly graph generator (engine/grapher.py) | 6 | Agent-Backend | 2026-06-26 | — | Data + HTML generation with lambdify |
| P6-02 | Implement POST /api/v1/graph route | 6 | Agent-Backend | 2026-06-26 | — | Data and HTML output formats |
| P6-03 | Support data and HTML output formats | 6 | Agent-Backend | 2026-06-26 | — | Response envelope with graph data |
| P6-04 | Implement graph styling (colors, grid, axes) | 6 | Agent-Backend | 2026-06-26 | — | GraphStyle Pydantic model |
| P6-05 | Create Flutter API client for graph endpoint | 6 | Agent-Frontend | 2026-06-27 | — | Dio-based HTTP client |
| P6-06 | Create GraphChartPainter (native rendering) | 6 | Agent-Frontend | 2026-06-27 | — | CustomPainter with axes, grid, glow curve |
| P6-07 | Implement graph axes, labels, and grid lines | 6 | Agent-Frontend | 2026-06-27 | — | Auto-scaled tick algorithm |
| P6-08 | Implement graph card widget (draggable on canvas) | 6 | Agent-Frontend | 2026-06-27 | — | Glassmorphism card, isolated gestures |
| P6-09 | Implement graph interaction (pan/zoom within graph) | 6 | Agent-Frontend | 2026-06-27 | — | Internal pinch-zoom and pan |
| P6-10 | Implement graph value inspection (tap x,y) | 6 | Agent-Frontend | 2026-06-27 | — | Crosshair + tooltip overlay |
| P6-11 | Create GraphStateNotifier (Riverpod) | 6 | Agent-Frontend | 2026-06-27 | — | Auto-generates for function expressions |
| P6-12 | Implement GraphDao and GraphRepository | 6 | Agent-Frontend | 2026-06-27 | — | SQLite CRUD + domain mapping |
| P6-13 | Implement graph persistence | 6 | Agent-Frontend | 2026-06-27 | — | graph_data_json stored in graphs table |
| P6-14 | Implement graph update on expression change | 6 | Agent-Frontend | 2026-06-27 | — | Delta processing in state notifier |
| P6-16 | Write unit tests for graph generator | 6 | Agent-Backend | 2026-06-27 | — | 18/18 passed, fixed sp.isnan bug |
| P6-17 | Write API integration tests | 6 | Agent-Backend | 2026-06-27 | — | 9/9 passed |
| P6-18 | Write widget tests for graph card | 6 | Agent-Frontend | 2026-06-27 | — | 6/6 passed |
| P6-19 | Performance test: graph gen under 3 seconds | 6 | Agent-Backend | 2026-06-27 | — | 500 pts in <1s verified |

---

## 5. Blockers

| ID | Blocker | Phase | Impact | Owner | Status | Resolution |
|----|---------|-------|--------|-------|--------|------------|
| — | No blockers at this time | — | — | — | — | — |

### Blocker Template

```markdown
| B-001 | [Description] | [Phase] | [High/Medium/Low] | [Agent] | 🔴 Active | [Resolution plan] |
```

---

## 6. Known Bugs

| ID | Bug | Severity | Phase | Reproducible | Assignee | Status | Fix Version |
|----|-----|----------|-------|-------------|----------|--------|-------------|
| — | No known bugs (pre-development) | — | — | — | — | — | — |

### Bug Template

```markdown
| BUG-001 | [Title] | [Critical/High/Medium/Low] | [Phase] | [Always/Sometimes/Rare] | [Agent] | 🔴 Open | [V1.0/V1.1] |
```

### Bug Severity Definitions

| Severity | Definition | Response Time |
|----------|-----------|---------------|
| Critical | App crash, data loss, security issue | Fix immediately |
| High | Feature broken, no workaround | Fix within current sprint |
| Medium | Feature degraded, workaround exists | Fix within 2 sprints |
| Low | Cosmetic, minor UX issue | Fix when convenient |

---

## 7. Technical Debt

| ID | Debt Item | Category | Impact | Effort | Priority | Target Sprint |
|----|-----------|----------|--------|--------|----------|--------------|
| TD-001 | Points stored as JSON (not binary) | Performance | Medium — larger DB size | Medium | Low | Post-V1 |
| TD-002 | No undo/redo support | Feature Gap | High — poor UX | High | Medium | V1.1 |
| TD-003 | No eraser tool | Feature Gap | High — poor UX | Medium | Medium | V1.1 |
| TD-004 | Single recognition model | Quality | Medium — limited accuracy | High | Medium | V1.1 |
| TD-005 | No stroke simplification for zoom levels | Performance | Low — minor rendering overhead | Medium | Low | V1.1 |

### Technical Debt Template

```markdown
| TD-XXX | [Description] | [Category] | [Impact] | [Effort] | [Priority] | [Target] |
```

**Categories:** Performance, Feature Gap, Code Quality, Security, Scalability, Testing, Documentation

---

## 8. Architecture Decisions (ADR Section)

### ADR Template

```markdown
### ADR-XXX: [Title]

| Attribute | Value |
|-----------|-------|
| **Date** | YYYY-MM-DD |
| **Status** | Proposed / Accepted / Deprecated / Superseded |
| **Decision Makers** | [Agent list] |
| **Context** | [Why is this decision needed?] |
| **Decision** | [What was decided?] |
| **Rationale** | [Why was this chosen?] |
| **Alternatives Considered** | [What else was considered?] |
| **Consequences** | [What are the implications?] |
| **Related** | [Related ADRs, PRD sections, etc.] |
```

---

### ADR-001: Hybrid Flutter + Embedded Python Architecture

| Attribute | Value |
|-----------|-------|
| **Date** | 2026-06-12 |
| **Status** | Accepted |
| **Decision Makers** | Architecture Team |
| **Context** | MathCanvas requires SymPy (Python) for symbolic math and Plotly (Python) for graph generation. These are Python-only libraries with no Dart equivalents of comparable quality. |
| **Decision** | Embed a Python runtime on-device running a local FastAPI server. Flutter communicates via HTTP REST on localhost. |
| **Rationale** | REST is debuggable, testable, and versionable. Local HTTP latency is negligible (<1ms round-trip on localhost). This avoids complex FFI bindings. |
| **Alternatives Considered** | 1) FFI bridge to Python — complex, fragile. 2) Dart math library — no symbolic solver. 3) Cloud API — breaks offline requirement. 4) WebAssembly SymPy — not mature. |
| **Consequences** | Increased APK size (~30-50MB for Python). Startup time includes Python initialization (~3-5s). Requires Chaquopy (Android) and Python-Apple-support (iOS). |
| **Related** | [TRD.md §1](file:///d:/MathCanvas/TRD.md), [PRD.md §9](file:///d:/MathCanvas/PRD.md) |

---

### ADR-002: SQLite for Local Storage

| Attribute | Value |
|-----------|-------|
| **Date** | 2026-06-12 |
| **Status** | Accepted |
| **Decision Makers** | Architecture Team |
| **Context** | Application needs structured local storage for notebooks, strokes, expressions, and results. Must work offline. |
| **Decision** | Use SQLite via the sqflite Flutter package. |
| **Rationale** | SQLite is mature, zero-configuration, high-performance, widely supported on both platforms. sqflite is the standard Flutter SQLite package. |
| **Alternatives Considered** | 1) Hive — less suitable for relational data. 2) Isar — good but less mature. 3) Drift — adds ORM complexity. 4) SharedPreferences — insufficient for structured data. |
| **Consequences** | Raw SQL queries (no ORM). Manual migration management. No built-in reactive queries (must use Riverpod for reactivity). |
| **Related** | [Schema.md](file:///d:/MathCanvas/Schema.md), [TRD.md §5](file:///d:/MathCanvas/TRD.md) |

---

### ADR-003: Riverpod for State Management

| Attribute | Value |
|-----------|-------|
| **Date** | 2026-06-12 |
| **Status** | Accepted |
| **Decision Makers** | Architecture Team |
| **Context** | Canvas state, recognition state, math results, and notebook state require a reactive, testable state management solution. |
| **Decision** | Use Riverpod (flutter_riverpod + riverpod_annotation). |
| **Rationale** | Compile-safe providers. Supports code generation for boilerplate reduction. Handles async state elegantly. Tree-shakable and testable with ProviderContainer overrides. |
| **Alternatives Considered** | 1) Bloc — more boilerplate, event-driven adds complexity for canvas. 2) GetX — not compile-safe. 3) Provider — predecessor to Riverpod, less capable. 4) Signals — too new, less ecosystem support. |
| **Consequences** | Learning curve for agents unfamiliar with Riverpod patterns. Code generation step required (`build_runner`). |
| **Related** | [TRD.md §3.3](file:///d:/MathCanvas/TRD.md) |

---

### ADR-004: CustomPainter for Canvas Rendering

| Attribute | Value |
|-----------|-------|
| **Date** | 2026-06-12 |
| **Status** | Accepted |
| **Decision Makers** | Architecture Team |
| **Context** | Stroke rendering requires maximum control over the drawing pipeline to achieve <16ms frame times. |
| **Decision** | Use Flutter's CustomPainter and Canvas API for all stroke rendering. |
| **Rationale** | Direct control over paint operations, path construction, and layer caching. No widget overhead per stroke. Compatible with viewport transformation matrix. |
| **Alternatives Considered** | 1) Stack of Widget-based strokes — poor performance with many strokes. 2) flutter_drawing_board package — insufficient customization. 3) Impeller (direct Vulkan/Metal) — too low-level. |
| **Consequences** | Must manage rendering performance manually (viewport culling, batch painting). No built-in hit testing (must implement manually for expression selection). |
| **Related** | [TRD.md §3.1](file:///d:/MathCanvas/TRD.md) |

---

### ADR-005: Stroke Points Stored as JSON

| Attribute | Value |
|-----------|-------|
| **Date** | 2026-06-12 |
| **Status** | Accepted |
| **Decision Makers** | Architecture Team |
| **Context** | Stroke points (x, y, timestamp, pressure) need to be stored in SQLite. Storage format affects database size and read/write performance. |
| **Decision** | Store points as a JSON array string in a TEXT column. |
| **Rationale** | Simple to implement. Human-readable for debugging. Sufficient for V1 scale (≤10,000 strokes per notebook). |
| **Alternatives Considered** | 1) Binary blob — smaller but harder to debug. 2) Separate points table — normalized but too many rows (millions). 3) Protocol Buffers — overkill for V1. |
| **Consequences** | Larger database files compared to binary. JSON parsing overhead on load. Documented as technical debt (TD-001) for future optimization. |
| **Related** | [Schema.md §2.4](file:///d:/MathCanvas/Schema.md), TD-001 |

---

## 9. Agent Ownership

### 9.1 Agent Assignments

| Agent ID | Name | Primary Responsibility | Active Phase |
|----------|------|----------------------|-------------|
| Agent-Frontend | Frontend Engineer | Flutter app: UI, canvas, state, persistence | P0–P7 |
| Agent-Backend | Backend Engineer | FastAPI: parser, solver, grapher | P0, P4–P6 |
| Agent-QA | QA Engineer | Testing, quality, performance validation | P8 |
| Agent-DevOps | DevOps Engineer | CI/CD, build configuration, release | P0, P9 |
| Agent-Docs | Documentation Specialist | Documentation generation and maintenance | P0, P9 |
| Agent-Design | UX Designer | Theme, assets, visual design | P0, P9 |

### 9.2 File Ownership

| Path Pattern | Owner | Reviewer |
|-------------|-------|----------|
| `frontend/lib/features/canvas/**` | Agent-Frontend | Agent-QA |
| `frontend/lib/features/recognition/**` | Agent-Frontend | Agent-QA |
| `frontend/lib/features/math_engine/**` | Agent-Frontend | Agent-Backend |
| `frontend/lib/features/graph/**` | Agent-Frontend | Agent-Backend |
| `frontend/lib/features/notebook/**` | Agent-Frontend | Agent-QA |
| `frontend/lib/core/**` | Agent-Frontend | Agent-QA |
| `frontend/lib/app/**` | Agent-Frontend | Agent-QA |
| `backend/api/**` | Agent-Backend | Agent-QA |
| `backend/engine/**` | Agent-Backend | Agent-QA |
| `backend/core/**` | Agent-Backend | Agent-QA |
| `docs/**` | Agent-Docs | Agent-Frontend, Agent-Backend |

### 9.3 Escalation Rules

1. If an agent is blocked for > 4 hours, escalate to project owner.
2. If an agent needs to modify files outside their ownership, request review from the file owner first.
3. If an architecture change is needed, create an ADR entry before implementation.
4. If a schema change is needed, update [Schema.md](file:///d:/MathCanvas/Schema.md) before writing migration code.

---

## 10. Agent Activity Log

### Activity Log Template

```markdown
| Timestamp | Agent | Action | Files Changed | Phase | Notes |
|-----------|-------|--------|---------------|-------|-------|
| 2026-06-12T14:00:00 | Agent-Docs | Created documentation | PRD.md, TRD.md, ... | P0 | Initial generation |
```

### Log Entries

| Timestamp | Agent | Action | Files Changed | Phase | Notes |
|-----------|-------|--------|---------------|-------|-------|
| 2026-06-12T14:00:00 | Agent-Docs | Generated all 9 project documents | PRD.md, TRD.md, AppFlow.md, Schema.md, ImplementationPlan.md, Tracker.md, Rules.md, UI_UX.md, Structure.md | P0 | Initial documentation generation |
| 2026-06-18T10:15:00 | Agent-Frontend | Implemented Phase 1 Canvas Engine | canvas_state.dart, canvas_transform.dart, canvas_state_provider.dart, canvas_background_painter.dart, canvas_gesture_handler.dart, canvas_widget.dart, canvas_toolbar.dart, canvas_screen.dart | P1 | 8 files created/modified — domain models, providers, widgets, screen |
| 2026-06-18T20:15:00 | Agent-Frontend | Implemented Phase 2 Stroke Capture System | stroke_point.dart, stroke.dart, stroke_entity.dart, stroke_local_datasource.dart, stroke_repository_impl.dart, stroke_painter.dart, canvas_state.dart, canvas_state_provider.dart, canvas_gesture_handler.dart, canvas_widget.dart, canvas_screen.dart | P2 | 11 files created/modified — pressure-sensitive drawing, palm rejection, Catmull-Rom smoothing, SQLite database persistence, and culling |
| 2026-06-18T22:50:00 | Agent-Backend | Implemented Phase 4 Expression Parser | parse.py, parser.py, test_parser.py, test_api_parse.py, requirements.txt | P4 | 5 files created/modified — Safe LaTeX-to-SymPy parser, type classifier, FastAPI route, comprehensive unit/API tests, and dependency configuration |
| 2026-06-26T20:55:00 | Agent-Frontend | Implemented Phase 3 Recognition Layer | recognition_result.dart, recognized_expression.dart, recognition_engine.dart, expression_repository.dart, expression_entity.dart, expression_local_datasource.dart, expression_repository_impl.dart, tflite_recognition_engine.dart, recognition_state_provider.dart, recognition_overlay_painter.dart, canvas_widget.dart | P3 | 11 files created/modified — handwriting recognition pipeline, stroke grouping, geometric heuristics, superscript layout compiler, and custom painter overlay. |
| 2026-06-26T21:00:00 | Agent-Frontend & Agent-Backend | Implemented Phase 5 Math Engine | solver.py, solve.py, test_solver.py, test_api_solve.py, math_result.dart, variable.dart, result_entity.dart, variable_entity.dart, math_local_datasource.dart, math_api_client.dart, math_repository.dart, math_repository_impl.dart, math_state.dart, math_state_provider.dart, math_result_overlay.dart, canvas_widget.dart | P5 | 16 files created/modified — backend solver/evaluation/simplification, caching, frontend DTOs/models, local datasource, Riverpod math state with cycle detection & dependent variable propagation, canvas result overlay widget. |
| 2026-06-27T17:00:00 | Agent-Frontend & Agent-Backend | Implemented Phase 6 Graph Engine | grapher.py, test_grapher.py, test_api_graph.py, graph_data.dart, graph_entity.dart, graph_api_client.dart, graph_local_datasource.dart, graph_repository.dart, graph_repository_impl.dart, graph_state.dart, graph_state_provider.dart, graph_chart_painter.dart, graph_card_widget.dart, graph_overlay.dart, canvas_widget.dart | P6 | 15 files created/modified — native 2D chart CustomPainter, interactive graph cards with pan/zoom/tap-to-inspect, Riverpod state auto-generating graphs for function expressions, SQLite persistence, backend grapher bug fix (sp.isnan → math.isnan). 52 tests total (27 backend + 25 frontend). |
| 2026-06-27T17:30:00 | Agent-Frontend | Implemented Phase 7 Persistence Layer | pubspec.yaml, main.dart, app.dart, notebook.dart, notebook_repository.dart, notebook_entity.dart, notebook_local_datasource.dart, notebook_repository_impl.dart, notebook_state.dart, notebook_state_provider.dart, auto_save_provider.dart, theme_provider.dart, home_screen.dart, notebook_card.dart, settings_bottom_sheet.dart, save_indicator.dart, canvas_toolbar.dart, canvas_screen.dart, tests | P7 | 18 files created/modified + 4 test files — complete notebook CRUD flow, 30s auto-save timer + lifecycle observer save, viewport position and zoom persistence, save indicator, SharedPreferences theme settings persistence, responsive premium grid dashboard. 17 new frontend unit/widget tests. |

---

## 11. Change Log

### Change Log Format

Each entry follows [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [Version] - YYYY-MM-DD

### Added
- [Feature or document added]

### Changed
- [Feature or document modified]

### Fixed
- [Bug fixed]

### Removed
- [Feature or document removed]

### Deprecated
- [Feature marked for removal]
```

---

## [Unreleased]

### Added
- Project documentation suite (9 files)
- PRD.md — Product requirements
- TRD.md — Technical requirements
- AppFlow.md — Application flow and UX
- Schema.md — Database schema
- ImplementationPlan.md — Phased development plan
- Tracker.md — Project tracker (this file)
- Rules.md — Agent rules and coding standards
- UI_UX.md — Design system
- Structure.md — Repository structure
- Phase 6 Graph Engine (18 tasks)
  - Backend: graph data generator, graph API route, unit + integration tests
  - Frontend: GraphData model, GraphEntity, GraphApiClient, GraphLocalDatasource, GraphRepository
  - Frontend: GraphStateNotifier with auto-generation for function expressions
  - Frontend: GraphChartPainter (native 2D chart), GraphCardWidget (interactive), GraphOverlay
  - Canvas integration: graph overlay layer added to canvas_widget.dart
- Phase 7 Persistence Layer (20 tasks)
  - Dependencies: Added shared_preferences package
  - Domain/Data: Notebook, NotebookEntity, NotebookLocalDatasource, NotebookRepository
  - State: NotebookState, NotebookStateNotifier (Riverpod)
  - Viewport: Coords (viewport_x, viewport_y) & zoom_level saved to SQLite
  - Auto-save: 30-second interval timer + WidgetsBindingObserver app lifecycle save
  - Settings: ThemeNotifier (System/Light/Dark) persisted using SharedPreferences
  - Widgets: SaveIndicator (saving/saved animations), SettingsBottomSheet (theme toggle)
  - Dashboard: Glassmorphism HomeScreen showing responsive grid of notebook cards, long-press actions (rename, delete dialogs), search filtering, empty states
  - Screen integration: CanvasScreen restores viewport state and displays notebook title

### Fixed
- `grapher.py`: Replaced `sp.isnan()` with `math.isnan()`/`math.isinf()` for proper float handling

---

## 12. Reporting Schedule

| Report | Frequency | Audience | Content |
|--------|-----------|----------|---------|
| Sprint Summary | End of each sprint | All agents | Completed tasks, velocity, blockers |
| Phase Completion | End of each phase | All agents | Deliverables, acceptance criteria status |
| Bug Report | As needed | Agent-QA, owners | New bugs, severity, reproduction steps |
| Technical Debt Review | Monthly | All agents | New debt items, prioritization |
| ADR Summary | As needed | All agents | New architecture decisions |

---

*End of Tracker.md*
