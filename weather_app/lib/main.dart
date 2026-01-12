import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen.dart'; // Import the new weather screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App', // Changed title for relevance
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // It's good practice to enable Material 3
      ),
      home: const WeatherScreen(), // Set WeatherScreen as the home widget
    );
  }
}
