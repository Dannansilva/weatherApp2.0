import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:intl/intl.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyWeather> hourlyData;

  const HourlyForecastWidget({Key? key, required this.hourlyData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final hourWeather = hourlyData[index];
          return _buildHourlyItem(hourWeather, index == 0);
        },
      ),
    );
  }

  Widget _buildHourlyItem(HourlyWeather weather, bool isFirst) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Time
          Text(
            isFirst ? 'Now' : _formatTime(weather.time),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Weather Icon
          _buildWeatherIcon(weather.icon),

          // Temperature
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Humidity indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.water_drop,
                color: Colors.blue.withOpacity(0.7),
                size: 10,
              ),
              const SizedBox(width: 2),
              Text(
                '${weather.humidity}%',
                style: TextStyle(
                  color: Colors.blue.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String iconCode) {
    // Map of weather icon codes to Flutter icons
    IconData getIconFromCode(String code) {
      switch (code) {
        case '01d':
        case '01n':
          return Icons.wb_sunny;
        case '02d':
        case '02n':
          return Icons.wb_cloudy;
        case '03d':
        case '03n':
        case '04d':
        case '04n':
          return Icons.cloud;
        case '09d':
        case '09n':
        case '10d':
        case '10n':
          return Icons.grain;
        case '11d':
        case '11n':
          return Icons.thunderstorm;
        case '13d':
        case '13n':
          return Icons.ac_unit;
        case '50d':
        case '50n':
          return Icons.foggy;
        default:
          return Icons.wb_sunny;
      }
    }

    Color getIconColor(String code) {
      switch (code) {
        case '01d':
        case '01n':
          return Colors.yellow.shade300;
        case '02d':
        case '02n':
        case '03d':
        case '03n':
        case '04d':
        case '04n':
          return Colors.grey.shade300;
        case '09d':
        case '09n':
        case '10d':
        case '10n':
          return Colors.blue.shade300;
        case '11d':
        case '11n':
          return Colors.purple.shade300;
        case '13d':
        case '13n':
          return Colors.white;
        case '50d':
        case '50n':
          return Colors.grey.shade400;
        default:
          return Colors.white;
      }
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        getIconFromCode(iconCode),
        color: getIconColor(iconCode),
        size: 24,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm');

    // If it's the same day, show just the time
    if (time.day == now.day) {
      return formatter.format(time);
    }

    // If it's tomorrow, show "Tomorrow HH:mm"
    if (time.day == now.day + 1) {
      return 'Tom ${formatter.format(time)}';
    }

    // Otherwise show day abbreviation and time
    return '${DateFormat('E').format(time)} ${formatter.format(time)}';
  }
}

// Alternative version with network images (if you prefer to use OpenWeatherMap icons)
class HourlyForecastWithNetworkIcons extends StatelessWidget {
  final List<HourlyWeather> hourlyData;

  const HourlyForecastWithNetworkIcons({Key? key, required this.hourlyData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final hourWeather = hourlyData[index];
          return _buildHourlyItemWithNetworkIcon(hourWeather, index == 0);
        },
      ),
    );
  }

  Widget _buildHourlyItemWithNetworkIcon(HourlyWeather weather, bool isFirst) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Time
          Text(
            isFirst ? 'Now' : _formatTime(weather.time),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Weather Icon from network
          Image.network(
            'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.wb_sunny,
                color: Colors.white.withOpacity(0.8),
                size: 32,
              );
            },
          ),

          // Temperature
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Humidity indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.water_drop,
                color: Colors.blue.withOpacity(0.7),
                size: 10,
              ),
              const SizedBox(width: 2),
              Text(
                '${weather.humidity}%',
                style: TextStyle(
                  color: Colors.blue.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm');

    if (time.day == now.day) {
      return formatter.format(time);
    }

    if (time.day == now.day + 1) {
      return 'Tom ${formatter.format(time)}';
    }

    return '${DateFormat('E').format(time)} ${formatter.format(time)}';
  }
}
