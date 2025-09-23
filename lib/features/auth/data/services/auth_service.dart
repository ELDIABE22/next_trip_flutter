import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/features/auth/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener el usuario actual
  User? get currentUser => _auth.currentUser;

  // Flujo de cambios de estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Iniciar sesión
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error al cerrar sesión: ${e.toString()}';
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error inesperado: ${e.toString()}';
    }
  }

  // Registrar un nuevo usuario con correo electrónico y contraseña
  Future<UserCredential> registerWithEmailAndPassword({
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
      final normalizedPhone = phoneNumber.trim();
      final normalizedCc = cc.trim();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        final user = UserModel(
          id: uid,
          fullName: fullName,
          email: normalizedEmail,
          phoneNumber: normalizedPhone,
          cc: normalizedCc,
          gender: gender,
          birthDate: birthDate,
        );

        final usersRef = _firestore.collection('users').doc(uid);
        final emailRef = _firestore
            .collection('unique_emails')
            .doc(normalizedEmail);
        final phoneRef = _firestore
            .collection('unique_phoneNumbers')
            .doc(normalizedPhone);
        final ccRef = _firestore.collection('unique_cc').doc(normalizedCc);

        try {
          await _firestore.runTransaction((tx) async {
            final emailSnap = await tx.get(emailRef);
            if (emailSnap.exists) {
              throw 'El correo ya está registrado.';
            }

            final phoneSnap = await tx.get(phoneRef);
            if (phoneSnap.exists) {
              throw 'El teléfono ya está registrado.';
            }

            final ccSnap = await tx.get(ccRef);
            if (ccSnap.exists) {
              throw 'La cédula ya está registrada.';
            }

            tx.set(usersRef, user.toMap());
            tx.set(emailRef, {
              'uid': uid,
              'createdAt': DateTime.now().toIso8601String(),
            });
            tx.set(phoneRef, {
              'uid': uid,
              'createdAt': DateTime.now().toIso8601String(),
            });
            tx.set(ccRef, {
              'uid': uid,
              'createdAt': DateTime.now().toIso8601String(),
            });
          });
        } catch (e) {
          try {
            await _auth.currentUser?.delete();
          } catch (_) {}
          rethrow;
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      try {
        await _auth.currentUser?.delete();
      } catch (_) {}
      throw 'Error al crear el usuario: ${e.toString()}';
    }
  }

  // Obtener datos de usuario actuales de Firestore
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (_auth.currentUser == null) return null;

      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error getting user data: ${e.toString()}';
    }
  }

  // Actualizar el perfil de usuario
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? cc,
    String? gender,
    DateTime? birthDate,
  }) async {
    try {
      final userData = <String, dynamic>{};

      if (fullName != null) userData['fullName'] = fullName;
      if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
      if (cc != null) userData['cc'] = cc;
      if (gender != null) userData['gender'] = gender;
      if (birthDate != null) {
        userData['birthDate'] = birthDate.toIso8601String();
      }

      await _firestore.collection('users').doc(userId).update(userData);
    } catch (e) {
      throw 'Error updating user profile: ${e.toString()}';
    }
  }

  // Manejar excepciones de Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
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
