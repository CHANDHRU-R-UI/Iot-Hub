import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  Future<void> signInWithEmail(String email, String password) async {
    // try {
    //   UserCredential userCredential = await _auth.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   _user = userCredential.user;
    //   notifyListeners();
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<void> signOut() async {
    // await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
