# Flutter Supabase Todo with Provider

A cloud-powered Todo app using Supabase/Postgres, focusing on clean architecture, security, and high performance. Built with Flutter, Provider + ValueNotifier (for minimal widget rebuilds), Google Fonts (Noto Sans JP), and a modern style UI.

## Features

- **Supabase/Postgres integration** (cloud DB, scalable)
- **Provider** state management, with **ValueNotifier** for partial rebuilds (performance oriented)
- **Beautiful Material 3 UI** (Noto Sans JP via Google Fonts, Apple-inspired design)
- **Secure .env for Supabase credentials** (never commit secrets to Git)
- **Strike-through title** when completed (auto)
- **Swipe to delete**, **edit**, **priority**, **due date**, and fully optimistic UI updates

## Directory Structure

```
lib/
├── main.dart
├── models/
│   └── task.dart
├── providers/
│   └── task_provider.dart
├── screens/
│   └── home_screen.dart
├── widgets/
│   └── my_checkbox.dart
assets/
└── .env
```

---

## Setup Instructions

### 1. Prepare Supabase Project & Table

- Create a new project at [https://supabase.com/](https://supabase.com/)
- In SQL Editor, run:

```sql
create table tasks (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  description text,
  due_date date,
  priority text,
  is_completed boolean default false
);
```

### 2. Create .env File (assets/.env)

```
SUPABASE_URL=your-supabase-project-url
SUPABASE_ANON_KEY=your-anon-key
```

Important:
Never share your anon key or URL publicly.
Add .env to .gitignore!

### 3. Update pubspec.yaml

```
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5
  supabase_flutter: ^2.9.1
  intl: ^0.20.2
  flutter_slidable: ^4.0.0
  fluttertoast: ^8.2.12
  google_fonts: ^6.2.1
  flutter_dotenv: ^5.2.1

flutter:
  uses-material-design: true
  assets:
    - assets/.env
```

### 4. Install Packages

```
flutter pub get
```

### Run the App

```
flutter run
```

## Technical Highlights

- Supabase is initialized in main() after dotenv loads.
- Provider manages task list; checkbox state is managed via ValueNotifier for fine-grained widget updates.
- All Supabase secrets are managed via .env (never commit credentials!).
- Task title uses ValueListenableBuilder for instant strikethrough effect on check/uncheck.
- UI supports Japanese and beautiful font via Noto Sans JP.

## Tips & Warnings

- Do NOT commit your .env file — always add it to .gitignore.
- Never share your Supabase credentials.
- Keep Flutter and all dependencies up to date for best results.
- Code is MIT licensed — use freely for personal or commercial projects.

MIT License | Edited by Arton
