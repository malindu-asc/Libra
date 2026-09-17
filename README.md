# libra

A Flutter library-membership app — browse books, borrow and return them, manage your profile.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Run
fvm flutter pub get
fvm dart run build_runner build
fvm flutter run
Sample login: malindu@example.com / Password123!

# implemented

Done

Auth — splash, onboarding, login, register, forgot password, logout. Session is saved
Books — catalogue grid, book details, availability status.
Search — search books by title or author, with an All/Available filter.
Borrowing — borrow a book (max 3 at a time), return it, see active and past borrowings.
Member — profile with your details and borrowing counts, edit profile, change password.
Navigation — go_router with bottom-nav tabs and route guards.

# Not done

Notifications — not started. The bell icon on Home is decorative.
Error handling — no global handler (FlutterError.onError); errors are only handled screen by screen, and raw exception text can still reach the user.
Testing — no real tests cases are intergrated.
Reset password — forgot password sends a confirmation, but there's no screen to actually set a new password

 # video 
 https://ascender-my.sharepoint.com/:v:/g/personal/malindu_pabasara_ascentic_se/IQDBmLN5_L2vRJrh0mvHcYvmAT_-yhxzxYwcgUq_MZnotv4?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=NSq15T

 