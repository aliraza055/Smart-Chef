# SmartChef Monorepo

This repository now contains a clean monorepo structure for the SmartChef product:

## Structure

- App/ — existing Flutter mobile application
- Admin/ — separate Next.js admin panel foundation

## Apps

### Flutter App
The original SmartChef mobile application was preserved and moved into the App directory without changing the project architecture or existing feature set.

Quick start:

```bash
cd App
flutter pub get
flutter run
```

### Admin App
A separate Next.js + TypeScript + Tailwind application was initialized for the admin panel foundation.

Quick start:

```bash
cd Admin
npm install
npm run dev
```

Production build check:

```bash
cd Admin
npm run build
```

## Notes

- The Flutter app remains independent and runnable from the App folder.
- The Next.js admin app remains independent and runnable from the Admin folder.
- Firebase and existing Flutter app configuration were kept intact as part of the move.
