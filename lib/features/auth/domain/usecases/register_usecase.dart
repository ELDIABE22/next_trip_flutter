import 'package:next_trip/features/auth/domain/entities/user.dart';
import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String cc,
    required String gender,
    required DateTime birthDate,
  }) async {
    if (email.trim().isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }

    if (fullName.trim().isEmpty) {
      throw Exception('El nombre completo es requerido');
    }

    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
      cc: cc,
      gender: gender,
      birthDate: birthDate,
    );
  }
}
