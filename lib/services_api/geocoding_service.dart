import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static Future<LatLng?> getCoordinates(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=$query'
      '&format=json'
      '&limit=1',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'airport_transfer_app', // REQUIRED
      },
    );

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    if (data.isEmpty) return null;

    return LatLng(
      double.parse(data[0]['lat']),
      double.parse(data[0]['lon']),
    );
  }
}
