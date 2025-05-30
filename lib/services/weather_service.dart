import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'c7f242c3405ad02df0f8f933ee01bb4d';

  Future<String> getWeatherCondition(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['weather'][0]['main']; // e.g., Rain, Clear, Clouds
    } else {
      throw Exception('Failed to fetch weather');
    }
  }
}
