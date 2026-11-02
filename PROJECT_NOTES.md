# Project Notes

## Current status
- Munjiz: offline-first task and routine tracker (Flutter, Firebase). Android only for FCM. Not a git repository.
- Package id is com.ajyal.munjiz. MainActivity moved to match.
- Android app registered in Firebase project munjiz-bf8d3. firebase_options.dart and google-services.json generated; Google Services plugin applied.
- FCM client done: topic daily_motivation; tokens at users/{uid}/devices/{token}; channel munjiz_reminders.
- flutter analyze: no issues. Not built or tested on a device.
- No server sender; pushes are sent from Firebase Console.

## Next steps
1. User tests on a device: foreground, background, closed.
