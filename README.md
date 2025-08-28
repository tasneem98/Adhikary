# أذكــارى (Adhikary)

Adhikary is a simple Flutter application designed to help users remember Allah (ذكر الله) by providing **periodic Zikr notifications** and an **on-screen display of various Adhkar**.

---

## 📖 Purpose

The primary goal of Adhikary is to encourage consistent remembrance of Allah throughout the day by sending gentle reminders and making it easy to access different Adhkar.

---

## ✨ Features

- **Periodic Zekr Notifications**
    - Sends a local notification with a random Zekr every 15 minutes (user can enable/disable).
    - Works in the background or when app is terminated using Android's WorkManager.

- **On-Screen Zekr Display**
    - Displays a random Zekr in the center of the app.

- **Home Screen Widget**
    - Updates the Android home screen widget with the current Zekr.

- **Notification Management**
    - Enable/disable notifications in-app.
    - Guides users to settings if permissions are denied.

- **Simple & Focused UI**
    - Clean interface with Cairo font, designed for focus on Adhkar.

---

## 🚀 Getting Started with Development

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

To run the project:
1. Ensure you have Flutter SDK installed.
2. Clone the repository.
3. Navigate to the project directory: `cd adhikary`
4. Install dependencies: `flutter pub get`
5. Run the app: `flutter run`
---

## 📝 TODO List
### 🎯 Core Functionality Enhancements
- [x] Basic periodic Zikr notifications (every 15 mins via WorkManager). *(Marked as done based on implementation)*
- [x] On-screen random Zekr display. *(Marked as done)*
- [x] Manual refresh button for on-screen Zekr ("ذكر اخر"). *(Marked as done)*
- [x] Basic Home Screen Widget integration (displaying current Zekr). *(Marked as done based on features list)*
- [x] Notification permission handling and enable/disable toggle. *(Marked as done)*

- [ ] Implement a bottom sheet or dialog to confirm/manage notification preferences when first enabling.
- [ ] Add a dedicated button or UI element to explicitly trigger an update/refresh of the home screen widget.
- [ ] Allow users to customize the notification frequency (e.g., every 15 min, 30 min, 1 hour).
- [ ] Add a wider variety of Adhkar, potentially categorized (e.g., morning/evening Adhkar, Adhkar after Salah).
- [ ] Allow users to select specific categories of Adhkar for notifications.
- [ ] Implement a "Favorite Adhkar" feature.
- [ ] Add a counter for selected Adhkar (tasbeeh counter).

### 🎯 UI/UX Improvements
- [ ] Add app theming (Light/Dark mode).
- [ ] Add an option to change the font size for displayed Adhkar.

### 🎯 Nice-to-Haves
- [ ] Option to share Adhkar.
- [ ] Include the source/reference for each Zekr.
- [ ] Sound effects for notifications (optional, user-configurable).

