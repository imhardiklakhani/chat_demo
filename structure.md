# Architecture & Folder Structure

## Architecture Overview

- **Feature-based architecture**
  - All modules live under `lib/features`
  - Each feature is isolated and independent
  - No direct dependency between features

- **Layered structure per feature**
  - `presentation` → UI + Cubit (state only)
  - `data` → API calls, models, repositories
  - UI never accesses API directly

- **Cubit (Bloc) state management**
  - One Cubit per page / tab
  - Cubit manages only UI state (loading, success, error)
  - Prevents tab rebuild and scroll interference issues

- **Repository pattern**
  - Cubits call repositories, not APIs
  - Repositories handle data fetching and parsing
  - Data source can change without UI impact

- **Core utilities**
  - Located under `lib/core`
  - Shared networking, API clients, navigation, constants
  - Used across all features

- **Shared UI widgets**
  - Located under `lib/shared_widgets`
  - Reusable stateless UI components
  - Ensures UI consistency and avoids duplication

---

## Folder Structure

```
lib/
├── core/
│   ├── api/
│   ├── constants/
│   ├── navigation/
│   └── network/
├── features/
│   ├── app_shell/
│   │   └── presentation/
│   │       └── pages/
│   ├── chat/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repository/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   ├── history/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repository/
│   │   └── presentation/
│   │       ├── cubit/
│   │       └── pages/
│   ├── home/
│   │   └── presentation/
│   │       ├── cubit/
│   │       └── pages/
│   └── users/
│       ├── data/
│       │   └── models/
│       └── presentation/
│           ├── cubit/
│           └── pages/
├── shared_widgets/
└── main.dart
```

---

## Layer Interaction

- **Presentation Layer**
  - Handles UI rendering
  - Listens to Cubit state
  - Triggers data fetch via Cubit

- **Cubit**
  - Holds screen-level state
  - Calls repository methods
  - Emits UI states only

- **Data Layer**
  - Handles API calls
  - Parses responses
  - Returns formatted data to Cubit

---
