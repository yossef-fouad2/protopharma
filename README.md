# 💊 Protopharma

Protopharma is a state-of-the-art, premium full-stack Pharmacy Management System. It features a cross-platform mobile client built with **Flutter** and a robust, secure REST API backend built with **Node.js, Express, TypeScript, and PostgreSQL**.

---

## 📂 Project Structure

This repository is organized as a clean Monorepo:

```text
protopharma/ (Repository Root)
├── backend/            # Express, TypeScript, and Drizzle ORM backend server
│   ├── src/
│   │   ├── db/         # Database connection pool & Drizzle schemas
│   │   ├── routes/     # Express route handlers (Authentication, etc.)
│   │   └── index.ts    # Main entry point for the REST API
│   ├── Dockerfile
│   └── docker-compose.yml
│
└── frontend/           # Cross-platform Flutter mobile client
    ├── lib/
    │   ├── core/       # Global configuration, themes, typography, routing
    │   ├── data/       # Drift local SQLite database & Firestore interfaces
    │   └── features/   # Feature modules (Drugs, Home, Inventory, Navigation)
    └── test/           # Widget & unit test suite
```

---

## 🎨 Design System & Aesthetics (Frontend)
The frontend client has been crafted with premium, modern UI/UX design patterns:
* **Custom Typography:** Incorporates elegant fonts like **Cairo** (for arabic/headers) and **Outfit / Poppins** for clean visual styling.
* **Themes:** Supports system-matched light and dark modes out-of-the-box.
* **Component-Driven Layouts:** A dedicated sidebar navigation (`SideNavBar`) coupled with dynamic data tables (`DisplayTable`) and pagination bars.

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
* [Node.js](https://nodejs.org/) (v18+)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) (optional, for database & backend)
* PostgreSQL database instance (if running local backend without Docker)

---

## 🖥️ Backend Service (`backend/`)

The backend is built as a modular REST API using **Express** and type-safe schema mappings with **Drizzle ORM**.

### Technologies Used
* **Express.js (v5)** - Fast, unopinionated web framework.
* **Drizzle ORM** - Next-gen TypeScript ORM mapping database tables to type-safe interfaces.
* **pg (node-postgres)** - Non-blocking PostgreSQL client pool.
* **Crypto (Scrypt)** - Native cryptographic hashing for secure PINs.

### Local Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Ensure PostgreSQL is running on your machine and database URL is set properly in `src/db/index.ts`.
4. Run the development server (runs nodemon with `ts-node` ESM loader):
   ```bash
   npm run dev
   ```

### Docker Setup
The backend includes a pre-configured `docker-compose.yml` to spin up a PostgreSQL instance alongside the Express server container:
```bash
cd backend
docker compose up --build
```
This runs:
* Express server on `http://localhost:8000`
* PostgreSQL instance on `localhost:5432` (database: `drugdb`, user: `postgres`)

### API Endpoints
* `GET /` — Greet index page.
* `GET /auth` — Greet authentication index.
* `POST /auth/signup` — Registers a new user. Expects JSON:
  ```json
  {
    "username": "jane_doe",
    "fullName": "Jane Doe",
    "pin": "1234",
    "role": "pharmacist"
  }
  ```
  *(Note: `pin` must be exactly a 4-digit numeric string. It is securely hashed using `scrypt` salt-hashing).*

---

## 📱 Frontend Application (`frontend/`)

The frontend application provides a sleek cross-platform user experience for pharmacy workers, caching and loading drugs data locally.

### Key Components
* **Local Offline Storage:** Powered by [Drift](https://drift.simonbinder.eu/) (SQLite) to perform fast lookups, edits, and cached views.
* **Cloud Sync:** Syncs state and data with Google Cloud Firestore.
* **State Management:** Uses `flutter_bloc` for clean, predictable event flows (e.g. `InventoryCubit`).
* **Routing & Dependency Injection:** Powered by `get` (GetX navigation and dependency bindings).

### Running Locally
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

### Static Analysis
Ensure code cleanliness and style compliance:
```bash
flutter analyze
```

### Running Tests
Execute widget and unit tests:
```bash
flutter test
```
*(The test suite simulates local SQLite instances and uses `FakeFirebaseFirestore` for mocking database sync behavior).*

---

## 🔬 Quality Assurance & Testing

Both projects maintain rigorous testing:
* **TypeScript Typechecking:** The backend uses strict TypeScript compilation (`npx tsc --noEmit`).
* **Flutter Widget Testing:** Fully mocked database layers ensure high testing reliability without requiring live Firebase or SQLite database environments during test phases.
