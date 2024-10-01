import 'package:chat_app/features/chat/data/repos/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();

  Future<User?> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signUp(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print("user credential is $userCredential");

    await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userCredential.user!.uid)
        .set({
      'userName': userCredential.user!.displayName,
      'email': userCredential.user!.email,
      'avatarUrl': userCredential.user!.photoURL,
    });
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _storage.delete(key: 'authToken');
  }
}
