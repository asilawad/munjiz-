import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_strings.dart';
import '../../firebase_options.dart';
import 'auth_service.dart';
import 'notification_service.dart';

/// Must be a top-level function: runs in its own isolate when a push arrives
/// while the app is in the background or closed (the system shows the
/// notification itself; this only needs Firebase to be initialized).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/// Firebase Cloud Messaging: permission, topic, device token, and showing
/// pushes that arrive while the app is open.
class PushService extends GetxService {
  PushService(this._auth, this._notifications);

  final AuthService _auth;
  final NotificationService _notifications;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onReady() {
    super.onReady();
    start();
  }

  Future<void> start() async {
    // Android rejects overlapping prompts, so wait for the local one to finish.
    await _notifications.startup;
    try {
      final NotificationSettings settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      _messaging.onTokenRefresh.listen(_saveToken);
      await _saveToken(await _messaging.getToken());
    } catch (_) {
      return;
    }
    try {
      await _messaging.subscribeToTopic(AppConfig.fcmTopic);
    } catch (_) {
      // iOS without an APNs token yet; retried on the next launch.
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    if (notification == null) return;
    await _notifications.showNow(
      title: notification.title ?? AppStrings.appName,
      body: notification.body ?? '',
    );
  }

  Future<void> _saveToken(String? token) async {
    final String? uid = await _auth.ensureSignedIn();
    if (uid == null || token == null) return;
    unawaited(
      FirebaseFirestore.instance
          .collection(AppConfig.usersCollection)
          .doc(uid)
          .collection(AppConfig.devicesCollection)
          .doc(token)
          .set(<String, dynamic>{
            'platform': defaultTargetPlatform.name,
            'updatedAt': FieldValue.serverTimestamp(),
          })
          .catchError((Object _) {}),
    );
  }
}
