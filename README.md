# MotorBridge UK 🚗

MotorBridge is a comprehensive, UK-based vehicle management and emergency assistance mobile application. Built using Flutter and powered by a Laravel backend, the app streamlines vehicle tracking, expense management, document storage, and emergency reporting into a single, intuitive interface.

---

## 🚀 Key Features

### 🔍 Smart Vehicle Lookup & Management
- **Government API Integration:** Instantly fetch accurate vehicle details directly from the UK government database using just the registration plate number.
- **Manual Enhancements:** Add custom service data, mileage, or other specific vehicle notes over the fetched data.
- **Digital Document Vault:** Store and organize vital vehicle documents (insurance, MOT, logbook) directly under each specific vehicle profile for quick access.

### 💰 Expense & Cost Tracking
- **Cost Management:** Add and categorize individual running costs (fuel, repairs, insurance, taxes) for each vehicle.
- **Smart Alerts:** Stay on top of budgets and renewals with dynamic **Daily, Weekly, and Monthly alert systems**.

### ⏰ Intelligent Reminders
- Organized dashboard to monitor **All**, **Upcoming**, and **Expired** maintenance schedules or regulatory deadlines.

### 🚨 Emergency & Accident Reporting Section
- **Custom Emergency Contacts:** Save and quickly access local emergency numbers or personal roadside assistance hotlines.
- **Comprehensive Accident Logs:** Dynamic multi-tab flow to record incident summaries, witness details, third-party information, and photo evidence on the spot.

---

## 🛠️ Tech Stack & Architecture

- **Frontend:** Flutter & Dart
- **State Management:** GetX (Reactive state, Routing, and Dependency Injection)
- **Architecture:** MVC (Model-View-Controller) Pattern
- **Backend (API):** Laravel REST API
- **External Integration:** UK Government Vehicle Registration API (DVLA)

---

## 📂 Project Structure

The project strictly follows the **MVC** architecture grouped cleanly by features under the `lib/` directory:

```text
lib/
📊 core/                  # Dependency Injection & Global Routes (GetX AppPages/AppRoutes)
⚙️ services/              # API Service layer (REST Client & Government API integrations)
🎮 controller/            # GetX Controllers handling business logic (Auth, Vehicle, Cost Tracking)
🧱 general_widget/       # Shared custom widgets across features (e.g., BottomNavBar)
📱 modules/features/     # Feature-based Views and specific Widgets:
   ├── profile/          # Profile Views, Expense Reports & Accident History
   ├── reminders/        # Reminders logic (All, Expired, Upcoming)
   ├── splashscreen/     # Multi-step Onboarding walkthrough
   └── vehicles/         # Main Dashboard, Lookup views, Document vault, & Emergency tools
🎨 utils/                 # App Constants (Colors, Sizes, Text Styles)
