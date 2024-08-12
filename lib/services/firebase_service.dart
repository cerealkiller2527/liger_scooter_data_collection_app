import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart'; // Corrected import

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authenticates the user using email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in: ${e.message}');
    }
  }

  // Registers a new user using email and password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  // Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Saves a session to Firestore under the authenticated user's ID
  Future<void> saveSession(SessionModel session) async {
    try {
      final String userId = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('sessions').add(session.toMap());
    } catch (e) {
      throw Exception('Failed to save session: $e');
    }
  }

  // Fetches all sessions for the authenticated user from Firestore
  Future<List<SessionModel>> fetchSessions() async {
    try {
      final String userId = _auth.currentUser!.uid;
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .get();

      return snapshot.docs.map((doc) => SessionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch sessions: $e');
    }
  }
}
