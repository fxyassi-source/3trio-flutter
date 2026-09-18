import 'dart:io'; import 'package:firebase_storage/firebase_storage.dart';
class StorageService {
 final storage=FirebaseStorage.instance;
 Future<String> upload(String uid,File file,int index) async { final ref=storage.ref('users/$uid/photos/$index.jpg'); await ref.putFile(file); return ref.getDownloadURL(); }
}