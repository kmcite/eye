# Flutter Project File Structure (MVVM)

## File Structure

```
lib/
├── models/          // Core data models (e.g., user.dart, auth_token.dart)
├── repositories/    // Data access & business logic (e.g., authentication_repository.dart, user_repository.dart)
├── features/        // Feature-specific code
│   ├── feature_1/
│   │   ├── views/       // UI screens (e.g., login_view.dart)
│   │   ├── viewmodels/  // UI logic (e.g., login_viewmodel.dart)
│   │   ├── widgets/     // Reusable components (e.g., custom_button.dart)
│   │   └── models/      // Feature-specific data (e.g., login_model.dart)
│   ├── feature_2/
│   │   ├── views/
│   │   └── viewmodels/
├── utils/           // Shared utilities (navigator.dart, constants.dart, api.dart, theme.dart, helpers.dart)
├── config/          // App configuration (app_config.dart)
└── main.dart        // App entry point
```

## Summary

- **models:** Contains reusable data entities.
- **repositories:** Encapsulates data sources and business rules.
- **features:** Organizes feature-specific UI, state logic, and models.
- **utils:** Centralized helpers and theming.
- **config:** Environment and app settings.
- **main.dart:** Initializes dependencies, navigation, and theming.

## Directory Explanation

### 1. models/ - Root-Level Models

**Purpose:** Contains core data models representing application entities.

**Examples:**

- `user.dart`: Represents a user with fields like id, name, and email.
- `auth_token.dart`: Manages authentication sessions.

### 2. repositories/ - Root-Level Repositories

**Purpose:** Manages data access and business logic by abstracting data sources.

**Examples:**

- `authentication_repository.dart`: Handles authentication tasks.
- `user_repository.dart`: Manages user-specific operations.

### 3. features/ - Feature-Specific Code

**Purpose:** Contains feature-specific code organized into subdirectories.

#### feature_1/

- **views:** UI screens (e.g., `login_view.dart`).
- **viewmodels:** UI logic (e.g., `login_viewmodel.dart`).
- **widgets:** Reusable components (e.g., `custom_button.dart`).
- **models:** Feature-specific data (e.g., `login_model.dart`).

#### feature_2/

- Structure similar to feature_1.

### 4. utils/ - Shared Resources

**Purpose:** Contains shared utilities and resources for the entire application.

**Examples:**

- `navigator.dart`: Central navigation logic.
- `constants.dart`: App-wide constants.
- `api.dart`: API configuration.
- `theme.dart`: Application theme definitions.
- `helpers.dart`: General helper functions.

### 5. config/ - Configuration Files

**Purpose:** Contains configuration settings separated from code.

**Examples:**

- `app_config.dart`: Environment settings.

### 6. main.dart - Application Entry Point

**Purpose:** Initializes the Flutter app, configures dependencies, sets up routing, and applies themes.

**Responsibilities:**

- Configure repositories.
- Set up navigation and routing.
- Apply theming.
- Initialize dependency injection.

## Benefits of This Structure

- **Simplified Organization:** Clear structure reduces complexity.
- **Scalability:** Easy addition of new features.
- **Reusability:** Shared models and repositories used across features.
- **Modularity:** Self-contained modules ease maintenance and testing.
- **Maintainability:** Updates and debugging remain localized.
- **Testability:** Facilitates unit and integration testing via isolated viewmodels.
- **Clear Separation of Concerns:** Distinct roles for models, views, viewmodels, and repositories.
