import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../utils/logger_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signs in the user with email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      LoggerService.info('User signed in: ${userCredential.user?.email}');
      return UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
    } on FirebaseAuthException catch (e) {
      LoggerService.error('Failed to sign in: ${e.message}');
      throw Exception('Failed to sign in: ${e.message}');
    }
  }

  // Registers a new user with email and password
  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      LoggerService.info('User signed up: ${userCredential.user?.email}');
      return UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
    } on FirebaseAuthException catch (e) {
      LoggerService.error('Failed to sign up: ${e.message}');
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  // Signs out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      LoggerService.info('User signed out');
    } catch (e) {
      LoggerService.error('Failed to sign out: ${e.message}');
      throw Exception('Failed to sign out: ${e.message}');
    }
  }

  // Checks if a user is currently signed in
  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      LoggerService.info('Current user: ${user.email}');
      return UserModel(
        uid: user.uid,
        email: user.email!,
      );
    }
    LoggerService.warning('No user currently signed in');
    return null;
  }

  // Sends a password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      LoggerService.info('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      LoggerService.error('Failed to send password reset email: ${e.message}');
      throw Exception('Failed to send password reset email: ${e.message}');
    }
  }
}
