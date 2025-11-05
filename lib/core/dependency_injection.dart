import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:next_trip/features/auth/application/bloc/auth_bloc.dart';
import 'package:next_trip/features/auth/domain/repositories/auth_repository.dart';
import 'package:next_trip/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/register_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:next_trip/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:next_trip/features/auth/infrastructure/repositories/auth_repository_impl.dart';

void setupDependencies() {
  // Firebase instances
  Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance);
  Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data sources
  Get.lazyPut<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: Get.find<FirebaseAuth>(),
      firestore: Get.find<FirebaseFirestore>(),
    ),
  );

  // Repositories
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
  );

  // Use cases
  Get.lazyPut(() => SignInUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => SignOutUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => ResetPasswordUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => UpdateProfileUseCase(Get.find<AuthRepository>()));
  Get.lazyPut(() => GetCurrentUserUseCase(Get.find<AuthRepository>()));

  // BLoC
  Get.put<AuthBloc>(
    AuthBloc(
      signInUseCase: Get.find<SignInUseCase>(),
      signOutUseCase: Get.find<SignOutUseCase>(),
      registerUseCase: Get.find<RegisterUseCase>(),
      resetPasswordUseCase: Get.find<ResetPasswordUseCase>(),
      updateProfileUseCase: Get.find<UpdateProfileUseCase>(),
      getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
    ),
    permanent: true,
  );
}
