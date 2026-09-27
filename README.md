# CookMate Flutter

CookMate is a polished cross-platform recipe app for the Phase 1 Flutter Foundations and UI Mastery demo.

## Included

- Material Design 3 theme with Fraunces display typography and DM Sans body typography
- GoRouter navigation with deep-link friendly routes
- Responsive layouts for phone, tablet, and desktop widths
- Hero image transitions between recipe cards and recipe detail
- Reusable recipe cards, image fallbacks, stat rows, filter chips, and form fields
- Exactly 15 local recipes across Breakfast, Lunch, and Dinner
- Search across recipe titles, ingredients, descriptions, and tags
- Favorites persisted with `shared_preferences`
- Validated recipe submission form with local persistence and confirmation state

## Routes

```text
/
/recipes
/search
/favorites
/recipe/:id
/submit
```

## Run in Visual Studio Code

1. Install Flutter 3.22 or newer and the **Flutter** extension in VS Code.
2. Open the `cookmate_flutter` folder itself, not the parent ZIP folder.
3. Open the VS Code terminal and run:

```bash
flutter create .
flutter pub get
```

4. Select a device from the VS Code device picker, then press **F5**. For a quick browser run:

```bash
flutter run -d chrome
```

`flutter create .` is safe to run here. It generates the Android, iOS, web, and desktop runner folders for the platforms enabled in your local Flutter installation while preserving the included `lib/` source.

## Validate before submission

```bash
dart format lib
flutter analyze
flutter test
```

For a platform-specific build:

```bash
flutter build apk
flutter build web
```

The source package includes `.vscode/launch.json`, so the `CookMate` and `CookMate (Chrome)` launch configurations appear automatically after opening the project.