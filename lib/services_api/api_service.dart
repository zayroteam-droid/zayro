import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api";

  static Future<double?> getPrice({
    required String pickup,
    required String dropoff,
    required String vehicleType,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bookings/price"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pickup': pickup,
        'dropoff': dropoff,
        'vehicleType': vehicleType,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['price']);
    }
    return null;
  }
}
