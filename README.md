# Portfolio App - Sheila Nicole Cheng

A Flutter mobile portfolio application with a beautiful deep ocean theme, mirroring the web portfolio design.

## ✨ Features

### 1. Home / Profile Screen
- Profile picture display (static or uploaded)
- Full name and short bio
- Contact information (email, phone, social links)
- Skills, hobbies, and interests sections

### 2. Edit Profile Feature
- Form with TextFormField validation
- Save and reflect updated profile information
- Image picker for profile photo
- Reset to default option

### 3. Navigation
- Smooth Navigator.push / Navigator.pop transitions
- Multiple screens:
  - Home Screen (landing page with navigation circles)
  - Profile Screen
  - Edit Profile Screen
  - Projects Screen
  - Posters Screen
  - Contacts Screen
  - Friends Screen
  - Settings / About Screen

### 4. Forms and Validation
- Required field validation
- Email format validation
- Error messages display
- Flutter form best practices

### 5. Alert Dialogs
- Save changes confirmation
- Delete data confirmation
- Reset profile confirmation
- Success/error notifications

### 6. Friends List
- Add new friends
- Edit existing friends
- Delete friends with confirmation
- Display friends in a list with swipe-to-delete

## 🎨 Design System

- **Primary Colors**: Dark Navy (#010c1b), Ocean Blue (#09173A), Accent (#64b4dc)
- **Theme**: Deep ocean/underwater aesthetic with floating particles
- **Typography**: Playfair Display for headings, Roboto for body text

## 🛠️ Tech Stack

- Flutter 3.10+
- Dart
- Provider (State Management)
- Google Fonts
- URL Launcher
- Image Picker
- Shared Preferences

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  url_launcher: ^6.2.5
  image_picker: ^1.0.7
  provider: ^6.1.2
  shared_preferences: ^2.2.2
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository or download the project

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Available Commands

```bash
# Run on connected device
flutter run

# Run on web
flutter run -d chrome

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── friend_model.dart     # Friend data model
│   ├── poster_model.dart     # Poster data model
│   ├── profile_model.dart    # Profile data model
│   └── project_model.dart    # Project data model
├── screens/
│   ├── contacts_screen.dart  # Contact information
│   ├── edit_profile_screen.dart  # Profile editing form
│   ├── friends_screen.dart   # Friends CRUD
│   ├── home_screen.dart      # Landing page
│   ├── posters_screen.dart   # Posters gallery
│   ├── profile_screen.dart   # Profile display
│   ├── projects_screen.dart  # Projects showcase
│   └── settings_screen.dart  # Settings & About
├── services/
│   └── data_service.dart     # Data persistence service
├── theme/
│   └── ocean_theme.dart      # Custom ocean theme
└── widgets/
    ├── ocean_dialogs.dart    # Custom dialog helpers
    ├── ocean_particles.dart  # Floating particles animation
    └── ocean_widgets.dart    # Reusable UI components
```

## 👩‍💻 Developer

**Sheila Nicole Cheng**
- Email: sheilanicoledizon@gmail.com
- LinkedIn: [Sheila Nicole Cheng](https://www.linkedin.com/in/sheila-nicole-cheng-35982b327/)

## 📄 License

This project is created for educational purposes.
