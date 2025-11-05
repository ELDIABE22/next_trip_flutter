import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:next_trip/features/auth/infrastructure/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<firebase_auth.User?> get authStateChanges;
  firebase_auth.User? get currentUser;

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String cc,
    required String gender,
    required DateTime birthDate,
  });

  Future<void> resetPassword({required String email});

  Future<UserModel?> getCurrentUserData();

  Future<void> updateUserProfile({
    required String userId,
    Map<String, dynamic> userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  firebase_auth.User? get currentUser => firebaseAuth.currentUser;

  @override
  Stream<firebase_auth.User?> get authStateChanges =>
      firebaseAuth.authStateChanges();

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Error al iniciar sesión');
      }

      final userData = await getCurrentUserData();
      if (userData == null) {
        throw Exception('No se encontraron datos del usuario');
      }

      return userData;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String cc,
    required String gender,
    required DateTime birthDate,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Error al crear la cuenta');
      }

      final uid = userCredential.user!.uid;
      final user = UserModel(
        id: uid,
        fullName: fullName,
        email: normalizedEmail,
        phoneNumber: phoneNumber,
        cc: cc,
        gender: gender,
        birthDate: birthDate,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      try {
        await firebaseAuth.currentUser?.delete();
      } catch (_) {}
      throw _handleAuthException(e);
    } catch (e) {
      try {
        await firebaseAuth.currentUser?.delete();
      } catch (_) {}
      throw Exception('Error al crear el usuario: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (firebaseAuth.currentUser == null) return null;

      final doc = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener datos del usuario: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    Map<String, dynamic>? userData,
  }) async {
    try {
      await firestore.collection('users').doc(userId).update(userData ?? {});
    } catch (e) {
      throw Exception('Error al actualizar perfil: ${e.toString()}');
    }
  }

  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró una cuenta con este correo electrónico.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde.';
      case 'operation-not-allowed':
        return 'Operación no permitida.';
      case 'invalid-credential':
        return 'Las credenciales proporcionadas son inválidas.';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
