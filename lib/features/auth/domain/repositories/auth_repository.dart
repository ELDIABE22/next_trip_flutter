import 'package:next_trip/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String cc,
    required String gender,
    required DateTime birthDate,
  });

  Future<void> resetPassword({required String email});

  Future<User?> getCurrentUserData();

  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? cc,
    String? gender,
    DateTime? birthDate,
  });
}
