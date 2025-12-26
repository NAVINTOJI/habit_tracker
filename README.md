# Discipline Tracker - Motivational Habit Tracking App

A professional Flutter application for tracking daily discipline and building unstoppable habits, inspired by anime determination and willpower.

## Features

- **Daily Discipline Checklist**: Fixed set of daily tasks with simple completion tracking
- **Fire Streak System**: Animated streak counter with visual fire effects
- **Perfect Day Tracking**: Days are marked as perfect (all tasks complete) or failed (any task missed)
- **Calendar Heatmap**: Monthly view with color-coded success/failure visualization
- **Analytics Dashboard**: Weekly performance charts and statistics
- **Motivational Quotes**: Anime-inspired quotes and motivational messages
- **Offline-First**: All data stored locally with Hive database
- **Clean Architecture**: MVVM pattern with Riverpod state management

## Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Riverpod**: State management
- **Hive**: Local NoSQL database
- **fl_chart**: Charts and graphs
- **Lottie**: Animations
- **intl**: Date formatting

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App configuration
├── models/                   # Data models
│   ├── day_record.dart
│   ├── day_record.g.dart
│   └── streak_data.dart
├── services/                 # Business logic
│   ├── discipline_service.dart
│   └── quote_service.dart
├── storage/                  # Data layer
│   └── discipline_repository.dart
├── viewmodels/               # State management
│   ├── home_viewmodel.dart
│   └── checklist_viewmodel.dart
├── views/                    # Screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── checklist_screen.dart
│   ├── calendar_screen.dart
│   └── analytics_screen.dart
├── widgets/                  # Reusable components
│   ├── fire_streak_card.dart
│   ├── quote_card.dart
│   └── animated_hero.dart
├── theme/                    # Styling
│   └── app_theme.dart
└── utils/                    # Utilities
    └── date_utils.dart
```

## Setup Instructions

1. **Install Flutter**: Make sure Flutter is installed and configured
2. **Get Dependencies**: 
   ```bash
   flutter pub get
   ```
3. **Run the App**:
   ```bash
   flutter run
   ```

## How It Works

### Daily Tasks
The app comes with 8 default tasks:
- Wake up early (before 6 AM)
- Morning workout (30+ min)
- Healthy breakfast
- Study/Work focus (4+ hours)
- No junk food
- Evening exercise
- Read (30+ min)
- Sleep before 11 PM

### Streak Logic
- Complete all tasks in a day → Perfect Day → Streak increases
- Miss any task → Failed Day → Streak resets to 0
- Past days are automatically marked as failed if not completed

### Data Persistence
All data is stored locally using Hive. No internet connection required.

## Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release
```

## Customization

To customize the tasks, edit the `defaultTasks` list in `lib/services/discipline_service.dart`.

## Architecture

This app follows Clean Architecture principles:
- **Models**: Pure data classes
- **Services**: Business logic
- **Repositories**: Data access layer
- **ViewModels**: State management with Riverpod
- **Views**: UI screens
- **Widgets**: Reusable UI components

## License

This project is created as a demonstration of Flutter development best practices.
