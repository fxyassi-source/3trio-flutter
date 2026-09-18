import 'package:firebase_messaging/firebase_messaging.dart';
class NotificationService {
 static Future<void> init() async { final m=FirebaseMessaging.instance; await m.requestPermission(alert:true,badge:true,sound:true); await m.getToken(); }
}