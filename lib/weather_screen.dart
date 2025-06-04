import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_cards.dart';

class WeatherMenuScreen extends StatelessWidget {
  final List<WeatherData> savedLocations;
  final Function(int) onLocationRemoved;

  const WeatherMenuScreen({
    Key? key,
    required this.savedLocations,
    required this.onLocationRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A148C),
              Color(0xFF6A1B9A),
              Color(0xFF7B1FA2),
              Color(0xFF3F51B5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Weather Locations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${savedLocations.length} locations',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Weather cards
              Expanded(
                child:
                    savedLocations.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                color: Colors.white.withOpacity(0.5),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No locations added yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to add weather locations',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: savedLocations.length,
                          itemBuilder: (context, index) {
                            final weather = savedLocations[index];
                            return Dismissible(
                              key: Key('weather_${weather.cityName}_$index'),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => onLocationRemoved(index),
                              background: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              child: WeatherCard(
                                temperature:
                                    weather.temperature.round().toString(),
                                location: weather.cityName,
                                condition: weather.description,
                                high: weather.tempMax.round().toString(),
                                low: weather.tempMin.round().toString(),
                                weatherIcon: _getWeatherIcon(
                                  weather.description,
                                ),
                                gradientColors: _getGradientColors(index),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('rain') || desc.contains('shower')) {
      return RainIcon();
    } else if (desc.contains('wind')) {
      return WindIcon();
    } else {
      return SunShowerIcon();
    }
  }

  List<Color> _getGradientColors(int index) {
    final gradients = [
      [const Color(0xFF7B1FA2), const Color(0xFF4A148C)],
      [const Color(0xFF8E24AA), const Color(0xFF5E35B1)],
      [const Color(0xFF7B1FA2), const Color(0xFF3949AB)],
      [const Color(0xFF6A1B9A), const Color(0xFF4A148C)],
      [const Color(0xFF9C27B0), const Color(0xFF673AB7)],
    ];
    return gradients[index % gradients.length];
  }
}
