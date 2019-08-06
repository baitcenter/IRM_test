import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irm_test/z_services/auth_service/auth_service.dart';

class AuthServiceFirebase extends AuthService {
  String token;
  DateTime tokenCreationDate;
  int tokenLifetimeInMinutes = 5;

  @override
  Future<String> submitPhoneNumber({String phoneNumber}) async {
    Completer<String> c = Completer();

    PhoneCodeSent codeSent = (verificationId, [forceResendingToken]) {
      print('SMS sent');
      c.complete(verificationId);
    };

    PhoneVerificationFailed phoneVerificationFailed = (authException) {
      print('phone verification failed');
      print(authException.message);
      c.completeError(Error());
    };

    PhoneVerificationCompleted phoneVerificationCompleted = (firebaseUser) {
      print('phone verif OK');
      c.complete('');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 0),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: null);
    return c.future;
  }

  @override
  Future<UserAuthData> confirmSMSCode(
      {String verificationId, String smsCode}) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    var firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return UserAuthData(
        uid: firebaseUser.uid, phoneNr: firebaseUser.phoneNumber ?? '');
  }

  @override
  Future<UserAuthData> getCurrentUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) return UserAuthData(uid: null, phoneNr: '');
    return UserAuthData(
        uid: firebaseUser.uid, phoneNr: firebaseUser.phoneNumber ?? '');
  }

  @override
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> getToken() async {
    if (_tokenIsExpired()) {
      await _refreshToken();
    }
    return token;
  }

  bool _tokenIsExpired() {
    if (token == null) return true;
    if (token != null &&
        DateTime.now().difference(tokenCreationDate).abs().inMinutes >
            tokenLifetimeInMinutes) return true;
    return false;
  }

  Future<void> _refreshToken() async {
    var user = await FirebaseAuth.instance.currentUser();
    tokenCreationDate = DateTime.now();
    token = await user.getIdToken();
  }
}
