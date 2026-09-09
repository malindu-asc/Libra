# Libra — Architecture Reference

A living doc explaining **how** the pieces we've built actually connect at runtime. `plan.md` tracks what to build next; this tracks how what's already built works, updated each time a feature gets wired.

---

## 1. The generic pattern (every feature follows this)

Every feature's three layers, and the direction dependencies point — always inward, toward `domain`. `domain` never imports from `data` or `presentation`.

```mermaid
flowchart LR
    subgraph Presentation
        Screen["Screen / Widget"]
        Controller["Riverpod Controller<br/>(AsyncNotifier)"]
    end

    subgraph Domain["Domain (the center — depends on nothing else)"]
        UseCase["Use Case"]
        RepoInterface["Repository<br/>Interface"]
        Entity["Entity"]
    end

    subgraph Data
        RepoImpl["Repository<br/>Implementation"]
        DataSource["Datasource<br/>(mock now, HTTP later)"]
        Model["Model"]
    end

    Screen --> Controller --> UseCase
    UseCase --> RepoInterface
    UseCase --> Entity
    RepoImpl -. implements .-> RepoInterface
    RepoImpl --> DataSource
    DataSource --> Model
    Model -. "is-a (extends)" .-> Entity
```

**Why the arrow from `RepoImpl` to `RepoInterface` is dotted ("implements")**: this is the one inversion that makes the whole thing swappable. `domain` defines *what* operations exist (the interface); `data` decides *how* to fulfill them. Swapping the mock datasource for real HTTP later means editing `data/`, never `domain/` or `presentation/`.

---

## 2. Feature: `auth` (built)

### Structure

```mermaid
flowchart TD
    subgraph auth_domain["auth/domain/"]
        Member["entities/member.dart"]
        AuthSession["entities/auth_session.dart"]
        AuthRepo["repositories/auth_repository.dart<br/>(interface)"]
        Login["usecases/login.dart"]
        Register["usecases/register.dart"]
        ForgotPw["usecases/forgot_password.dart"]
    end

    subgraph auth_data["auth/data/"]
        MemberModel["models/member_model.dart"]
        SessionModel["models/auth_session_model.dart"]
        LocalDS["datasources/auth_local_datasource.dart<br/>(mock — swap point for real HTTP)"]
        RepoImpl["repositories/auth_repository_impl.dart"]
    end

    subgraph auth_presentation["auth/presentation/"]
        Providers["providers/auth_providers.dart<br/>(wiring + controllers)"]
        LoginScreen["screens/login_screen.dart"]
        RegisterScreen["screens/register_screen.dart"]
        ForgotScreen["screens/forgot_password_screen.dart"]
    end

    Login --> AuthRepo
    Register --> AuthRepo
    ForgotPw --> AuthRepo
    RepoImpl -. implements .-> AuthRepo
    RepoImpl --> LocalDS
    MemberModel -. extends .-> Member
    SessionModel -. extends .-> AuthSession
    Providers --> Login
    Providers --> Register
    Providers --> ForgotPw
    LoginScreen --> Providers
    RegisterScreen --> Providers
    ForgotScreen --> Providers
```

### Runtime flow — tapping "Log In"

```mermaid
sequenceDiagram
    participant U as User
    participant S as LoginScreen
    participant C as LoginController
    participant UC as Login (usecase)
    participant R as AuthRepositoryImpl
    participant D as AuthLocalDatasourceImpl

    U->>S: Tap "Log In"
    S->>C: submit(email, password)
    C->>C: state = AsyncLoading()
    Note over S: button shows spinner
    C->>UC: call(LoginParams)
    UC->>R: login(email, password)
    R->>D: login(email, password)
    D-->>D: validate + simulate 800ms delay
    alt valid
        D-->>R: AuthSessionModel
        R-->>UC: Right(session)
    else invalid
        D-->>R: throws AuthException
        R-->>UC: Left(ValidationFailure)
    end
    UC-->>C: Either<Failure, AuthSession>
    C->>C: state = AsyncData(session) or AsyncError(...)
    C-->>S: ref.listen fires
    alt success
        S->>S: pushAndRemoveUntil → HomeScreen
    else error
        S->>S: show SnackBar
    end
```

Register and Forgot Password follow the identical shape (`RegisterController`, `ForgotPasswordController`) — only what happens on success differs: Register pops back to Login with a snackbar (no auto-login, per the backend contract); Forgot Password shows the generic confirmation and stays put (anti-enumeration rule).

---

## 3. Screen navigation flow (built so far)

```mermaid
flowchart TD
    Splash --> Onboarding
    Onboarding -->|Skip or Get Started| Login
    Login -->|Sign Up| Register
    Login -->|Forgot Password?| ForgotPassword
    Register -->|Log In link| Login
    ForgotPassword -->|Log In link| Login
    Login -->|success| Home["Home (placeholder)"]
    Register -->|success, snackbar| Login

    style Home fill:#F1E8FF,stroke:#832DFE
```

`Splash → Onboarding → Login` and `Login → Home` use `pushReplacement`/`pushAndRemoveUntil` (one-way, can't navigate back). `Login ↔ Register` and `Login ↔ ForgotPassword` use `push`/`pop` (siblings — legitimately reversible). See [plan.md §8-9](plan.md) for why.

---

## 4. Decisions log

**2026-09-09 — Entities are per-feature, not shared.** `auth`'s `Member` (id, fullName, email, phone) is intentionally a different class from what the future `members` feature will use for the full profile — they represent different bounded contexts (authenticated identity vs. editable profile) even though the fields overlap. Same plan for `books`' full `Book` vs. `borrowings`' tiny embedded `BorrowingBook` — matches how the backend itself scopes each endpoint's response.

Worth knowing: this follows the *community* Clean Architecture pattern (same as `CleanArchitectureDemo`, our reference repo) — Google's own [official architecture guide](https://docs.flutter.dev/app-architecture/guide) actually recommends the opposite (one shared `domain/models/` folder, repositories kept independent of *each other* but not of the model). We're deliberately staying consistent with `CleanArchitectureDemo` since that's our chosen reference; flagged here in case that tradeoff needs revisiting later.

---

## How to keep this updated

Each time a new feature gets wired (domain + data + presentation, not just UI screens):
1. Add a `## Feature: <name>` section with its structure diagram (copy §2's shape).
2. Add a sequence diagram for its main action if the flow differs meaningfully from `auth`'s.
3. Extend the navigation flowchart in §3 if it adds new screens/transitions.
4. Log any non-obvious architectural decision in §4, dated.
