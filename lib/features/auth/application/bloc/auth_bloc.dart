import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_trip/features/auth/application/bloc/auth_event.dart';
import 'package:next_trip/features/auth/application/bloc/auth_state.dart';
import 'package:next_trip/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/register_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:next_trip/features/auth/domain/usecases/update_profile_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.registerUseCase,
    required this.resetPasswordUseCase,
    required this.updateProfileUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
    on<AuthFetchUserDataRequested>(_onFetchUserDataRequested);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await signOutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        cc: event.cc,
        gender: event.gender,
        birthDate: event.birthDate,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase(email: event.email);
      emit(
        const AuthPasswordResetSent(
          'Se ha enviado un enlace de recuperación a tu correo',
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await updateProfileUseCase(
        userId: event.userId,
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        cc: event.cc,
        gender: event.gender,
        birthDate: event.birthDate,
      );

      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthProfileUpdated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onFetchUserDataRequested(
    AuthFetchUserDataRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}
