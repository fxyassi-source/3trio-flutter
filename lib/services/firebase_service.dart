import 'package:firebase_core/firebase_core.dart';
class FirebaseService {
  static const options = FirebaseOptions(
    apiKey:'AIzaSyAMw604ulgtR7fE7UslnmGc7uYmPT3DxGQ',
    appId:'1:288437353187:android:bd4daa1c2e9fe560b123d6',
    messagingSenderId:'288437353187',
    projectId:'threetrio-43aec',
    storageBucket:'threetrio-43aec.firebasestorage.app',
  );
  static Future<void> init() async { if(Firebase.apps.isEmpty) await Firebase.initializeApp(options:options); }
}