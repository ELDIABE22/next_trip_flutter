class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String cc;
  final String gender;
  final DateTime birthDate;
  final DateTime createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.cc,
    required this.gender,
    required this.birthDate,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? cc,
    String? gender,
    DateTime? birthDate,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cc: cc ?? this.cc,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
