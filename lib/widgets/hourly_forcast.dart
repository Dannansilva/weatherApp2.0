import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:intl/intl.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyWeather> hourlyData;

  const HourlyForecastWidget({Key? key, required this.hourlyData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredData = _filterDataUntilTomorrowMidnight(hourlyData);

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final hourWeather = filteredData[index];
          final isNowCard = index == 0;
          return _buildHourlyItem(hourWeather, isNowCard);
        },
      ),
    );
  }

  List<HourlyWeather> _filterDataUntilTomorrowMidnight(
    List<HourlyWeather> data,
  ) {
    final now = DateTime.now();
    final tomorrow12AM = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);

    return data
        .where((weather) => weather.time.isBefore(tomorrow12AM))
        .toList();
  }

  Widget _buildHourlyItem(HourlyWeather weather, bool isNowCard) {
    final config = isNowCard ? _getNowCardConfig() : _getRegularCardConfig();

    return Container(
      width: config.width,
      margin: const EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(
        horizontal: config.horizontalPadding,
        vertical: config.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config.borderColor,
          width: config.borderWidth,
        ),
        boxShadow: config.boxShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Time
          Text(
            isNowCard ? 'Now' : _formatTime(weather.time),
            style: TextStyle(
              color: config.timeTextColor,
              fontSize: config.timeFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Weather Icon
          _buildWeatherIcon(weather.icon, config),

          // Temperature
          Text(
            '${weather.temperature.round()}°',
            style: TextStyle(
              color: config.temperatureTextColor,
              fontSize: config.temperatureFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Humidity indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.water_drop,
                color: config.humidityIconColor,
                size: config.humidityIconSize,
              ),
              const SizedBox(width: 2),
              Text(
                '${weather.humidity}%',
                style: TextStyle(
                  color: config.humidityTextColor,
                  fontSize: config.humidityFontSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String iconCode, _CardConfig config) {
    return Container(
      padding: EdgeInsets.all(config.iconPadding),
      decoration: BoxDecoration(
        color: config.iconBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIconFromCode(iconCode),
        color: _getIconColor(iconCode),
        size: config.iconSize,
      ),
    );
  }

  IconData _getIconFromCode(String code) {
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

  Color _getIconColor(String code) {
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

  /// Configuration for the "Now" card - customize all styling here
  _CardConfig _getNowCardConfig() {
    return _CardConfig(
      // Card dimensions
      width: 100,
      horizontalPadding: 20,
      verticalPadding: 16,

      // Card styling
      backgroundColor: Colors.blue.withOpacity(0.3),
      borderColor: Colors.blue.withOpacity(0.5),
      borderWidth: 2,
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],

      // Time text styling
      timeTextColor: Colors.white,
      timeFontSize: 14,

      // Icon styling
      iconSize: 28,
      iconPadding: 10,
      iconBackgroundColor: Colors.white.withOpacity(0.2),

      // Temperature text styling
      temperatureTextColor: Colors.white,
      temperatureFontSize: 18,

      // Humidity styling
      humidityIconColor: Colors.blue.withOpacity(0.7),
      humidityIconSize: 12,
      humidityTextColor: Colors.blue.withOpacity(0.8),
      humidityFontSize: 11,
    );
  }

  /// Configuration for regular cards
  _CardConfig _getRegularCardConfig() {
    return _CardConfig(
      // Card dimensions
      width: 80,
      horizontalPadding: 16,
      verticalPadding: 12,

      // Card styling
      backgroundColor: Colors.white.withOpacity(0.1),
      borderColor: Colors.white.withOpacity(0.2),
      borderWidth: 1,
      boxShadow: null,

      // Time text styling
      timeTextColor: Colors.white.withOpacity(0.8),
      timeFontSize: 12,

      // Icon styling
      iconSize: 24,
      iconPadding: 8,
      iconBackgroundColor: Colors.white.withOpacity(0.1),

      // Temperature text styling
      temperatureTextColor: Colors.white,
      temperatureFontSize: 16,

      // Humidity styling
      humidityIconColor: Colors.blue.withOpacity(0.7),
      humidityIconSize: 10,
      humidityTextColor: Colors.blue.withOpacity(0.8),
      humidityFontSize: 10,
    );
  }
}

class _CardConfig {
  // Card dimensions
  final double width;
  final double horizontalPadding;
  final double verticalPadding;

  // Card styling
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  // Time text styling
  final Color timeTextColor;
  final double timeFontSize;

  // Icon styling
  final double iconSize;
  final double iconPadding;
  final Color iconBackgroundColor;

  // Temperature text styling
  final Color temperatureTextColor;
  final double temperatureFontSize;

  // Humidity styling
  final Color humidityIconColor;
  final double humidityIconSize;
  final Color humidityTextColor;
  final double humidityFontSize;

  const _CardConfig({
    required this.width,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    this.boxShadow,
    required this.timeTextColor,
    required this.timeFontSize,
    required this.iconSize,
    required this.iconPadding,
    required this.iconBackgroundColor,
    required this.temperatureTextColor,
    required this.temperatureFontSize,
    required this.humidityIconColor,
    required this.humidityIconSize,
    required this.humidityTextColor,
    required this.humidityFontSize,
  });
}

class HourlyForecastWithNetworkIcons extends StatelessWidget {
  final List<HourlyWeather> hourlyData;

  const HourlyForecastWithNetworkIcons({Key? key, required this.hourlyData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredData = _filterDataUntilTomorrowMidnight(hourlyData);

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final hourWeather = filteredData[index];
          final isNowCard = index == 0;
          return _buildHourlyItemWithNetworkIcon(hourWeather, isNowCard);
        },
      ),
    );
  }

  List<HourlyWeather> _filterDataUntilTomorrowMidnight(
    List<HourlyWeather> data,
  ) {
    final now = DateTime.now();
    final tomorrow12AM = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);

    return data
        .where((weather) => weather.time.isBefore(tomorrow12AM))
        .toList();
  }

  Widget _buildHourlyItemWithNetworkIcon(
    HourlyWeather weather,
    bool isNowCard,
  ) {
    final config =
        isNowCard ? _getNowCardNetworkConfig() : _getRegularCardNetworkConfig();

    return Container(
      width: config.width,
      margin: const EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(
        horizontal: config.horizontalPadding,
        vertical: config.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config.borderColor,
          width: config.borderWidth,
        ),
        boxShadow: config.boxShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Time
          Text(
            isNowCard ? 'Now' : _formatTime(weather.time),
            style: TextStyle(
              color: config.timeTextColor,
              fontSize: config.timeFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Weather Icon from network
          Container(
            width: config.networkIconSize,
            height: config.networkIconSize,
            decoration: config.iconContainerDecoration,
            child: Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
              width: config.networkIconSize,
              height: config.networkIconSize,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.wb_sunny,
                  color: Colors.white.withOpacity(0.8),
                  size: config.fallbackIconSize,
                );
              },
            ),
          ),

          // Temperature
          Text(
            '${weather.temperature.round()}°',
            style: TextStyle(
              color: config.temperatureTextColor,
              fontSize: config.temperatureFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Humidity indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.water_drop,
                color: config.humidityIconColor,
                size: config.humidityIconSize,
              ),
              const SizedBox(width: 2),
              Text(
                '${weather.humidity}%',
                style: TextStyle(
                  color: config.humidityTextColor,
                  fontSize: config.humidityFontSize,
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

  /// Configuration for the "Now" card with network icons
  _NetworkCardConfig _getNowCardNetworkConfig() {
    return _NetworkCardConfig(
      // Card dimensions
      width: 100,
      horizontalPadding: 20,
      verticalPadding: 16,

      // Card styling
      backgroundColor: const Color(0xff5936b4),
      borderColor: const Color(0xff1f1d47),
      borderWidth: 2,
      boxShadow: [
        const BoxShadow(
          color: Color(0xff5936b4),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],

      // Time text styling
      timeTextColor: Colors.yellow,
      timeFontSize: 14,

      // Network icon styling
      networkIconSize: 44,
      fallbackIconSize: 36,
      iconContainerDecoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),

      // Temperature text styling
      temperatureTextColor: Colors.white,
      temperatureFontSize: 18,

      // Humidity styling
      humidityIconColor: Colors.blue.withOpacity(0.7),
      humidityIconSize: 12,
      humidityTextColor: Colors.blue.withOpacity(0.8),
      humidityFontSize: 11,
    );
  }

  /// Configuration for regular cards with network icons
  _NetworkCardConfig _getRegularCardNetworkConfig() {
    return _NetworkCardConfig(
      // Card dimensions
      width: 80,
      horizontalPadding: 16,
      verticalPadding: 12,

      // Card styling
      backgroundColor: Colors.white.withOpacity(0.1),
      borderColor: Colors.white.withOpacity(0.2),
      borderWidth: 1,
      boxShadow: null,

      // Time text styling
      timeTextColor: Colors.white.withOpacity(0.8),
      timeFontSize: 12,

      // Network icon styling
      networkIconSize: 40,
      fallbackIconSize: 32,
      iconContainerDecoration: null,

      // Temperature text styling
      temperatureTextColor: Colors.white,
      temperatureFontSize: 16,

      // Humidity styling
      humidityIconColor: Colors.blue.withOpacity(0.7),
      humidityIconSize: 10,
      humidityTextColor: Colors.blue.withOpacity(0.8),
      humidityFontSize: 10,
    );
  }
}

class _NetworkCardConfig {
  // Card dimensions
  final double width;
  final double horizontalPadding;
  final double verticalPadding;

  // Card styling
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  // Time text styling
  final Color timeTextColor;
  final double timeFontSize;

  // Network icon styling
  final double networkIconSize;
  final double fallbackIconSize;
  final BoxDecoration? iconContainerDecoration;

  // Temperature text styling
  final Color temperatureTextColor;
  final double temperatureFontSize;

  // Humidity styling
  final Color humidityIconColor;
  final double humidityIconSize;
  final Color humidityTextColor;
  final double humidityFontSize;

  const _NetworkCardConfig({
    required this.width,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    this.boxShadow,
    required this.timeTextColor,
    required this.timeFontSize,
    required this.networkIconSize,
    required this.fallbackIconSize,
    this.iconContainerDecoration,
    required this.temperatureTextColor,
    required this.temperatureFontSize,
    required this.humidityIconColor,
    required this.humidityIconSize,
    required this.humidityTextColor,
    required this.humidityFontSize,
  });
}
