import 'package:flutter/foundation.dart';

/// Platform capability checks. Firebase, FCM and scheduled local
/// notifications run on Android / iOS; other platforms stay local-only.
abstract final class AppPlatform {
  static bool get supportsMobileServices =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
}
