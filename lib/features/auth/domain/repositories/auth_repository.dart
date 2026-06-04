import 'package:tracker_flutter/features/auth/domain/entities/auth_user.dart';

abstract class IAuthRepository {
  Stream<AuthUser?> get authStateChanges;
  Future<AuthUser?> signInWithEmailAndPassword(String email, String password);
  Future<AuthUser?> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  AuthUser? get currentUser;
}
