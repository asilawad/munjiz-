import 'package:firebase_auth/firebase_auth.dart';

/// Anonymous sign-in: gives each install a private cloud space without a
/// login screen. Returns null while offline on the very first launch.
class AuthService {
  Future<String?> ensureSignedIn() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser ?? (await auth.signInAnonymously()).user;
      return user?.uid;
    } catch (_) {
      return null;
    }
  }
}
