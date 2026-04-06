# Fashion Store (Flutter + Firebase)

## Firebase setup (required config + run steps)

### Prereqs
- Install **Flutter SDK** and **Android Studio** (Android SDK + an emulator/device).
- Install Firebase CLI:

```bash
npm i -g firebase-tools
firebase login
```

- Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

If `flutterfire` isn’t found, add this to your PATH:
- `%LOCALAPPDATA%\Pub\Cache\bin`

### Connect the app to Firebase
From the project root (`c:\Users\niwan\fashion_store`):

```bash
flutter pub get
flutterfire configure
```

During configuration:
- Select the **Firebase project**
- Enable **Android**

This project expects these generated config files:
- `lib/firebase_options.dart`
- `android/app/google-services.json`

### Firebase Console checklist
In Firebase Console:
- **Authentication → Sign-in method**: enable **Email/Password**
- **Firestore Database**: create a Firestore database

## Firestore data model (what this app reads/writes)

### `products` (read by home screen and product list)
Each product document should include these fields (used by `Product.fromFirestore`):
- **name**: string
- **price**: number
- **category**: string
- **image**: string (URL)
- **description**: string

Extra fields are allowed. The built-in seeder also writes:
- **rating**: number
- **stock**: number
- **createdAt / updatedAt**: server timestamps

### `orders` (written at checkout, read in order history)
Created by checkout via `CartService.placeOrder()`:
- **userId**: string (Firebase Auth UID)
- **items**: array of `{ product: { id,name,price,image,category,description }, quantity: number }`
- **total**: number
- **address**: string
- **phone**: string
- **status**: string (defaults to `Pending`)
- **timestamp**: server timestamp

### `users` (profile)
Stored at `users/{uid}` and updated from the Profile screen:
- **displayName**: string
- **email**: string
- **phone**: string
- **address**: string
- **createdAt / updatedAt**: server timestamps

## Seed Firestore (sample products)

### Option A (recommended): in-app seeder screen
This project includes an in-app seeding tool:
- Open **Profile** → tap **Seeder (Admin)** → **Seed Database**

This will create 10 sample documents in the `products` collection.

To delete all products:
- **Profile** → **Seeder (Admin)** → **Clear All Products**

### Option B: manual seeding in Firebase Console
Firebase Console → Firestore → create collection `products` and add docs with:
`name`, `price`, `category`, `image`, `description`.

## Run the app

```bash
flutter pub get
flutter run
```

## Build APK (Android)

```bash
flutter build apk --release
```

APK output:
- `build/app/outputs/flutter-apk/app-release.apk`
