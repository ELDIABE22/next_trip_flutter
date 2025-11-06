import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/passenger.dart';

class PassengerModel extends Passenger {
  PassengerModel({
    required super.id,
    required super.fullName,
    required super.cc,
    required super.gender,
    required super.email,
    required super.phone,
    required super.birthDate,
    super.type = PassengerType.adult,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'cc': cc,
      'gender': gender,
      'email': email,
      'phone': phone,
      'birthDate': Timestamp.fromDate(birthDate),
      'type': type.name,
    };
  }

  factory PassengerModel.fromMap(String id, Map<String, dynamic> map) {
    return PassengerModel(
      id: id,
      fullName: map['fullName'],
      cc: map['cc'],
      gender: map['gender'],
      email: map['email'],
      phone: map['phone'],
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      type: PassengerType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PassengerType.adult,
      ),
    );
  }

  factory PassengerModel.fromEntity(Passenger passenger) {
    return PassengerModel(
      id: passenger.id,
      fullName: passenger.fullName,
      cc: passenger.cc,
      gender: passenger.gender,
      email: passenger.email,
      phone: passenger.phone,
      birthDate: passenger.birthDate,
      type: passenger.type,
    );
  }
}

