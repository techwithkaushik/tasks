# Tasks

A Flutter task-management app with Firebase Authentication and Cloud Firestore. The app uses BLoC for presentation state and a layered architecture to keep UI, domain logic, and Firebase data access separate. The current package version is maintained in `pubspec.yaml`.

## Features

- Email/password authentication and password reset.
- User-scoped task loading and live Firestore updates.
- Task priorities, types, status, due dates, estimated/actual minutes, tags, and metadata.
- Swipe actions to complete or delete tasks, with status undo.
- Persisted app preferences through Hydrated BLoC.
- Separate Android release APKs for `arm64-v8a`, `armeabi-v7a`, and `x86_64`.

## Tech stack

- Flutter / Dart
- `flutter_bloc` and BLoC
- GetIt dependency injection
- Firebase Authentication
- Cloud Firestore
- Freezed models

## Architecture

The main feature code is under `lib/src/features`:

- **Domain** — entities, repository contracts, and use cases.
- **Data** — Firebase data sources, models, and repository implementations.
- **Presentation** — BLoCs, pages, and widgets.

Dependency registration is centralized in `lib/service_locator.dart`. App and Firebase initialization starts in `lib/main.dart`.

## Requirements

Install a Flutter stable SDK compatible with the Dart constraint in `pubspec.yaml`, Android SDK/NDK versions required by the Flutter toolchain, and a JDK compatible with the Android Gradle Plugin. CI currently uses Java 17 for the Android build.

## Local setup

1. Clone the repository and enter its directory.
2. Install Flutter dependencies:

   ```sh
   flutter pub get
   ```

3. Configure Firebase for your own Firebase project if you are not using the repository's configured project. Generate/update `lib/firebase_options.dart` and `android/app/google-services.json` using the FlutterFire CLI. Do not commit private credentials or service-account keys.
4. Deploy the Firestore security rules and indexes when setting up a Firebase project:

   ```sh
   firebase deploy --only firestore:rules,firestore:indexes
   ```

5. Run the app on a configured device:

   ```sh
   flutter run
   ```

The app expects Firebase Authentication and Cloud Firestore to be enabled. Task documents are scoped by `userId`; `firestore.rules` enforces ownership on the server. Review the rules and Firebase project before deploying to production.

## Firestore security rules tests

The Firestore rules have emulator-based regression tests for authenticated ownership, cross-user access denial, owner-only writes, immutable task ownership, unauthenticated access, and default-deny behavior for other collections.

Run them locally with Node.js 22 and Java 17:

```sh
npm ci --no-audit --no-fund
npm run test:rules
```

The test command starts the Firestore Emulator, runs the rules tests, and shuts the emulator down when complete. It uses the demo project ID `demo-tasks-rules`; it does not connect to or modify a production Firebase project.

## Quality checks

Run the same core checks used by GitHub Actions:

```sh
flutter pub get --enforce-lockfile
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- pubspec.lock
flutter test --coverage --reporter expanded
flutter analyze .
```

If you change Freezed or JSON-serializable declarations, regenerate generated sources:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Android release APKs

Build split APKs locally:

```sh
flutter build apk --release --split-per-abi
```

The outputs are written to `build/app/outputs/flutter-apk/`. A local build is unsigned unless all four signing environment variables are configured; never distribute an unsigned APK as a production release.

GitHub Actions runs dependency, code-generation, test/coverage, and analysis checks before building APKs. On pull requests, the release-mode APKs are unsigned because repository signing secrets are not available to forked PRs. On pushes to `main`, scheduled runs, and manual dispatches, the workflow requires signing secrets and builds signed APKs. Artifacts include the app version and commit SHA in their names and are retained for 14 days. A separate metadata artifact contains `RELEASE-METADATA.txt` and `SHA256SUMS` so you can identify the source commit and verify downloaded APK integrity. The signed CI build requires these repository Actions secrets:

- `SIGNING_KEYSTORE` — Base64-encoded JKS keystore.
- `SIGNING_KEY_ALIAS` — key alias.
- `SIGNING_KEY_PASSWORD` — private key password.
- `SIGNING_STORE_PASSWORD` — keystore password.

Keep signing secrets out of source control. The workflow fails early when required signing secrets are missing.

## Important files

- `lib/main.dart` — application initialization.
- `lib/service_locator.dart` — dependency injection.
- `lib/src/features/app_auth/` — authentication.
- `lib/src/features/tasks/` — task domain, Firestore access, BLoC, and UI.
- `firestore.rules` — per-user Firestore authorization.
- `firestore.indexes.json` — Firestore indexes.
- `.github/workflows/build.yml` — tests, analysis, signed APK build, and artifact upload.
