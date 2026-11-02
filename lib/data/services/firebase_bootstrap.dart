import 'package:firebase_core/firebase_core.dart';

import '../../core/utils/app_platform.dart';
import '../../firebase_options.dart';

/// Initializes Firebase when possible. If the platform is unsupported or
/// `flutterfire configure` has not been run, the app simply stays local-only.
abstract final class FirebaseBootstrap {
  static bool isReady = false;

  static Future<bool> init() async {
    if (!AppPlatform.supportsMobileServices) return false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isReady = true;
    } catch (_) {
      isReady = false;
    }
    return isReady;
  }
}
