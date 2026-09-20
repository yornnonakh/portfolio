# Flutter Portfolio

A responsive, dark portfolio inspired by the supplied mobile designs. Built with Flutter, Riverpod, locally bundled Outfit typography, soft ambient gradients, and reusable glass components.

## Run

Requires Flutter 3.44 / Dart 3.12 or compatible newer versions.

```sh
flutter pub get
flutter run -d chrome
```

For iOS, Android, or desktop, use `flutter devices` and run `flutter run -d <device-id>`.

## Screens and interactions

- **Dashboard:** one scrollable view of the complete portfolio: profile, projects, skills, experience, and contact CTA.
- **Home:** profile, statistics, featured work, About and Experience links, and a compact toolbox.
- **About:** biography, education, quick facts, and values.
- **Experience:** career timeline and technology tags.
- **Projects:** Riverpod category filters, empty state, and project detail sheets.
- **Skills:** proficiency rings and additional tools.
- **Contact:** email composer, phone and map links, email copy action, and configurable social profiles.

Phones use a floating bottom navigation bar. The smallest phone breakpoint switches to the compact profile-first home treatment shown in the supplied reference; larger phones use the full Portfolio hero. Wide windows use top navigation and multiple columns. Content scrolls on smaller displays and supports larger system text. About and Experience open with native back navigation.

## Personalize

Edit **`lib/data/portfolio_content.dart`**. All names, employment history, statistics, proficiency values, projects, and contact details are sample data from the references, not verified personal claims.

1. Replace the profile, education, career history, skills, and projects with your information.
2. Replace `assets/profile_photo.jpg` with your own portrait, or set `avatarAsset` to `null` to use the initials fallback.
3. Replace the sample email and phone before publishing.
4. Set each `SocialProfile.url` to enable its button; missing links are visibly disabled with a “Coming soon” tooltip.
5. Set `PortfolioProject.url` to show a “Visit project” action in its detail sheet.
6. Update `web/index.html` and `web/manifest.json` for your public title and description, and replace the generated platform launcher icons before release.

Contact opens the user's email application; the app has no email backend and does not send messages itself. If a platform cannot open a link, the app offers a copy action.

## Structure

```text
lib/
  app.dart                         MaterialApp
  main.dart                        Bootstrap and ProviderScope
  core/
    services/link_service.dart     Testable external-link service
    theme/                         Shared colors, gradients, typography
    widgets/                       Glass cards, buttons, tags, page layout
  data/
    models/portfolio.dart          Immutable typed content models
    portfolio_content.dart         Editable sample content
    portfolio_providers.dart       Read-only Riverpod data providers
  features/
    main/presentation/             Adaptive shell and navigation Notifier
    home/presentation/             Profile and reusable home widgets
    about/presentation/
    experience/presentation/
    projects/presentation/         Filter Notifier, derived projects, details
    skills/presentation/
    contact/presentation/
```

Riverpod `NotifierProvider`s own tab and category selection; a derived provider computes filtered projects. The UI watches the relevant providers and invokes controller methods. Stateless shared components receive their data through constructors. The project retains the existing Riverpod 2.6 dependency and uses no code generation.

## Check and build

```sh
dart format lib test tool
flutter analyze
flutter test
flutter build web
```

Tests cover navigation, filtering, empty states, project details, contact link handling, clipboard behavior, and layouts at 320, 390, 768, and 1440 logical pixels, including enlarged text.

Generate actual Flutter screenshots for the six mobile screens, the compact home breakpoint, and desktop Home:

```sh
flutter test tool/preview_test.dart
```

Images are saved to `build/previews/`. Outfit is bundled under the SIL Open Font License in `assets/fonts/OFL.txt`; the UI does not fetch fonts at runtime.

Architecture references: [Riverpod NotifierProvider](https://docs-v2.riverpod.dev/docs/providers/notifier_provider) and [Flutter adaptive UI](https://docs.flutter.dev/ui/adaptive-responsive).
