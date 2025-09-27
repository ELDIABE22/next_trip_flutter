import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlightPrefs {
  static const _kOriginCountry = 'originCountry';
  static const _kOriginCity = 'originCity';
  static const _kDestCountry = 'destinationCountry';
  static const _kDestCity = 'destinationCity';

  static Future<SharedPreferences> get _instance async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      WidgetsFlutterBinding.ensureInitialized();
      return await SharedPreferences.getInstance();
    }
  }

  static Future<void> saveSelection({
    String? originCountry,
    String? originCity,
    String? destinationCountry,
    String? destinationCity,
  }) async {
    try {
      final prefs = await _instance;
      if (originCountry != null) {
        await prefs.setString(_kOriginCountry, originCountry);
      }
      if (originCity != null) {
        await prefs.setString(_kOriginCity, originCity);
      }
      if (destinationCountry != null) {
        await prefs.setString(_kDestCountry, destinationCountry);
      }
      if (destinationCity != null) {
        await prefs.setString(_kDestCity, destinationCity);
      }
    } catch (e) {
      debugPrint('Error saving flight preferences: $e');
      // You might want to handle this error in your UI or retry logic
    }
  }

  static Future<Map<String, String?>> loadSelection() async {
    try {
      final prefs = await _instance;
      return {
        'originCountry': prefs.getString(_kOriginCountry),
        'originCity': prefs.getString(_kOriginCity),
        'destinationCountry': prefs.getString(_kDestCountry),
        'destinationCity': prefs.getString(_kDestCity),
      };
    } catch (e) {
      debugPrint('Error loading flight preferences: $e');
      return {
        'originCountry': null,
        'originCity': null,
        'destinationCountry': null,
        'destinationCity': null,
      };
    }
  }

  static Future<void> clear() async {
    try {
      final prefs = await _instance;
      await prefs.remove(_kOriginCountry);
      await prefs.remove(_kOriginCity);
      await prefs.remove(_kDestCountry);
      await prefs.remove(_kDestCity);
    } catch (e) {
      debugPrint('Error clearing flight preferences: $e');
    }
  }
}
