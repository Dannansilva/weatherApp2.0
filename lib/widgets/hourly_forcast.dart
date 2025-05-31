import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyWeatherData> hourlyData;

  const HourlyForecastWidget({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children:
            hourlyData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              final isFirst = index == 0;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isFirst
                              ? [Colors.deepPurpleAccent, Colors.indigoAccent]
                              : [Colors.white10, Colors.white12],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border:
                        isFirst
                            ? Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            )
                            : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Time
                      Text(
                        data.time,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Weather Icon
                      if (data.iconPath != null)
                        Image.asset(data.iconPath!, width: 28, height: 28)
                      else
                        Icon(
                          data.weatherIcon ?? Icons.wb_sunny,
                          color: Colors.white,
                          size: 28,
                        ),

                      const SizedBox(height: 8),

                      // Rain percentage (if exists)
                      if (data.rainPercentage != null &&
                          data.rainPercentage! > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "${data.rainPercentage}%",
                            style: TextStyle(
                              color: Colors.lightBlue.shade200,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      // Temperature
                      Text(
                        "${data.temperature}°",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// Data model for hourly weather
class HourlyWeatherData {
  final String time;
  final int temperature;
  final String? iconPath; // For custom weather icons
  final IconData? weatherIcon; // For Material icons
  final int? rainPercentage;
  final String? condition;

  HourlyWeatherData({
    required this.time,
    required this.temperature,
    this.iconPath,
    this.weatherIcon,
    this.rainPercentage,
    this.condition,
  });
}

// Helper class to generate sample data
class HourlyWeatherHelper {
  static List<HourlyWeatherData> getSampleData() {
    return [
      HourlyWeatherData(
        time: "Now",
        temperature: 19,
        weatherIcon: Icons.cloud,
        rainPercentage: 30,
      ),
      HourlyWeatherData(
        time: "2 AM",
        temperature: 19,
        weatherIcon: Icons.cloud,
        rainPercentage: 0,
      ),
      HourlyWeatherData(
        time: "3 AM",
        temperature: 18,
        weatherIcon: Icons.grain, // rain icon
        rainPercentage: 0,
      ),
      HourlyWeatherData(
        time: "4 AM",
        temperature: 19,
        weatherIcon: Icons.cloud,
        rainPercentage: 0,
      ),
      HourlyWeatherData(
        time: "5 AM",
        temperature: 19,
        weatherIcon: Icons.cloud,
        rainPercentage: 0,
      ),
      HourlyWeatherData(
        time: "6 AM",
        temperature: 20,
        weatherIcon: Icons.wb_sunny,
        rainPercentage: 0,
      ),
      HourlyWeatherData(
        time: "7 AM",
        temperature: 21,
        weatherIcon: Icons.wb_sunny,
        rainPercentage: 0,
      ),
      HourlyWeatherData(
        time: "8 AM",
        temperature: 22,
        weatherIcon: Icons.wb_sunny,
        rainPercentage: 0,
      ),
    ];
  }
}
