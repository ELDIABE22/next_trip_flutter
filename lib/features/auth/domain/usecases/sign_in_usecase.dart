import 'package:next_trip/features/auth/domain/entities/user.dart';
import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User> call({required String email, required String password}) async {
    if (email.trim().isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (password.isEmpty) {
      throw Exception('La contraseña es requerida');
    }

    return await repository.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}
