import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_trip/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:next_trip/features/hotels/infrastructure/models/hotel_model.dart';

class HotelRemoteDataSource implements HotelRepository {
  final FirebaseFirestore firestore;

  HotelRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<HotelModel>> getAllHotels() async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('hotels')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return HotelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching hotels: $e');
    }
  }

  @override
  Future<HotelModel?> getHotelById({required String id}) async {
    try {
      final DocumentSnapshot doc = await firestore
          .collection('hotels')
          .doc(id)
          .get();

      if (!doc.exists) {
        return null;
      }

      return HotelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching hotel by ID: $e');
    }
  }

  @override
  Future<List<HotelModel>> getHotelsByCity({
    required String city,
    String? country,
  }) async {
    try {
      Query query = firestore
          .collection('hotels')
          .where('city', isEqualTo: city);

      if (country != null && country.isNotEmpty) {
        query = query.where('country', isEqualTo: country);
      }

      final QuerySnapshot snapshot = await query
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return HotelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching hotels by city: $e');
    }
  }

  @override
  Stream<List<HotelModel>> getHotelsByCityStream({
    required String city,
    String? country,
  }) {
    Query query = firestore
        .collection('hotels')
        .where('city', isEqualTo: city)
        .where('isAvailable', isEqualTo: true);

    if (country != null && country.isNotEmpty) {
      query = query.where('country', isEqualTo: country);
    }

    return query.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return HotelModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Stream<List<HotelModel>> getHotelsStream() {
    return firestore
        .collection('hotels')
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return HotelModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  @override
  Future<void> hotelRefresh() async {
    await getAllHotels();
  }
}
