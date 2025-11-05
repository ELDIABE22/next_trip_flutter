import 'package:next_trip/features/auth/domain/entities/user.dart';
import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';
import 'package:next_trip/features/auth/infrastructure/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<User?> get authStateChanges =>
      remoteDataSource.authStateChanges.map((firebaseUser) {
        if (firebaseUser == null) return null;
        return null;
      });

  @override
  User? get currentUser {
    final firebaseUser = remoteDataSource.currentUser;
    if (firebaseUser == null) return null;
    return null;
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel;
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String cc,
    required String gender,
    required DateTime birthDate,
  }) async {
    final userModel = await remoteDataSource.registerWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
      cc: cc,
      gender: gender,
      birthDate: birthDate,
    );
    return userModel;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await remoteDataSource.resetPassword(email: email);
  }

  @override
  Future<User?> getCurrentUserData() async {
    final userModel = await remoteDataSource.getCurrentUserData();
    return userModel;
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? cc,
    String? gender,
    DateTime? birthDate,
  }) async {
    final userData = <String, dynamic>{};

    if (fullName != null) userData['fullName'] = fullName;
    if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
    if (cc != null) userData['cc'] = cc;
    if (gender != null) userData['gender'] = gender;
    if (birthDate != null) userData['birthDate'] = birthDate.toIso8601String();

    await remoteDataSource.updateUserProfile(
      userId: userId,
      userData: userData,
    );
  }
}
