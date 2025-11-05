import 'package:next_trip/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.cc,
    required super.gender,
    required super.birthDate,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'cc': cc,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      cc: map['cc'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: DateTime.parse(map['birthDate']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      cc: user.cc,
      gender: user.gender,
      birthDate: user.birthDate,
      createdAt: user.createdAt,
    );
  }
}
