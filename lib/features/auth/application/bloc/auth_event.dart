import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final String cc;
  final String gender;
  final DateTime birthDate;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.cc,
    required this.gender,
    required this.birthDate,
  });

  @override
  List<Object> get props => [
    email,
    password,
    fullName,
    phoneNumber,
    cc,
    gender,
    birthDate,
  ];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String userId;
  final String? fullName;
  final String? phoneNumber;
  final String? cc;
  final String? gender;
  final DateTime? birthDate;

  const AuthUpdateProfileRequested({
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.cc,
    this.gender,
    this.birthDate,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    phoneNumber,
    cc,
    gender,
    birthDate,
  ];
}

class AuthFetchUserDataRequested extends AuthEvent {}

class AuthErrorCleared extends AuthEvent {}
