# Architecture & Folder Structure

## Architecture Overview

- **Feature-based modules** under `lib/features`, each split into `data` and `presentation` layers.
- **Cubit (Bloc)** state management for UI state.
- **Repository pattern** in data layer for API interactions.
- **Core utilities** in `lib/core` (constants, networking, navigation, API clients).
- **Shared UI widgets** in `lib/shared_widgets`.

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
