<div align="center">

# 📚 EchoShelf

**Your personal audiobook & ebook library — beautifully crafted for iOS.**

![Swift](https://img.shields.io/badge/Swift-5.0-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-16.0+-000000?style=for-the-badge&logo=apple&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Architecture](https://img.shields.io/badge/Architecture-MVVM%20%2B%20Coordinator-5C2D91?style=for-the-badge)
![Tests](https://img.shields.io/badge/Unit%20Tests-141-4CAF50?style=for-the-badge)

</div>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎧 **Audiobooks** | Stream free audiobooks via LibriVox with a full-featured player |
| 📖 **Ebooks** | Browse and read thousands of free PDFs from Project Gutenberg |
| 👶 **Kids Section** | Curated children's books with a dedicated browsing experience |
| 🔍 **Search** | Search across audiobooks, ebooks and kids books simultaneously |
| ❤️ **Favorites** | Save and sync books, authors and genres — offline + Firebase |
| 🎙️ **AI Summaries** | Gemini-powered book summaries inside the detail screen |
| 📂 **Library** | Download ebooks locally, track reading progress per page |
| 💾 **Storage Manager** | Monitor device & cache usage, delete downloads with one tap |
| 🔐 **Auth** | Email/password, Google Sign-In and Apple Sign-In |
| ⚙️ **Settings** | Manage profile, change password, configure playback preferences |

---

## 🏗️ Architecture

EchoShelf follows **MVVM + Coordinator** — no storyboards, fully programmatic UI.

```
App/
├── Coordinator/        → AppCoordinator, TabBarCoordinator, feature coordinators
├── AppDelegate         → Firebase setup
└── SceneDelegate       → Window + root coordinator bootstrap

Features/               → One folder per screen
├── Home/
│   ├── HomeViewController.swift
│   ├── HomeViewModel.swift
│   └── Cells/
├── Player/
├── Search/
├── Favorites/
├── Library/
├── Auth/               → SignIn, CreateAccount, ForgotPassword, Genre
├── Detail/             → Book, Author
├── Settings/
├── Storage/
└── ...

Data/
├── Services/           → AudiobookService, EbookService, AuthService, GeminiService
├── Protocols/          → AudiobookServiceProtocol, EbookServiceProtocol, AuthManagerProtocol
├── Networking/         → APIError, HTTP layer (Alamofire)
└── Endpoints/          → AudiobookEndpoint

Domain/
├── Models/             → Audiobook, Ebook, Author, Genre, LibraryItem, ViewState
└── UseCases/

Core/
├── Extensions/         → UIColor+AppColors, UIViewController+Alert, UIView+Pin, etc.
├── UIComponents/       → GradientButton, reusable views
└── Helper/             → UserDefaultsKeys, FlexibleInt, LibraryManager
```

**Data flow:**
```
ViewController  →  calls ViewModel method
ViewModel       →  calls Service / updates state
ViewModel       →  fires closure (onDataUpdated / onError / onLoadingChanged)
ViewController  ←  binds closure, updates UI
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift 5.0 |
| UI | UIKit — programmatic, no storyboards |
| Architecture | MVVM + Coordinator |
| Auth | Firebase Auth (Email, Google, Apple Sign-In) |
| Database | Cloud Firestore (favorites sync) |
| Networking | Alamofire |
| Image Caching | Kingfisher |
| AI | Google Gemini API |
| Audiobooks API | LibriVox (free public domain) |
| Ebooks API | Gutendex / Project Gutenberg |
| Crash Reporting | Firebase Crashlytics |
| Testing | XCTest — 141 unit tests |

---

## 🧪 Tests

```
EchoShelfTests/
├── SignInViewModelTests.swift          (10 tests)
├── CreateAccountViewModelTests.swift   (12 tests)
├── ForgotPasswordViewModelTests.swift  (8 tests)
├── AllBooksViewModelTests.swift        (16 tests)
├── FavoritesViewModelTests.swift       (24 tests)
├── GenreViewModelTests.swift           (18 tests)
├── StorageCacheViewModelTests.swift    (12 tests)
├── SettingsViewModelTests.swift        (12 tests)
├── FlexibleIntTests.swift              (11 tests)
├── AudiobookModelTests.swift           (14 tests)
├── ViewStateTests.swift                (4 tests)
├── Mocks/
│   ├── MockAudiobookService.swift
│   ├── MockEbookService.swift
│   └── MockAuthManager.swift
└── Helpers/
    └── Stubs.swift
```

Run all tests with **⌘ + U** in Xcode.

---

## 🚀 Getting Started

### Prerequisites

- Xcode 16+
- iOS 16.0+ device or simulator
- A Firebase project (Auth + Firestore enabled)
- A Google Gemini API key

### Setup

**1. Clone the repo**
```bash
git clone https://github.com/Kolchii/EchoShelf.git
cd EchoShelf
```

**2. Add Firebase config**

Download `GoogleService-Info.plist` from your Firebase project console and place it at:
```
EchoShelf/GoogleService-Info.plist
```

**3. Add your Gemini API key**

Create `EchoShelf/Secrets.plist` (already gitignored):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
    <key>GeminiAPIKey</key>
    <string>YOUR_GEMINI_API_KEY_HERE</string>
</dict>
</plist>
```

**4. Open in Xcode**
```bash
open EchoShelf.xcodeproj
```

**5. Build & Run**

Select a simulator or device and press **⌘ + R**.

> ⚠️ `Secrets.plist` and `GoogleService-Info.plist` are gitignored and must be added manually. Never commit API keys.

---

## 🔐 Auth Flow

```
App Launch
    │
    ├── User logged in?  ──► Main Tab Bar
    │
    ├── First launch?    ──► Onboarding → Auth
    │
    └── Returning user?  ──► Sign In screen
```

Logout is handled by `AppCoordinator` via `NotificationCenter` — the view layer never touches the window directly.

---

## 📱 Screens

| | | |
|---|---|---|
| Onboarding | Home | Search |
| Library | Player | Favorites |
| Book Detail | Author Detail | Settings |
| Storage Manager | Sign In | Register |

---

## 👨‍💻 Author

**Ibrahim Kolchi**

---

<div align="center">
Made with ❤️ and Swift
</div>
