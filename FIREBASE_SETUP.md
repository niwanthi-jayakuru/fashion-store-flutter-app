# Firebase setup (appendix / marker instructions)

Short steps to reproduce the backend this app expects. Full data model and run commands are in `README.md`.

## 1. Firebase project

1. Open [Firebase Console](https://console.firebase.google.com/) → **Add project** (or use an existing project).
2. Register an **Android** app with the same **application ID** as `android/app/build.gradle` (`applicationId`).
3. Download **`google-services.json`** and place it at **`android/app/google-services.json`**.

## 2. Flutter ↔ Firebase config files

From the project root (with Flutter SDK and [FlutterFire CLI](https://firebase.flutter.dev/) installed):

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Select this Firebase project and **Android**. This keeps **`lib/firebase_options.dart`** and **`google-services.json`** in sync with the Console.

## 3. Authentication

**Firebase Console → Authentication → Sign-in method** → enable **Email/Password**.

The app uses email/password only (register, login, logout).

## 4. Firestore

1. **Firebase Console → Firestore Database** → **Create database** (production or test mode per your course rules).
2. **Security rules:** deploy the project’s `firestore.rules` (or tighten them for production). From the project root, with [Firebase CLI](https://firebase.google.com/docs/cli) logged in:

   ```bash
   firebase deploy --only firestore:rules
   ```

3. **Composite index (order history):** the app queries `orders` with `where('userId', …)` and `orderBy('timestamp', descending: true)`. Deploy indexes from `firestore.indexes.json`:

   ```bash
   firebase deploy --only firestore:indexes
   ```

   If you skip deploy, the app may log a URL when the query runs—open it once in the browser to create the index automatically.

## 5. Seed products

- **In-app:** Profile → **Seeder (Admin)** → **Seed Database** (sample products), or  
- **Manual:** Firestore → collection **`products`** with fields such as `name`, `price`, `category`, `image` (URL), `description` (see `README.md`).

## 6. Release APK location

After a successful build:

```bash
flutter build apk --release
```

The file to submit or sideload is:

**`build/app/outputs/flutter-apk/app-release.apk`**

(On Windows the path may appear as `build\app\outputs\flutter-apk\app-release.apk`.)
