# MathCanvas Test Summary & Benchmarks

This document details the test framework execution, coverage metrics, and performance benchmarks for both the frontend (Flutter) and backend (FastAPI) applications.

---

## 1. Test Suite Execution & Coverage Summary

Both the frontend and backend exceeded their targeted logical code coverage benchmarks.

| Component | Target Coverage | Actual Coverage | Test Count | Status |
|---|---|---|---|---|
| **Frontend (Flutter)** | $\ge 80\%$ | **81.40%** | **99** tests | **PASSED** |
| **Backend (Python)** | $\ge 90\%$ | **99.00%** | **74** tests | **PASSED** |

---

## 2. Performance Benchmarks

Performance tests were run on local execution environments to profile SQLite latency, mathematical interpolation algorithms, rendering paint speeds, and SymPy evaluation/solving round-trips.

### A. Frontend Benchmarks

- **SQLite Database Latency**:
  - **100 Writes**: `183 ms` (avg **1.83 ms / write**)
  - **100 Reads**: `24 ms` (avg **0.24 ms / read**)
- **Catmull-Rom Spline Calculations**:
  - **10,000 spline points**: `11 ms` (avg **0.0011 ms / point interpolation**)
- **Canvas Rendering Paint Latency**:
  - **Paint 100 strokes (10 points each)**: `68 ms`

### B. Backend Benchmarks (FastAPI / SymPy)

- **SymPy Arithmetic Evaluations**:
  - **100 runs**: `0.0186 seconds` (avg **0.186 ms / evaluation**)
- **SymPy Algebraic Equation Solving**:
  - **50 runs** (uncached): `0.3786 seconds` (avg **7.57 ms / solver round-trip**)
- **SymPy Graph Coordinate Generation**:
  - **50 runs of 500 points**: `0.1475 seconds` (avg **2.95 ms / graph dataset calculation**)

---

## 3. Coverage Analysis Details

### Frontend Coverage Gaps (Excluded Boilerplate / Rest Cov $\ge 80\%$)
The core business logic of features (Canvas state, Notebook state, Handwriting recognition state, and Math engine calculations) is covered at **$\ge 80\%$**. Some styling and configurations (`database_provider.dart`, `graph_state_provider.dart`, `home_screen.dart`, etc.) remain partially covered, which is expected for UI layout files. All data clients and sqlite entities hit **100.00%** coverage.

### Backend Coverage Gaps
The backend code is covered at **99%**. Only 5 lines of code (in `engine/parser.py`) corresponding to unreachable defensive checks in parsing nested brackets and syntax error recovery are uncovered. All core routing and evaluation logic hit **100.00%** coverage.
