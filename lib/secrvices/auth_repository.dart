// ignore_for_file: prefer_initializing_formals
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Custom exception to surface authentication errors with localized Arabic messages.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}

/// Repository handling all authentication related operations.
class AuthRepository {
  final FirebaseAuth? _auth;
  final FirestoreServices? _firestore;

  FirebaseAuth get auth => _auth ?? FirebaseAuth.instance;
  FirestoreServices get firestore => _firestore ?? FirestoreServices.instance;

  AuthRepository._()
      : _auth = null,
        _firestore = null;

  AuthRepository.forTesting({FirebaseAuth? auth, FirestoreServices? firestore})
      : _auth = auth,
        _firestore = firestore;

  static final AuthRepository instance = AuthRepository._();

  /// Stream that notifies about authentication state changes.
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Sign up using email & password. Also creates a user document in Firestore.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = cred.user;
      if (user == null) {
        throw AuthException('فشل إنشاء الحساب، يرجى المحاولة مرة أخرى');
      }
      // Save user data to Firestore.
      await firestore.setData(
        path: 'users/${user.uid}',
        data: {
          'uid': user.uid,
          'name': name,
          'email': user.email,
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_firebaseErrorMessage(e.code));
    }
  }

  /// Sign in using email & password.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_firebaseErrorMessage(e.code));
    }
  }

  /// Sign in with Google.
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign‑in flow.
        throw AuthException('تم إلغاء تسجيل الدخول عبر Google');
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await firestore.setData(
          path: 'users/${user.uid}',
          data: {
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email,
            'photoUrl': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_firebaseErrorMessage(e.code));
    } catch (_) {
      throw AuthException('خطأ غير معروف أثناء تسجيل الدخول عبر Google');
    }
  }

  /// Sign in with Facebook.
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw AuthException('فشل تسجيل الدخول عبر Facebook');
      }
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      final userCredential = await auth.signInWithCredential(facebookAuthCredential);
      final user = userCredential.user;
      if (user != null) {
        await firestore.setData(
          path: 'users/${user.uid}',
          data: {
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email,
            'photoUrl': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_firebaseErrorMessage(e.code));
    } catch (_) {
      throw AuthException('خطأ غير معروف أثناء تسجيل الدخول عبر Facebook');
    }
  }

  /// Sign out the current user safely from Firebase, Google, and Facebook.
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (_) {}

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  /// Helper to translate Firebase error codes to Arabic messages.
  String _firebaseErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'تم تعطيل حساب المستخدم';
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة في حساب Firebase';
      case 'weak-password':
        return 'كلمة المرور ضعيفة، يرجى اختيار كلمة أقوى';
      default:
        return 'خطأ غير معروف، يرجى المحاولة مرة أخرى';
    }
  }
}
