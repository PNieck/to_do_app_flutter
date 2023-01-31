import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app_flutter/data/models/user.dart';

class UserException implements Exception {
  String cause;
  UserException(this.cause);
}

class UserRepository {
  FirebaseAuth auth;
  late Stream<AppUser?> userStateStream;

  UserRepository() : auth = FirebaseAuth.instance {
    userStateStream = auth.userChanges().map((user) {
      if (user == null) return null;

      return AppUser(
          id: user.uid,
          email: user.email!,
          name: user.displayName,
          photo: user.photoURL);
    });
  }

  Future<void> logInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw UserException('Wrong password provided for that user.');
      }
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw UserException(e.code);
    }
  }

  Future<void> signUp(AppUser user, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: "barry.allen@example.com", password: "SuperSecretPassword!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw UserException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw UserException('The account already exists for that email.');
      }
    }
  }
}
