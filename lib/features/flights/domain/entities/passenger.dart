enum PassengerType { adult, child, infant }

class Passenger {
  final String id;
  final String fullName;
  final String cc;
  final String gender;
  final String email;
  final String phone;
  final DateTime birthDate;
  final PassengerType type;

  const Passenger({
    required this.id,
    required this.fullName,
    required this.cc,
    required this.gender,
    required this.email,
    required this.phone,
    required this.birthDate,
    this.type = PassengerType.adult,
  });

  Passenger copyWith({
    String? fullName,
    String? cc,
    String? gender,
    String? email,
    String? phone,
    DateTime? birthDate,
    PassengerType? type,
  }) {
    return Passenger(
      id: id,
      fullName: fullName ?? this.fullName,
      cc: cc ?? this.cc,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
