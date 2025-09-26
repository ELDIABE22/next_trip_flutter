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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'cc': cc,
      'gender': gender,
      'email': email,
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
      'type': type.name,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      cc: map['cc'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      birthDate: DateTime.parse(map['birthDate'] ?? ''),
      type: _parsePassengerType(map['type'] ?? ''),
    );
  }

  static PassengerType _parsePassengerType(dynamic typeValue) {
    if (typeValue is PassengerType) return typeValue;
    if (typeValue is String) {
      return PassengerType.values.firstWhere(
        (e) => e.name.toLowerCase() == typeValue.toString().toLowerCase(),
        orElse: () => PassengerType.adult,
      );
    }
    return PassengerType.adult;
  }

  Passenger copyWith({
    String? id,
    String? fullName,
    String? cc,
    String? gender,
    String? email,
    String? phone,
    DateTime? birthDate,
    PassengerType? type,
  }) {
    return Passenger(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      cc: cc ?? this.cc,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      type: type ?? this.type,
    );
  }
}
