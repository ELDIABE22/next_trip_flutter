import 'package:next_trip/features/auth/domain/entities/user.dart';
import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUserData();
  }
}
