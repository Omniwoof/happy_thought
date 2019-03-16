import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';


class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;


  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService(){
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser user) {
      if (user != null) {
        return _db
            .collection('users')
            .document(user.uid)
            .snapshots()
            .map((snapshot) => snapshot.data);
      }
      else {
        return Observable.just({});
      }
    });

    }




Future<FirebaseUser> googleSignIn() async {
    loading.add(true);

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = await _auth.signInWithCredential(credential);

//  FirebaseUser user = await _auth.signInWithGoogle(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    updateUserData(user);

    loading.add(false);
    print('Signed In: ${user.displayName}');
    return user;
  }

void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid' : user.uid,
      'email' : user.email,
      'photoUrl' : user.photoUrl,
      'displayName' : user.displayName,
      //TODO: fix datetime implementation
      'lastSeen' : DateTime.now()
    }, merge: true);


  }

  void signOut() {
  _auth.signOut();

  }

}

// TODO: Replace global variable with Inhertited Widget or similar.
final AuthService authService = AuthService();