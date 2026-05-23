# MotorBridge UK 🚗

MotorBridge is a UK-based vehicle management and emergency assistance mobile application. Built using Flutter, this app helps users manage their vehicles, track upcoming or expired reminders, handle motoring emergencies, and seamlessly report accidents with comprehensive detail tracking (including photos, witness details, and other parties involved).

---

## 🚀 Features

- **Vehicle Management:** Easily add, view, and manage your vehicle details.
- **Smart Reminders:** Track crucial timelines with categorized views for **All**, **Upcoming**, and **Expired** reminders.
- **Motoring Emergencies & Accident Reporting:** - Comprehensive accident logs featuring dynamic tabs.
  - Integration for recording witness info, other parties' data, and event summaries.
  - Photo attachment support for immediate proof/documentation.
- **Profile & Reports:** View complete report history, edit user profiles, and check details of generated accident reports.
- **Interactive UI:** Smooth introductory onboarding experience via a custom multi-page SplashScreen flow.

---

## 🛠️ Tech Stack & Architecture

- **Frontend:** Flutter & Dart
- **State Management:** GetX (Reactive state, Routing, and Dependency Injection)
- **Architecture:** MVC (Model-View-Controller) Pattern
- **Backend (API):** Laravel REST API

---

## 📂 Project Structure

The project strictly follows the **MVC** architecture grouped cleanly by features under the `lib/` directory:

```text
lib/
📊 core/                  # Dependency Injection & Global Routes (GetX AppPages/AppRoutes)
⚙️ services/              # API Service layer (REST Client)
🎮 controller/            # GetX Controllers handling business logic & state
🧱 general_widget/       # Shared custom widgets across features (e.g., BottomNavBar)
📱 modules/features/     # Feature-based Views and specific Widgets:
   ├── profile/          # Profile Views & Report history
   ├── reminders/        # Reminders logic (All, Expired, Upcoming)
   ├── splashscreen/     # Multi-step Walkthrough/Onboarding UI
   └── vehicles/         # Main Core Dashboard, Accident tabs, and Vehicle Cards
🎨 utils/                 # App Constants (Colors, Sizes, Text Styles)
