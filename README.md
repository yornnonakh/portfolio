# Yorn Nona · Flutter Portfolio

A responsive Flutter portfolio built with Riverpod, locally bundled Outfit typography, soft ambient gradients, and reusable glass components. It supports light and dark themes, reduced motion, keyboard-accessible controls, and adaptive mobile/desktop layouts.

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

## Content checklist

All public content is centralized in **`lib/data/portfolio_content.dart`**. Verify these details before publishing:

1. Confirm the profile, statistics, education, career history, skills, and project claims are accurate.
2. Confirm `assets/profile_photo.jpg`, email, phone number, and availability are intended to be public.
3. Set each `SocialProfile.url` to enable its button; missing links remain disabled with a “Coming soon” tooltip.
4. Set each `PortfolioProject.url` to show its “Visit project” action.
5. Add your production domain as a canonical URL and `og:url` in `web/index.html` after the host is chosen.

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

## Deploy the web build

Create the optimized static site:

```sh
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build web --release
```

Deploy the contents of **`build/web/`** to any static host. Configure HTTPS, compression, and long-lived caching for hashed assets while serving `index.html` with a short cache lifetime. If hosting beneath a path such as `/portfolio/`, build with:

```sh
flutter build web --release --base-href /portfolio/
```

The repository includes production browser metadata, a web manifest, crawler rules, a branded SVG icon, responsive loading colors, and a no-JavaScript fallback. Add host-specific redirects only if path-based routes are introduced later.

Architecture references: [Riverpod NotifierProvider](https://docs-v2.riverpod.dev/docs/providers/notifier_provider) and [Flutter adaptive UI](https://docs.flutter.dev/ui/adaptive-responsive).
