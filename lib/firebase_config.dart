// firebase_config.dart
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyDzsQKcQxWd-YrI0ISGohjM_wqHKRf7tTo",
    authDomain: "readings-915a0.firebaseapp.com",
    projectId: "readings-915a0",
    storageBucket: "readings-915a0.firebasestorage.app",
    messagingSenderId: "709530263637",
    appId: "1:709530263637:web:d0c7e22f50954098dbb4dc",
  );

  static Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(options: options);
  }
}
