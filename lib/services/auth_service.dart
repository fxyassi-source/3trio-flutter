import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
 final auth=FirebaseAuth.instance;
 Stream<User?> get user=>auth.authStateChanges();
 Future<UserCredential?> google() async {
   final account=await GoogleSignIn().signIn(); if(account==null)return null;
   final tokens=await account.authentication;
   return auth.signInWithCredential(GoogleAuthProvider.credential(accessToken:tokens.accessToken,idToken:tokens.idToken));
 }
 Future<void> phone(String number, {required void Function(String) codeSent, required void Function(PhoneAuthCredential) verified, required void Function(FirebaseAuthException) failed}) async {
   await auth.verifyPhoneNumber(phoneNumber:number,verificationCompleted:verified,verificationFailed:failed,codeSent:(id,_){codeSent(id);},codeAutoRetrievalTimeout:(_){});
 }
 Future<UserCredential> verify(String verificationId,String code)=>auth.signInWithCredential(PhoneAuthProvider.credential(verificationId:verificationId,smsCode:code));
 Future<void> signOut()=>auth.signOut();
}