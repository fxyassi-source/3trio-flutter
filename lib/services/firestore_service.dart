import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
 final db=FirebaseFirestore.instance;
 Future<void> saveProfile(String uid,Map<String,dynamic> data)=>db.collection('users').doc(uid).set({...data,'updatedAt':FieldValue.serverTimestamp()},SetOptions(merge:true));
 Stream<QuerySnapshot<Map<String,dynamic>>> profiles()=>db.collection('users').limit(50).snapshots();
 Future<void> like(String from,String to)=>db.collection('likes').doc('${from}_${to}').set({'from':from,'to':to,'createdAt':FieldValue.serverTimestamp()});
 Future<void> sendMessage(String chatId,String sender,String text)=>db.collection('chats').doc(chatId).collection('messages').add({'senderId':sender,'text':text,'createdAt':FieldValue.serverTimestamp()});
 Stream<QuerySnapshot<Map<String,dynamic>>> messages(String chatId)=>db.collection('chats').doc(chatId).collection('messages').orderBy('createdAt').snapshots();
}