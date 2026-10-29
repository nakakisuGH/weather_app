# WeatherForemost

A Flutter weather app where users save their favorite cities and see the current weather for each one. Built with Clean Architecture, BLoC and the AccuWeather API, following the provided Figma design.

## Features

- **Saved cities list** on the Home screen, with an empty state when there are no cities yet.
- **Add City** bottom sheet (opened from the floating action button) with:
  - City search with autocomplete suggestions from AccuWeather.
  - Required description field.
  - "Save City" button enabled only when a city is selected from the suggestions and the description is not empty.
- **City card** showing the city name, its description, the current weather icon and the local observation time.
- Each card loads its weather independently, with its own loading, error and retry states.
- Clear error feedback for network errors, timeouts, invalid API keys and HTTP errors (400, 401, 404, 500).

## Tech stack

| Purpose | Package |
|---|---|
| State management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Value equality for states and entities | [equatable](https://pub.dev/packages/equatable) |
| HTTP client | [dio](https://pub.dev/packages/dio) |
| SVG images (weather icons) | [flutter_svg](https://pub.dev/packages/flutter_svg) |
| Mocks for unit tests | [mocktail](https://pub.dev/packages/mocktail) |
| BLoC testing | [bloc_test](https://pub.dev/packages/bloc_test) |

## Architecture

The project follows **Clean Architecture** with a **feature-first** folder structure:

```
lib/
├── core/
│   ├── constants/       # Asset paths (images and weather icons)
│   ├── errors/          # AppError hierarchy and user-facing messages
│   ├── network/         # Dio configuration (base URL, auth header, timeouts) and error mapping
│   ├── theme/           # Colors, text styles and app theme
│   └── utils/           # Result type and time formatting
└── features/
    └── weather/
        ├── domain/      # Entities, repository contracts and use cases (pure Dart)
        ├── data/        # DTO models (fromJson), remote datasource and repository implementations
        └── presentation/# BLoCs, screens and widgets
```

**Dependency rule:** dependencies point inward (`presentation → domain ← data`). The `domain` layer has no dependencies on Flutter, Dio or any other layer, so the data source can change without touching the UI.

**Request flow:**

```
Widget → BLoC → Use case → Repository (contract) → Repository implementation → Remote datasource (Dio) → AccuWeather API
```

Network exceptions are caught in the datasource layer and mapped to `AppError`s, which the BLoC turns into user-friendly error states.

---

## Getting started

### Prerequisites

- Flutter SDK (stable channel)
- An AccuWeather API key ([AccuWeather Developer Portal](https://developer.accuweather.com/getting-started))

### 1. Clone and install dependencies

```bash
git clone https://github.com/nakakisuGH/weather_app.git
cd weather_app
flutter pub get
```

### 2. Configure the API key

The API key is **never** stored in the code. It is loaded at build time from a local `env.json` file, which is ignored by Git.

Create `env.json` in the project root from the example file:

```bash
# macOS / Linux
cp env.example.json env.json

# Windows (PowerShell)
Copy-Item env.example.json env.json
```

Then replace the placeholder with your key:

```json
{ "ACCUWEATHER_API_KEY": "YOUR_API_KEY_HERE" }
```

### 3. Run the app

```bash
flutter run --dart-define-from-file=env.json
```

If you use VS Code, the included `.vscode/launch.json` already passes this flag, so you can just press **F5**.

---

## Testing

```bash
flutter test
```

Tests never call the real AccuWeather API: API responses are simulated with **mocktail** and sample JSON files in `test/fixtures/`.

- **Unit tests:** models (`fromJson` with complete and missing fields), datasources, repositories (success and each failure type), use cases, the Dio error mapper, `AppError` messages, the time formatter and BLoCs (state sequences, debounce and concurrency).
- **Widget tests:** Home (loading, empty state, city cards, bottom navigation), the Add City sheet (search states, selection, validation, duplicate city, save and close), the city card (loading, success, Retry) and the weather icons (including a check that every icon number has its SVG file).

Static analysis runs with strict type checks enabled (`strict-casts`, `strict-inference`, `strict-raw-types`):

```bash
flutter analyze
```

---

## Technical decisions and assumptions

- **Endpoints used:**
  - `GET /locations/v1/cities/autocomplete` for city suggestions.
  - `GET /currentconditions/v1/{locationKey}` for the weather icon and observation time shown on each card.
- **Authentication:** the API key is sent in the `Authorization: Bearer` header, as required by AccuWeather.
- **Autocomplete:** requests are debounced (~400 ms) and only sent after at least 2 characters, to avoid unnecessary API calls.
- **Card time:** the time shown on each card (e.g. "11:00 AM") is interpreted as the **local observation time** of the city's current conditions, since the design does not specify it further.
- **Description is required** before saving a city, matching the enabled/disabled states of the "Save City" button in the design.
- **Independent card loading:** each city card fetches its own weather, so an error in one city does not affect the others and can be retried individually.
- **Bottom navigation:** only the Locations tab is functional; Home and Profile are shown but do nothing when tapped, since the design does not define those screens.
- **Null safety:** API fields are parsed defensively with `?.`, `??` and default values. The `!` operator is never used on API data.
- **No retrying in search:** In the city search, retrying is done by editing or clearing the text, to follow the Figma design (no Retry button).
- **Saved cities list:** it is read from memory and cannot fail, so it has no error state. The weather of each card is the part that handles errors and retries. Cities are kept in memory only, so they are lost when the app is closed (see Roadmap). Reading them cannot fail, so the list has no error state; the weather of each card is the part that handles errors and retries.
- **Weather icons:** each card shows the official AccuWeather icon (SVG files in `assets/images/`, named by their icon number, rendered with flutter_svg). A question mark icon is shown when the API sends no icon number or one without an image (AccuWeather does not use 9, 10, 27 and 28).
- **Time format:** the card shows the observation time as `hh:mm AM/PM` (e.g. "09:05 AM"), or `--:--` when the API does not send a valid time.
- **City suggestions:** only the city name is shown, as in the design. While a search is active (loading, results, no results or error), its result takes the place of the description field; the typed description is kept.

---

## AI-assisted development

This project was built with the help of **Claude Code** in VS Code.

- A [`CLAUDE.md`](CLAUDE.md) file defines the project's architecture, state management, code rules, testing rules and Git conventions, so the assistant follows the same patterns throughout the project.
- **Plan before code:** each feature (BLoCs, Home screen, Add City sheet, city card, weather icons) started with a written plan that I reviewed and approved before any code was written.
- **Small steps:** one feature at a time, with tests and `flutter analyze` passing before moving on.
- **Manual approval mode:** every change was reviewed before being accepted. I rejected or corrected suggestions that broke the project rules or that I did not want.

## Possible improvements

- **Persist saved cities** across app restarts with a local datasource (e.g. `shared_preferences`). The `SavedCityRepository` contract would stay the same: only the implementation in `data/` changes.
- **Delete or modify the description of a saved city** from its card.
- **Refresh the weather** of all cards with pull-to-refresh.
- **Show the country in city suggestions**, since some cities share the same name.
---

## Git workflow

- Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `test:`, `docs:`, `refactor:`, `chore:`).
- Each feature is developed in its own branch (`feature/...`) and merged into `main`.