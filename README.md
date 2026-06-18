# MathCanvas

MathCanvas is a mobile-first mathematical workspace that combines natural handwriting input, real-time expression recognition, symbolic math solving (evaluating equations, algebraic solving, symbolic simplification), and interactive graphing into a single, seamless, offline-first experience.

## Project Structure

The project is structured as a monorepo containing both the frontend and backend applications:

```text
MathCanvas/
├── frontend/             # Flutter application (Dart)
├── backend/              # FastAPI application (Python)
├── docs/                 # Project architecture and requirements documentation
├── .github/              # GitHub configurations & CI/CD workflows
├── .gitignore            # Git ignore rules for both frontend and backend
└── README.md             # This file
```

---

## Backend Setup (FastAPI)

The backend provides mathematical computation via **SymPy** and graph plotting data via **Plotly**.

### Prerequisites
- Python 3.11 or higher
- `pip` (Python package manager)

### Installation & Run

1. Navigate to the `backend/` directory:
   ```bash
   cd backend
   ```

2. Create a virtual environment:
   ```bash
   python -m venv .venv
   ```

3. Activate the virtual environment:
   - **Windows (PowerShell):**
     ```powershell
     .\.venv\Scripts\Activate.ps1
     ```
   - **macOS / Linux:**
     ```bash
     source .venv/bin/activate
     ```

4. Install the dependencies:
   ```bash
   pip install -r requirements.txt
   ```

5. Start the FastAPI server using Uvicorn:
   ```bash
   uvicorn main:app --host 127.0.0.1 --port 8400 --reload
   ```

6. Verify the server is running by opening:
   - Health check: [http://127.0.0.1:8400/health](http://127.0.0.1:8400/health) (should return `{"status": "ready"}`)
   - API docs (Swagger UI): [http://127.0.0.1:8400/docs](http://127.0.0.1:8400/docs)

---

## Frontend Setup (Flutter)

The frontend is built with **Flutter** and communicates with the local FastAPI server over `localhost:8400`.

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / Xcode (for mobile development)

### Installation & Run

1. Navigate to the `frontend/` directory:
   ```bash
   cd frontend
   ```

2. Fetch pub dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (required for Riverpod providers and Freezed models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the application:
   ```bash
   flutter run
   ```

### Code Guidelines & Standards
- Code formatting is enforced using `dart format` (frontend) and `black` (backend).
- Code linting is configured via `analysis_options.yaml` (frontend) and `pyproject.toml` (backend).
- For complete developer rules and coding standards, refer to [docs/Rules.md](docs/Rules.md).
