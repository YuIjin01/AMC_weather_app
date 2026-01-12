import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  //Static Constant -
  static const String apiKey = '';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> getWeather(String cityName) async{
   try  {
     final String url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';
     final http.Response response = await http.get(Uri.parse(url),
       headers: {'Content-Type': 'application/json'},
     );
     if (response.statusCode == 200){
       final Map<String, dynamic> data = jsonDecode(response.body);
       return Weather.fromJson(data);
     }
     else if (response.statusCode == 404){
       throw Exception('City not found. Please check the spelling.');
     }
     else {
       throw Exception('Failed to load Weather. Status: ${response.statusCode}');
     }
   }
   catch  (e){
     throw Exception('Failed to load weather: $e');
   }
  }
}