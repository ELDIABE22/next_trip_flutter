import 'dart:convert';
import 'package:http/http.dart' as http;

class DestinationService {
  static const String _base = 'https://countriesnow.space/api/v0.1';
  final http.Client _client;
  DestinationService([http.Client? client]) : _client = client ?? http.Client();

  Future<List<String>> fetchCountries() async {
    final uri = Uri.parse('$_base/countries');
    final resp = await _client.get(uri).timeout(const Duration(seconds: 12));

    if (resp.statusCode != 200) {
      throw Exception('Error del servidor: ${resp.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(resp.body);
    if (json['error'] == true) {
      throw Exception(json['msg'] ?? 'Error al obtener países');
    }

    final List<dynamic> data = json['data'] as List<dynamic>;
    final names = data.map<String>((e) => e['country'].toString()).toList();
    names.sort((a, b) => a.compareTo(b));
    return names;
  }

  Future<List<String>> fetchCities(String country) async {
    final uri = Uri.parse('$_base/countries/cities/q?country=$country');
    final resp = await _client.get(uri).timeout(const Duration(seconds: 12));

    if (resp.statusCode != 200) {
      throw Exception('Error del servidor: ${resp.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(resp.body);
    if (json['error'] == true) {
      throw Exception(json['msg'] ?? 'Error al obtener ciudades');
    }

    final data = json['data'];
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    throw Exception('Formato inesperado');
  }
}
