# Libra — Project Plan

Flutter app (Riverpod + fpdart, clean/feature-based architecture) for a library membership system, inspired by the `CleanArchitectureDemo` repo but with **its own Figma-driven UI, layouts, and color palette**.

Product/brand name shown in the app is **Libzo** (per the design system doc); the Dart package and repo stay named `libra` — renaming the package is a separate, mechanical decision if we ever want it.

See [ARCHITECTURE.md](ARCHITECTURE.md) for diagrams of how the built pieces actually connect at runtime (layer flow, sequence diagrams, navigation map) — this file tracks *what* to build, that one tracks *how* it works, updated as each feature gets wired.

## 1. How we'll work

This is a UI-first, screen-by-screen build:

1. You share one Figma screen (or a small related group of screens) at a time.
2. I implement it as static UI first — real layout, real colors/type from that Figma file, wired to mock/local data where a list or detail view needs content (matches the `assets/data/*.json` + local datasource pattern used in `CleanArchitectureDemo`'s `book` feature).
3. Once the UI set for a feature is done, we wire it to real state (Riverpod providers) using mock/local repositories.
4. Only after the UI + local flow works do we swap the local datasource for a real HTTP datasource hitting the ASP.NET Core API (section 4). This keeps UI progress decoupled from backend readiness.

So: **UI now, API later**, but the domain layer (entities, repository interfaces, use cases) is written up front to already match the real API shape below, so step 4 is a datasource swap, not a rewrite.

## 2. Tech stack

- Flutter, `flutter_riverpod` + `riverpod_annotation`/`riverpod_generator` for state
- `fpdart` (`Either`) for error handling — domain use cases return `Either<Failure, T>`
- `intl` + `flutter_localizations` for l10n (already scaffolded under `lib/l10n`)
- Networking package (likely `dio`, TBD) added only when we start section 4 (real API wiring) — not needed for UI-first work
- `flutter_secure_storage` (or similar) to be added when auth/token storage is implemented

## 3. Folder structure

```
Libra/
├── assets/
│   ├── data/            # local/mock JSON (books, members, borrowings) used before API is wired
│   ├── fonts/
│   └── images/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── error/            # failure.dart
│   │   ├── extensions/
│   │   ├── network/           # http client wrapper — added in phase 4
│   │   ├── routing/            # app router / route generator
│   │   ├── theme/              # app_colors, app_text_styles, app_spacing, app_radius, app_theme
│   │   ├── usecase/            # base usecase.dart
│   │   ├── utils/
│   │   └── widgets/            # shared widgets: buttons, text fields, nav bar, state views, etc.
│   ├── features/
│   │   ├── auth/        # register, login, refresh/logout, forgot/reset password
│   │   ├── books/       # list/search, details
│   │   ├── borrowings/  # active, history, borrow, return
│   │   └── members/     # my profile (get/update), change password
│   └── main.dart
└── test/
```

Each feature follows `data/ (datasources, models, repositories)` → `domain/ (entities, repository interface, usecases)` → `presentation/ (screens, widgets, providers)`, same convention as `CleanArchitectureDemo`.

## 4. Backend API contract (reference for the domain/data layers)

Key rule baked into the domain layer from the start: **the app never sends or stores a member ID for its own operations** — the JWT is the only source of identity for `/api/me/*` and borrowing actions. No `memberId`, `role`, or `isActive` fields are ever sent from the client.

| Method | Endpoint | Feature | Purpose |
|---|---|---|---|
| POST | `/api/auth/register` | auth | Create account |
| POST | `/api/auth/login` | auth | Login → access + refresh token |
| POST | `/api/auth/refresh` | auth | Refresh session |
| POST | `/api/auth/logout` | auth | Revoke refresh token |
| POST | `/api/auth/forgot-password` | auth | Request reset (generic response, no enumeration) |
| POST | `/api/auth/reset-password` | auth | Reset with token |
| GET | `/api/books` | books | Browse (supports `?search=`, later `?availableOnly=`, `?page=&pageSize=`) |
| GET | `/api/books/{id}` | books | Book details |
| GET | `/api/me` | members | Current profile |
| PUT | `/api/me` | members | Update own profile |
| PUT | `/api/me/password` | members | Change password |
| GET | `/api/me/borrowings` | borrowings | All own borrowings |
| GET | `/api/me/borrowings?status=active` | borrowings | Active |
| GET | `/api/me/borrowings?status=history` | borrowings | History |
| POST | `/api/borrowings` | borrowings | Borrow (`{ "bookId": "..." }` only) |
| POST | `/api/borrowings/{id}/return` | borrowings | Return own borrowing |

Business rules enforced server-side (client just surfaces the resulting error/status): member must be active to borrow, max 3 active borrowings, book must have `availableCopies > 0`, due date = borrow date + 14 days, a member can only return their own borrowing.

Auth tokens: `accessToken`, `refreshToken`, `expiresAt` from login/register/refresh. Stored securely on-device; attached as `Authorization: Bearer <accessToken>` on all authenticated calls; refreshed transparently on expiry (phase 4 concern, not UI concern).

## 5. Screens roadmap

Status tracker, ordered per the design doc's screen map (section 60). Check items off as each is implemented; the 17 Stitch screens you linked map onto this list once we can view them (see section 8).

- [x] Splash
- [x] Onboarding (2 screens implemented: "Expand Knowledge Hub", "Discover Your Next Book" — page count is data-driven, more can be appended anytime)
- [x] Login (wired after onboarding; Sign Up / Forgot Password links still TODO stubs until those screens exist)
- [x] Register (create account) — Login↔Register wired with push/pop (siblings, not a one-way flow); back arrow added
- [x] Forgot password
- [x] Home (real dashboard — greeting, search bar stub, My Borrowings carousel, Recommended row backed by the new `books` feature)
- [x] Books — domain/data/presentation layers (mirrors `CleanArchitectureDemo`'s own `book` feature) + the Books tab screen itself (2-column grid, client-side search/filter, §30) + a shared `BookCard` widget reused by both this screen and Home's Recommended row
- [x] Book details — `GetBookById` usecase + `bookByIdProvider(id)` family provider; tappable from both the Books grid and Home's Recommended row. Borrow button correctly disabled when `availableCopies == 0`
- [x] Borrow confirmation (bottom sheet) — book summary, borrow/due dates (real 14-day calc), active-borrowings count; "Confirm Borrow" calls the real `BorrowBook` usecase against the `borrowings` feature (§10)
- [x] Borrow success — not a separate screen; the confirmation sheet swaps its own body in place (checkmark, "Book Borrowed!", "View My Borrowings"/"Back to Home") once the borrow succeeds
- [x] My Borrowings — Active
- [x] My Borrowings — History — same screen as Active, a segmented Active/History switch, not two separate screens
- [x] Return confirmation (bottom sheet) — book summary + borrowed/due dates; "Confirm Return" calls the real `ReturnBook` usecase, which restores the book's `availableCopies` and stamps `returnedAt`
- [x] Return success — same in-place sheet swap as Borrow success ("Book Returned!" + Done)
- [ ] Profile
- [ ] Edit profile
- [ ] Change password
- [x] Shared: bottom navigation shell (`MainShell`, Material 3 `NavigationBar`), `AppEmptyState`/`AppErrorState` — loading skeletons and toasts still not built (plain spinners/SnackBars used instead)

## 6. Design system — implemented

`lib/core/theme/` is built from the Libzo design system doc you provided (colors §4–6, type scale §7–10, spacing §11, radius §12, buttons §16, inputs §18, token summary §65):

- [app_colors.dart](lib/core/theme/app_colors.dart) — brand purple scale (`#832DFE` primary), neutrals, semantic colors
- [app_text_styles.dart](lib/core/theme/app_text_styles.dart) — Inter via `google_fonts`, full type scale (display/screenTitle/sectionTitle/cardTitle/body/caption/metadata) plus button/input styles
- [app_spacing.dart](lib/core/theme/app_spacing.dart) — 8pt scale, 20px screen padding
- [app_radius.dart](lib/core/theme/app_radius.dart) — 12px inputs / 14px buttons / 16px cards / 24px sheets
- [app_theme.dart](lib/core/theme/app_theme.dart) — assembles the above into `ThemeData` (buttons, inputs, app bar, bottom nav, cards, bottom sheets)

Wired into [main.dart](lib/main.dart), which currently shows a temporary theme-preview screen (buttons, input, text scale, availability chips) to sanity-check the tokens visually before real screens replace it.

These are a first pass from the written spec — expect adjustments once we can see the actual Stitch screens (colors/spacing are easy to retune since everything routes through these token files, nothing is hardcoded per-screen).

Shared component library to build next (design doc §62), each wrapping the theme tokens above: `LibzoButton`/`LibzoSecondaryButton`, `LibzoTextField`, `LibzoSearchField`, `LibzoBookCard`/`LibzoBookGrid`/`LibzoBookCover`, `LibzoAvailabilityChip`, `LibzoBorrowingCard`, `LibzoBottomNavigation`, `LibzoEmptyState`/`LibzoErrorState`/`LibzoLoadingSkeleton`, `LibzoConfirmationSheet`, `LibzoSnackbar`.

## 7. Toolchain note

`pubspec.yaml` requires Dart `^3.13.1`; the globally installed Flutter here is 3.44.4 (Dart 3.12.2), so plain `flutter pub get` fails. The repo pins Flutter `3.47.2` (Dart 3.13.2, latest stable as of 2026-09-09) via `.fvmrc` — use `fvm flutter ...` for all commands, or call `./.fvm/versions/3.47.2/bin/flutter.bat` directly if the `fvm` wrapper itself isn't on `PATH` in a given shell.

## 8. Auth logic — wired

Splash, Onboarding, Login, Register, and Forgot Password are all built. Beyond that, `auth` now has real (mock) logic behind it, following the exact layering from `CleanArchitectureDemo`'s `book` feature:

- `domain/entities/` — `Member`, `AuthSession`
- `domain/repositories/auth_repository.dart` — interface
- `domain/usecases/` — `Login`, `Register`, `ForgotPassword`, each `UseCase<T, Params>` returning `Either<Failure, T>`
- `data/models/` — `MemberModel`/`AuthSessionModel` (extend the domain entities, `fromJson` ready for the real API swap)
- `data/datasources/auth_local_datasource.dart` — **mock** datasource: simulates network delay, does basic validation, fake-succeeds. This is the one piece that gets swapped for real HTTP later — nothing above it changes.
- `data/repositories/auth_repository_impl.dart` — catches datasource exceptions, converts to `Failure`
- `presentation/providers/auth_providers.dart` — manual Riverpod providers + an `AsyncNotifier` controller per screen (no `build_runner`/codegen needed for this)

Login/Register/Forgot Password screens now show real loading spinners (in the button) and error snackbars, and Login/Register navigate on success. Since the real Home screen doesn't exist yet, added a minimal placeholder (`features/home/presentation/screens/home_screen.dart`) — successful login/register lands there via `pushAndRemoveUntil` (clears the whole stack, so back doesn't return to Login).

`flutter analyze`: 0 issues.

## 9. Borrowings logic — wired

`borrowings` now has real (mock) logic, same layering as `auth`/`books`:

- `domain/entities/borrowing.dart` — `Borrowing` (schema-pure: `id`, `bookId`, `memberId`, `borrowedAt`, `dueDate`, nullable `returnedAt`; computed `status`/`daysLeft`), `BorrowingRecordStatus` (`borrowed`/`returned`/`overdue`), `BorrowingStatus` (`active`/`history` — the query filter, a different axis from record status)
- `domain/usecases/` — `GetBorrowings`, `BorrowBook` (`bookId` only, matches `POST /api/borrowings`'s real body)
- `data/datasources/borrowing_local_datasource.dart` — **the first stateful mock**: an in-memory `List<BorrowingModel>` that persists for the session. Enforces the 3-active-borrowings limit and book availability, decrements the book's `availableCopies` via `BookLocalDataSource` (which had to become stateful/cached too — see ARCHITECTURE.md §5), and scopes every read/write to whoever's currently logged in
- `auth/presentation/providers/current_member_provider.dart` — new: a `keepAlive` session provider holding the logged-in `AuthenticatedMember`, set on login success. Needed so `borrowings` can stamp `memberId` without any screen threading it through manually
- `presentation/providers/borrowings_providers.dart` — since `Borrowing` only carries `bookId`, both `activeBorrowingsPreviewProvider` (Home's carousel / the confirmation sheet) and `borrowingListProvider` (My Borrowings, family by `BorrowingStatus`) do a real two-stage fetch: get the borrowings, then `Future.wait` over `GetBookById` for every referenced book, concurrently
- Screens: `BorrowConfirmationSheet` (stateful — swaps to an in-place success view after a real borrow) and `MyBorrowingsScreen` (segmented Active/History switch, per-card status badge)

`ReturnBook` is now built too — `returnBorrowing` restores the book's `availableCopies`, stamps `returnedAt`, and the record moves from the Active tab to History.

## 10. Members logic — layer built, no UI yet

`members` has its full domain/data/presentation-provider stack, but **no screens** — Profile/Edit Profile/Change Password are still unbuilt, and `MainShell`'s Profile tab is a placeholder.

- `domain/entities/member.dart` — `Member`, schema-pure: `id`, `fullName`, `email`, `phoneNumber`, `registeredDate`, `isActive`. Its own class, separate from `auth`'s `AuthenticatedMember` ("who logged in" vs. "the editable profile")
- `domain/usecases/` — `GetMyProfile`, `UpdateMyProfile` (`fullName`/`email`/`phoneNumber` only — no `id`, `registeredDate` or `isActive`, per §4's no-client-sent-fields rule), `ChangePassword`
- `data/datasources/member_local_datasource.dart` — stateful mock, same shape as borrowings': caches `users.json` in memory so edits survive the session, reads the logged-in id from `currentMemberProvider`, verifies the old password on change
- `assets/data/users.json` — gained `registeredDate` and `isActive` to complete the schema
- `presentation/providers/member_providers.dart` — `myProfileProvider` plus `UpdateProfileController`/`ChangePasswordController`. A successful profile update also refreshes `currentMemberProvider`, so Home's greeting reflects a name change immediately

Known mock limitation: this datasource caches `users.json` separately from `auth`'s, so *change password → log out → log back in with the new password* would fail. Not reachable yet (no logout exists); needs resolving when one is added.

## 11. Next step

Borrow and return both work end to end. What's left: the three `members` screens (Profile, Edit Profile, Change Password) + wiring the Profile tab, **Logout** (nothing calls `currentMemberProvider.clear()` today — no usecase, no button), and auth's remaining `refresh`/`reset-password` endpoints.
