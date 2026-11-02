# Project Notes

## Overview
Munjiz: offline-first task and daily routine tracker (Flutter, Firebase). Version 1.0.0+1. Not a git repository.

## Structure
- lib/: app, bindings, controllers, core, data, views, firebase_options.dart, main.dart
- lib/data/services/: firebase_bootstrap, push_service (FCM), notification_service (local)
- assets/, test/, tool/, android/, windows/ (no ios/)
- firestore.rules: Firestore security rules (users/{uid}/** covers device tokens)

## Key decisions
- App runs local-only until Firebase is configured (FirebaseBootstrap catches the failure).
- FCM: devices subscribe to topic daily_motivation; tokens saved at users/{uid}/devices/{token}.
- Pushes use channel munjiz_reminders. Foreground pushes are shown via NotificationService.showNow.
- Reminder ids are 0..13; push ids start above that. reschedule cancels reminder ids only.
- PushService waits for NotificationService.startup, so permission prompts do not overlap.

## Current status
- FCM client code done; not analyzed, built, or tested on a device.
- NOT working yet: lib/firebase_options.dart is a placeholder and google-services.json is missing.
- No server sender exists; send from Firebase Console to the topic.

## Next steps
1. Set the final applicationId (currently com.example.munjiz) before registering with Firebase.
2. Run flutterfire configure --project=munjiz-bf8d3 --platforms=android (project has no apps registered yet; CLI is in the pub cache, not on PATH).
3. Test on a device: foreground, background, and closed app.
