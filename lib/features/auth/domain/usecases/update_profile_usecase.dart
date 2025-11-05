import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? cc,
    String? gender,
    DateTime? birthDate,
  }) async {
    await repository.updateUserProfile(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      cc: cc,
      gender: gender,
      birthDate: birthDate,
    );
  }
}
