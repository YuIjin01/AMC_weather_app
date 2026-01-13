import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_icons/weather_icons.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Controller: Manages text input from the search field
  final TextEditingController _cityController = TextEditingController();

  // Future: Holds the asynchronous weather data fetch
  late Future<Weather> weatherFuture;

  // Flag: Track if this is the first load
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Load weather for London when app starts
    weatherFuture = WeatherService.getWeather('London');
  }

  // Function: Handle search button press
  void _searchWeather() {
    final String city = _cityController.text.trim();

    // Validate input: Don't allow empty searches
    if (city.isEmpty) {
      _showSnackBar('Please enter a city name', Colors.orangeAccent);
      return;
    }

    // Update the Future to fetch new weather data
    setState(() {
      weatherFuture = WeatherService.getWeather(city);
      isFirstLoad = false;
    });
  }

  // Helper: Display notification messages
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.lato()),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper: Get weather icon from description
  IconData _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return WeatherIcons.day_sunny;
      case 'few clouds':
        return WeatherIcons.day_cloudy;
      case 'scattered clouds':
      case 'broken clouds':
        return WeatherIcons.cloud;
      case 'shower rain':
        return WeatherIcons.showers;
      case 'rain':
        return WeatherIcons.rain;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'mist':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.cloud;
    }
  }

  @override
  void dispose() {
    // Clean up: Always dispose controllers to prevent memory leaks
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // App bar at the top
      appBar: AppBar(
        title: Text('🌤️ Weather App', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),

      // Main content area
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ===== SEARCH INPUT SECTION =====
            Row(
              children: [
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name...',
                      prefixIcon: const Icon(Icons.location_city, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    style: GoogleFonts.lato(),
                    // Allow pressing Enter to search
                    onSubmitted: (_) => _searchWeather(),
                  ),
                ),
                const SizedBox(width: 12),

                // Search button
                IconButton(
                  icon: const Icon(Icons.search, size: 28),
                  onPressed: _searchWeather,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== WEATHER DISPLAY SECTION =====
            FutureBuilder<Weather>(
              future: weatherFuture,
              builder: (context, snapshot) {
                // STATE 1: Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // STATE 2: Error
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          snapshot.error.toString().replaceFirst('Exception: ', ''),
                          style: GoogleFonts.lato(color: Colors.redAccent, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // STATE 3: Success
                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // City name
                        Text(
                          weather.city,
                          style: GoogleFonts.lato(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 16),

                        // Temperature (main focus)
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°C',
                          style: GoogleFonts.raleway(fontSize: 72, fontWeight: FontWeight.w300, color: Colors.white),
                        ),
                        const SizedBox(height: 8),

                        // Weather description
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BoxedIcon(_getWeatherIcon(weather.description), color: Colors.white.withOpacity(0.85)),
                            const SizedBox(width: 8),
                            Text(
                              weather.description,
                              style: GoogleFonts.lato(fontSize: 20, color: Colors.white.withOpacity(0.85)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Additional info (Humidity & Wind)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoCard(
                              icon: WeatherIcons.humidity,
                              label: 'Humidity',
                              value: '${weather.humidity}%',
                            ),
                            WeatherInfoCard(
                              icon: WeatherIcons.wind,
                              label: 'Wind Speed',
                              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                // STATE 4: No data
                return const Center(
                  child: Text('No data available'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ===== REUSABLE WIDGET =====
class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoxedIcon(icon, color: Colors.white.withOpacity(0.85), size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.lato(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.lato(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
