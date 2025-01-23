import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = 'http://10.0.2.2:5000';

  // Updated login method to accept an identifier (username, email, or phone)
  static Future<Map<String, dynamic>> loginUser(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'identifier': identifier, // Pass identifier instead of username
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse response JSON
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception('Login failed: ${errorResponse['message']}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Register a new salon owner
  static Future<Map<String, dynamic>> registerSalonOwner(Map<String, String> salonOwnerData) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register/salon_owner'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(salonOwnerData),
      );

      if (response.statusCode == 201) {
        // Successful registration
        return json.decode(response.body);
      } else {
        // If registration fails, throw an error with the message from the response
        final errorResponse = json.decode(response.body);
        throw Exception('Registration failed: ${errorResponse['message']}');
      }
    } catch (e) {
      // Catch any network or other issues
      throw Exception('An error occurred: $e');
    }
  }
}
