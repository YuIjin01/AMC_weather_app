import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather.fromJson', () {
    test('should correctly parse the JSON and create a Weather object', () {
      // A realistic JSON sample from OpenWeatherMap API for Manila
      final manilaJson = {
        "coord": {"lon": 120.98, "lat": 14.6},
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 28.3,
          "feels_like": 32.8,
          "temp_min": 28,
          "temp_max": 28.3,
          "pressure": 1010,
          "humidity": 78
        },
        "visibility": 10000,
        "wind": {"speed": 2.57, "deg": 190},
        "clouds": {"all": 75},
        "dt": 1673482479,
        "sys": {
          "type": 1,
          "id": 8160,
          "country": "PH",
          "sunrise": 1673474853,
          "sunset": 1673516487
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      };

      // Use Weather.fromJson to parse the JSON
      final weather = Weather.fromJson(manilaJson);

      // Verify that the Weather object has the expected properties
      expect(weather.city, 'Manila');
      expect(weather.temperature, 28.3);
      expect(weather.description, 'Clouds');
      expect(weather.humidity, 78);
      expect(weather.windSpeed, 2.57);
    });
  });
}