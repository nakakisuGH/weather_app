# CLAUDE.md

## Project
Flutter weather app built as a technical challenge.
Uses the AccuWeather API (city search and current conditions) and follows a provided Figma design.

## Product decisions
See the "Technical decisions and assumptions" section in README.md. Follow them strictly.

## Architecture (Clean Architecture, feature-first)
- `lib/features/weather/domain/`: entities, repository contracts (abstract
  classes) and use cases. Pure Dart: no Flutter, no Dio imports.
- `lib/features/weather/data/`: models (DTOs with fromJson), remote
  datasource (Dio) and repository implementations.
- `lib/features/weather/presentation/`: BLoC, screens and widgets.
- `lib/core/`: shared code (errors/failures, network/Dio setup).
- Dependencies point inward: presentation -> domain <- data.
  `domain` never imports from `data` or `presentation`.

## State management
- Use flutter_bloc (Bloc with events and states). Never use setState for API calls.
- Every async screen handles 4 states: Initial, Loading, Success, Error
  (Error must offer a Retry action).

## Code rules
- Strict null safety: never use `!` on API data. Use `?.`, `??` and default values.
- Network errors are caught in the datasource and mapped to `AppError`s:
  timeout, no connection, 400, 401 (invalid API key), 404, 500.
- Use `ListView.builder` for dynamic lists.
- Use `const` constructors whenever possible.
- Responsive layouts: no hardcoded screen sizes; use `LayoutBuilder`,
  `MediaQuery`, `Expanded`/`Flexible`.
- Typography: Work Sans, bundled in assets/fonts/. Colors and text styles live in a shared theme (`lib/core/theme/`), never inline magic values in widgets.
- Images/illustrations not yet available use Material icons as placeholders,
  isolated in a single widget so they can be replaced later.
- Follow Effective Dart: snake_case files, UpperCamelCase classes, lowerCamelCase members.
- One public class per file. Single Responsibility Principle.
- The API key is never hardcoded. Read it with
  `String.fromEnvironment('ACCUWEATHER_API_KEY')` (provided via env.json).

## Testing
- Unit tests for repositories, use cases and BLoC using mocktail and bloc_test.
- Never call the real API in tests.
- Widget tests for loading, success and error states.

## Git
- Conventional Commits: feat:, fix:, test:, docs:, refactor:, chore:.
- One branch per feature (feature/...), merged into main.

## AI assistant workflow
- Work in small, incremental steps. Change only what was asked.
- Before writing code, briefly explain the plan and the reasoning behind it.
- Explain non-obvious decisions and Flutter/Dart concepts used.
- Ask before adding new dependencies or changing the folder structure.
- Never write or print the real API key.