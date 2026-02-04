import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();
  final _db = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    final googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final result = await _auth.signInWithCredential(credential);
    final user = result.user!;

    final ref = _db.collection('users').doc(user.uid);
    if (!(await ref.get()).exists) {
      await ref.set({
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> logout() async {
    await _google.signOut();
    await _auth.signOut();
  }
}
