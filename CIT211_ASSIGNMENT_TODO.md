# CIT211 Fashion Store — Specification vs This App

**Source:** `CIT211_Fashion_Store_Assignment_Specification-2 (1).pdf` (CIT211 Mobile Software Development, Flutter + Firebase + Figma).

This file maps coursework requirements to the current codebase and lists what is done, what is partial, and what you still owe (including non-code deliverables).

---

## Phase 1 — UI/UX + Flutter frontend (40%)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Figma: user flow, high-fidelity screens, colors/typography, interactive prototype | **You (design asset)** | Not stored in this repo; required separately for Phase 1 marking. |
| Screen: Login / Registration | **Done** | `login_screen.dart`, `register_screen.dart` |
| Screen: Home (categories + featured) | **Partial** | Categories + full product list on `home_screen.dart`. There is no separate “featured” section (e.g. flagged products or carousel); all products appear together. |
| Screen: Product listing | **Partial** | `product_list.dart` + route `/products` in `main.dart`. **No in-app navigation** to `/products` from Home (only defined route). Home already lists products—meets spirit, but dedicated listing screen is easy to miss in demos. |
| Screen: Product details | **Done** | `product_details.dart` |
| Screen: Cart | **Done** | `cart_screen.dart` — add/remove/update quantity |
| Screen: Checkout (UI → now functional for Phase 2) | **Done** | `checkout_screen.dart` |
| Screen: Profile | **Done** | `profile_screen.dart` |
| Implement all screens + navigation | **Mostly done** | See `/products` link gap above. |
| Responsive layouts | **Review** | Uses `SingleChildScrollView`, lists, horizontal category chips; no strong tablet/breakpoint strategy (e.g. `LayoutBuilder` / `MediaQuery` patterns). Worth tightening if markers stress responsiveness. |
| Clean project structure | **Done** | `lib/screens`, `lib/services`, `lib/widgets`, `lib/models` |
| Phase 1: No Firebase | N/A for current tree | App is wired for Phase 2 (Firebase in `main.dart`). Correct for final submission. |

---

## Phase 2 — Functional app (60%) — requirement matrix

### Authentication

| Requirement | Status | Where |
|-------------|--------|--------|
| User registration | **Done** | `auth_service.dart`, `register_screen.dart`, `ensureUserDoc()` |
| Login | **Done** | `auth_service.dart`, `login_screen.dart` |
| Logout | **Done** | `profile_screen.dart` → `AuthService.logout()` |

### Product management (Firestore)

| Requirement | Status | Notes |
|-------------|--------|--------|
| Display products from Firestore | **Done** | `firebase_service.dart` → `getProducts()`; used on Home and product list |
| Category browsing | **Done** | `getCategories()` / `getProductsByCategory()` on Home |
| Product images (URLs or Firebase Storage) | **Done (URL path)** | `Product` + `ProductImage` use network URLs. Firebase Storage package not added—URLs in Firestore satisfy the spec. |

### Cart

| Requirement | Status | Notes |
|-------------|--------|--------|
| Add, remove, update items | **Done** | `cart_service.dart`, `cart_screen.dart` |
| Persist cart data | **Done** | `shared_preferences` in `CartService` (device-local). Spec does not mandate cloud cart. |

### Checkout & orders

| Requirement | Status | Notes |
|-------------|--------|--------|
| Delivery details | **Done** | Phone + address on `checkout_screen.dart` |
| Place order → Firestore | **Done** | `CartService.placeOrder()` → `orders` collection |
| View order history | **Done** | `order_history_screen.dart`, `getOrderHistory()` |

**Firestore index:** `getOrderHistory()` uses `where('userId', ...)` + `orderBy('timestamp', descending: true)`. If queries fail at runtime, add the composite index Firebase Console suggests.

### User profile

| Requirement | Status | Where |
|-------------|--------|--------|
| View and update user details | **Done** | `firebase_service.dart` + `profile_screen.dart` (Firestore `users` + Auth display name) |

### Constraints from spec

| Constraint | Status | Notes |
|------------|--------|--------|
| Flutter | **OK** | |
| Firebase | **OK** | Core, Auth, Firestore in use |
| Android compatibility | **Verify** | Build/run on Android emulator or device before submit |
| No admin panel | **Review** | Profile includes **“Seeder (Admin)”** → `seeder_screen.dart`. Spec says customer app only, no admin panel. For submission, consider **removing or hiding** this entry so it does not look like an admin feature, and pre-seed Firestore separately (Console or one-off script). |
| Products pre-loaded into Firestore | **Your process** | Seeder helps; assignment still requires products actually present in Firestore for the demo/APK. |

---

## Final submission components (not all in repo)

| Deliverable | Status |
|-------------|--------|
| Complete Flutter source | **In repo** — keep private credentials out of ZIP if applicable |
| **Firebase setup instructions** | **Todo** — write a short `FIREBASE_SETUP.md` (or appendix in report): project creation, `google-services.json`, enable Email/Password Auth, Firestore rules, composite index for orders if needed |
| **Release APK** | **Todo** | `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk` |
| **Technical report** (max 10 pages, prescribed sections) | **Todo** | Introduction through References per PDF |
| **Video** (3–5 min, checklist in PDF) | **Todo** | Include register/login, browse, cart, checkout, order history, Firebase mention, device/emulator |

---

## Recommended code/product todos (priority)

1. [ ] Add visible navigation to **Product listing** (e.g. “See all” on Home → `/products`) so Phase 1 “Product Listing” screen is clearly part of the user flow.
2. [ ] Optional: add a **featured** strip (e.g. first N products, or `featured: true` in Firestore) to align with Home spec wording.
3. [ ] Improve **responsive** behaviour on large/small phones (optional polish).
4. [ ] **Remove or hide Seeder** from Profile for final hand-in; document how you loaded products instead.
5. [ ] Confirm **Firestore security rules** and **order query index** in Firebase Console.
6. [ ] Write **Firebase setup instructions** for whoever marks the work.
7. [ ] Run full **E2E demo path** once: register → browse → detail → cart → checkout → order history → profile edit → logout.
8. [ ] Build **release APK**, produce **report** and **video**.

---

## Quick “implemented” summary

- **Implemented in code:** Auth (register/login/logout), Firestore products + categories, cart with local persistence, checkout → orders in Firestore, order history, profile read/update, network product images, structured services (`auth_service`, `firebase_service`, `cart_service`).
- **Gaps vs ideal spec wording:** Featured area on Home, discoverable product listing route, explicit responsive design, “admin” seeder exposure, plus all **non-code** deliverables (Figma for Phase 1, setup doc, APK, report, video).

---

*Generated by comparing the official PDF specification to the `fashion-store-flutter-app-main` project structure and key Dart files.*
