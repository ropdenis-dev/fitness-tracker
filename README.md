# Fitness Tracker App

A full-stack fitness tracking mobile application built with Flutter, Node.js, MongoDB, and JWT Authentication.

## Features

- User Authentication (Register/Login with JWT)
- Track Workouts (Name, Duration, Calories, Water Intake)
- Dashboard with Statistics
- User Profile with Picture Upload
- Goals Management
- Dark/Light Mode Support
- Data Synced to Cloud

## Tech Stack

### Frontend
- Flutter (Mobile & Web)
- Provider (State Management)
- Shared Preferences

### Backend
- Node.js
- Express.js
- MongoDB Atlas
- JWT Authentication
- Vercel (Deployment)

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/register | User registration |
| POST | /api/login | User login |
| GET | /workouts | Get user workouts |
| POST | /workouts | Add workout |
| PUT | /workouts/:id | Update workout |
| DELETE | /workouts/:id | Delete workout |
| GET | /health | Health check |

## Live Demos

- **Web App:** [https://fitness-tracker-web-sigma.vercel.app/](https://fitness-tracker-web-sigma.vercel.app/)
- **Backend API:** [https://fitness-tracker-two-fawn.vercel.app](https://fitness-tracker-two-fawn.vercel.app)

## Installation

### Prerequisites
- Flutter SDK
- Node.js
- MongoDB Atlas Account

### Backend Setup

```bash
cd backend
npm install
npm run dev
```

### Flutter Setup

```bash
flutter pub get
flutter run
```
## Folder Structure

```
fitness_tracker/
├── backend/                 # Node.js backend
│   ├── server.js           # Main server file
│   └── package.json        # Backend dependencies
├── lib/                    # Flutter app source code
│   ├── models/             # Data models
│   ├── providers/          # State management
│   ├── screens/            # UI screens
│   └── services/           # API services
├── android/                # Android platform files
├── ios/                    # iOS platform files
├── web/                    # Web platform files
├── build/                  # Build outputs
├── pubspec.yaml            # Flutter dependencies
└── README.md               # Project documentation
```

## Contributors

IBM Group

## License

© 2026 IBM Group. All rights reserved.