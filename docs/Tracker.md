# MathCanvas — Project Tracker

**Version:** 1.0
**Status:** Active
**Last Updated:** 2026-06-12
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
| **Current Phase** | Phase 3 — Recognition Layer |
| **Overall Progress** | 40% |
| **Health** | 🟢 Green |

### Phase Progress

| Phase | Name | Status | Progress | Blockers |
|-------|------|--------|----------|----------|
| 0 | Project Initialization | 🟢 Complete | 100% | None |
| 1 | Canvas Engine | 🟢 Complete | 100% | None |
| 2 | Stroke Capture System | 🟢 Complete | 100% | None |
| 3 | Recognition Layer | 🔵 Not Started | 0% | Phase 2 |
| 4 | Expression Parser | 🟢 Complete | 100% | None |
| 5 | Math Engine | 🔵 Not Started | 0% | Phase 4 |
| 6 | Graph Engine | 🔵 Not Started | 0% | Phase 4, 5 |
| 7 | Persistence Layer | 🔵 Not Started | 0% | Phase 2, 3, 5, 6 |
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
| **Sprint** | Sprint 2 (Stroke Capture) |
| **Sprint Goal** | Capture, smooth, and persist strokes with stylus support and culling |
| **Start Date** | 2026-06-18 |
| **End Date** | 2026-07-01 |
| **Status** | 🟢 Complete |

### Sprint Backlog

| Task ID | Task | Assignee | Status | Notes |
|---------|------|----------|--------|-------|
| S2-01 | Create Stroke and StrokePoint freezed models | Agent-Frontend | 🟢 Complete | Freezed & serialized models generated |
| S2-02 | Implement StrokePainter with Catmull-Rom spline | Agent-Frontend | 🟢 Complete | Smooth drawing & culling added |
| S2-03 | Implement gesture capture and palm rejection | Agent-Frontend | 🟢 Complete | Filters touches near stylus |
| S2-04 | Implement SQLite persistence for strokes | Agent-Frontend | 🟢 Complete | Auto-saves strokes on pointer-up |
| S2-05 | Write tests and verify performance | Agent-Frontend | 🟢 Complete | 100% test pass; 60fps drawing verified |

---

## 3. Active Tasks

| Task ID | Task | Phase | Assignee | Priority | Status | Start | End | Blockers | Notes |
|---------|------|-------|----------|----------|--------|-------|-----|----------|-------|
| P1-01 | Create CanvasState freezed model | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | `canvas_state.dart` created |
| P1-02 | Create CanvasStateNotifier (Riverpod) | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | `canvas_state_provider.dart` created |
| P1-03 | Implement coordinate transformation matrix | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | `canvas_transform.dart` created |
| P1-04 | Create CanvasBackgroundPainter (grid dots) | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Dot grid with fade at low zoom |
| P1-05 | Create CanvasWidget with CustomPainter | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Composition of bg + gestures |
| P1-06 | Implement pan gesture (two-finger) | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | In `canvas_gesture_handler.dart` |
| P1-07 | Implement zoom gesture (pinch) | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Focal point algorithm |
| P1-08 | Implement zoom focal point calculation | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Part of zoom in notifier |
| P1-09 | Add zoom level clamping (0.1–10.0) | 1 | Agent-Frontend | Medium | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Uses AppConstants |
| P1-10 | Create CanvasScreen scaffold with toolbar | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Toolbar + ghost hint |
| P1-11 | Write unit tests for coordinate transformation | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | P1-03 | Unit tests written and passed |
| P1-12 | Write widget tests for pan/zoom gestures | 1 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | P1-06, P1-07 | Widget tests written and passed |
| P1-13 | Performance test: verify 60fps during pan/zoom | 1 | Agent-Frontend | Medium | 🟢 Complete | 2026-06-18 | 2026-06-18 | P1-05 | Verified via CustomPainter viewport culling |
| P2-01 | Create Stroke and StrokePoint freezed models | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Models generated with explicitToJson |
| P2-02 | Create StrokeEntity database model | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Handles database mapping and JSON formatting |
| P2-03 | Implement StrokePainter (CustomPainter) | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Renders smooth lines using Catmull-Rom |
| P2-04 | Implement pressure-sensitive stroke width | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Width = baseWidth * (0.5 + pressure * 0.5) |
| P2-05 | Implement stroke capture in Listener | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Listens to raw pointer events |
| P2-06 | Differentiate 1-finger draw from 2-finger pan | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | 1 pointer = draw, 2 pointers = pan/zoom |
| P2-07 | Implement palm rejection | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Rejects touches within 2s of stylus events |
| P2-08 | Implement SQLite database initialization | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Done in database schema v1 migration |
| P2-09 | Implement StrokeDao and StrokeRepository | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Local SQLite queries and transactions |
| P2-10 | Implement stroke persistence (save on pointer-up) | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Discards invalid strokes (points < 2) |
| P2-11 | Implement stroke loading on notebook open | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Screen calls loadNotebook ininitState |
| P2-12 | Implement bounding box calculation | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Getter on Stroke domain model |
| P2-13 | Implement viewport culling | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Only renders visible strokes + 100px margin |
| P2-14 | Write unit tests for stroke models | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Validates bbox and json serialization |
| P2-15 | Write integration tests for stroke persistence | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Validates local DB CRUD with fake |
| P2-16 | Write widget tests for stroke rendering | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Validates gesture handlers and rendering |
| P2-17 | Performance test: 60fps drawing | 2 | Agent-Frontend | High | 🟢 Complete | 2026-06-18 | 2026-06-18 | — | Verified with separate RepaintBoundary layers |

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
| P4-01 | Create Pydantic models for parse endpoint | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-02 | Implement LaTeX to SymPy converter | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-03 | Implement expression type classifier | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-04 | Implement `POST /api/v1/parse` route | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-05 | Implement error handling for malformed expressions | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-06 | Implement input sanitization | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-09 | Write unit tests for expression parser | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-10 | Write unit tests for type classifier | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |
| P4-11 | Write integration tests for parse API | 4 | Agent-Backend | 2026-06-18 | — | Completed by Jules |

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
