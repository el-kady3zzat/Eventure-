// Use it anywhere in the app
import 'package:eventure/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get currentUserId {
  return getIt<FirebaseAuth>().currentUser?.uid ?? '';
}
