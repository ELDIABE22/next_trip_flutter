import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({required String email}) async {
    if (email.trim().isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }
    
    await repository.resetPassword(email: email.trim());
  }
}
