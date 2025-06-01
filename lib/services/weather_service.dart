import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// Weather Data Models
class WeatherData {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double tempMin;
  final double tempMax;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.tempMin,
    required this.tempMax,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      hourlyForecast: [],
      dailyForecast: [],
    );
  }

  // NEW: Factory method to create from One Call API data
  factory WeatherData.fromOneCallCurrent(
    Map<String, dynamic> json,
    String cityName,
  ) {
    return WeatherData(
      cityName: cityName,
      temperature: (json['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      feelsLike: (json['feels_like'] as num).toDouble(),
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['wind_speed'] as num).toDouble(),
      tempMin: (json['temp'] as num).toDouble(), // Use current temp as min
      tempMax: (json['temp'] as num).toDouble(), // Use current temp as max
      hourlyForecast: [],
      dailyForecast: [],
    );
  }
}

class HourlyWeather {
  final DateTime time;
  final double temperature;
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['wind_speed'] as num).toDouble(),
    );
  }

  // NEW: Factory method for current weather API format
  factory HourlyWeather.fromCurrentWeather(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}

class DailyWeather {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;

  DailyWeather({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMin: (json['temp']['min'] as num).toDouble(),
      tempMax: (json['temp']['max'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['wind_speed'] as num).toDouble(),
    );
  }
}

// Main Weather Service Class
class WeatherService {
  static const String _apiKey = '49f466453d72ec88c9a761654902b6c1';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _oneCallUrl =
      'https://api.openweathermap.org/data/2.5/onecall';

  // Enhanced location permission handling
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    print('Checking location services...');

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      throw Exception(
        'Location services are disabled. Please enable location services in your device settings.',
      );
    }

    print('Location services are enabled');

    permission = await Geolocator.checkPermission();
    print('Current permission status: $permission');

    if (permission == LocationPermission.denied) {
      print('Requesting location permission...');
      permission = await Geolocator.requestPermission();
      print('Permission after request: $permission');

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions are denied. Please grant location access in app settings.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable location access in app settings.',
      );
    }

    print('Location permission granted successfully');
    return true;
  }

  // Get current location with better error handling
  Future<Position> getCurrentLocation() async {
    try {
      await _handleLocationPermission();

      print('Getting current position...');

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      print('Location obtained: ${position.latitude}, ${position.longitude}');

      if (position.latitude == 0.0 && position.longitude == 0.0) {
        throw Exception('Invalid location coordinates received');
      }

      return position;
    } catch (e) {
      print('Error getting location: $e');

      try {
        print('Trying with lower accuracy...');
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 10),
        );

        if (position.latitude != 0.0 || position.longitude != 0.0) {
          print(
            'Fallback location obtained: ${position.latitude}, ${position.longitude}',
          );
          return position;
        }
      } catch (fallbackError) {
        print('Fallback location also failed: $fallbackError');
      }

      rethrow;
    }
  }

  // Get current weather by coordinates
  Future<WeatherData> getCurrentWeatherByLocation(
    double lat,
    double lon,
  ) async {
    final url =
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    print('Fetching weather for coordinates: $lat, $lon');

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      print('Weather API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Weather data received for: ${data['name']}');
        return WeatherData.fromJson(data);
      } else {
        throw Exception(
          'Failed to load weather data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Network error getting weather: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get current weather by city name
  Future<WeatherData> getCurrentWeatherByCity(String cityName) async {
    final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';
    print('Fetching weather for city: $cityName');

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception(
          'Failed to load weather data for $cityName: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // FIXED: Get hourly forecast using synchronized data
  Future<List<HourlyWeather>> getHourlyForecast(
    double lat,
    double lon, {
    WeatherData? currentWeather,
  }) async {
    final url =
        '$_oneCallUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&exclude=minutely,alerts';

    print('Fetching hourly forecast for: $lat, $lon');

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 15));

      print('Hourly forecast API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Hourly forecast data received');

        List<HourlyWeather> hourlyList = [];

        // Add current weather as first item to ensure consistency
        if (currentWeather != null) {
          hourlyList.add(
            HourlyWeather(
              time: DateTime.now(),
              temperature: currentWeather.temperature,
              icon: currentWeather.icon,
              description: currentWeather.description,
              humidity: currentWeather.humidity,
              windSpeed: currentWeather.windSpeed,
            ),
          );
        } else if (data['current'] != null) {
          // Use current data from One Call API
          hourlyList.add(HourlyWeather.fromJson(data['current']));
        }

        // Add hourly forecast data (skip first hour to avoid duplication)
        if (data['hourly'] != null) {
          final hourlyData = data['hourly'] as List;
          hourlyList.addAll(
            hourlyData
                .skip(1) // Skip first hour since we added current weather
                .take(23) // Take next 23 hours to make total 24
                .map((hour) => HourlyWeather.fromJson(hour))
                .toList(),
          );
        }

        return hourlyList;
      } else {
        print('Hourly forecast failed: ${response.statusCode}');
        return _generateMockHourlyData(currentWeather: currentWeather);
      }
    } catch (e) {
      print('Error getting hourly forecast: $e');
      return _generateMockHourlyData(currentWeather: currentWeather);
    }
  }

  // Get 7-day forecast using synchronized data
  Future<List<DailyWeather>> getDailyForecast(double lat, double lon) async {
    final url =
        '$_oneCallUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&exclude=minutely,hourly,alerts';

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['daily'] != null) {
          final dailyData = data['daily'] as List;
          return dailyData.map((day) => DailyWeather.fromJson(day)).toList();
        } else {
          return [];
        }
      } else {
        print('Daily forecast failed: ${response.statusCode}');
        return _generateMockDailyData();
      }
    } catch (e) {
      print('Error getting daily forecast: $e');
      return _generateMockDailyData();
    }
  }

  // FIXED: Generate mock hourly data with consistent current weather
  List<HourlyWeather> _generateMockHourlyData({WeatherData? currentWeather}) {
    print('Generating mock hourly data');

    List<HourlyWeather> mockData = [];

    // Add current weather as first item if available
    if (currentWeather != null) {
      mockData.add(
        HourlyWeather(
          time: DateTime.now(),
          temperature: currentWeather.temperature,
          icon: currentWeather.icon,
          description: currentWeather.description,
          humidity: currentWeather.humidity,
          windSpeed: currentWeather.windSpeed,
        ),
      );
    }

    // Generate remaining hours
    final startIndex = currentWeather != null ? 1 : 0;
    final baseTemp = currentWeather?.temperature ?? 22.0;

    mockData.addAll(
      List.generate(24 - startIndex, (index) {
        final actualIndex = index + startIndex;
        return HourlyWeather(
          time: DateTime.now().add(Duration(hours: actualIndex)),
          temperature: baseTemp + (actualIndex % 5) - 2,
          icon: ['01d', '02d', '03d', '04d', '10d'][actualIndex % 5],
          description:
              [
                'Clear',
                'Partly cloudy',
                'Cloudy',
                'Overcast',
                'Light rain',
              ][actualIndex % 5],
          humidity: 60 + (actualIndex % 20),
          windSpeed: 2.0 + (actualIndex % 3),
        );
      }),
    );

    return mockData;
  }

  // Generate mock daily data as fallback
  List<DailyWeather> _generateMockDailyData() {
    print('Generating mock daily data');
    return List.generate(7, (index) {
      return DailyWeather(
        date: DateTime.now().add(Duration(days: index)),
        tempMin: 18.0 + (index % 3),
        tempMax: 26.0 + (index % 4),
        icon: ['01d', '02d', '03d', '04d', '10d', '11d', '13d'][index],
        description:
            [
              'Sunny',
              'Partly cloudy',
              'Cloudy',
              'Overcast',
              'Rainy',
              'Stormy',
              'Snowy',
            ][index],
        humidity: 65,
        windSpeed: 3.5,
      );
    });
  }

  // FIXED: Get complete weather data with synchronized temperatures
  Future<Map<String, dynamic>> getCompleteWeatherData() async {
    try {
      print('Starting to get complete weather data...');

      final position = await getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      print('Got location: $lat, $lon');
      print('Fetching current weather...');

      final current = await getCurrentWeatherByLocation(lat, lon);

      print('Current weather fetched for: ${current.cityName}');
      print('Current temperature: ${current.temperature}°C');
      print('Fetching forecasts...');

      // Pass current weather to ensure hourly forecast starts with same temperature
      final hourly = await getHourlyForecast(lat, lon, currentWeather: current);
      final daily = await getDailyForecast(lat, lon);

      print('Complete weather data assembled successfully');
      print('Hourly forecast items: ${hourly.length}');
      print('Daily forecast items: ${daily.length}');

      if (hourly.isNotEmpty) {
        print('First hourly temperature: ${hourly[0].temperature}°C');
      }

      return {
        'current': current,
        'hourly': hourly,
        'daily': daily,
        'location': {'lat': lat, 'lon': lon},
      };
    } catch (e) {
      print('Error in getCompleteWeatherData: $e');
      throw Exception('Failed to get complete weather data: $e');
    }
  }

  // Get weather icon URL
  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Convert temperature units
  double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  // Format temperature display
  String formatTemperature(double temp, {bool showUnit = true}) {
    return '${temp.round()}${showUnit ? '°C' : ''}';
  }

  // Get weather condition from description
  String getWeatherCondition(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('rain')) return 'rainy';
    if (desc.contains('cloud')) return 'cloudy';
    if (desc.contains('sun') || desc.contains('clear')) return 'sunny';
    if (desc.contains('snow')) return 'snowy';
    if (desc.contains('storm') || desc.contains('thunder')) return 'stormy';
    if (desc.contains('mist') || desc.contains('fog')) return 'foggy';
    return 'unknown';
  }

  // Test location functionality
  Future<String> testLocation() async {
    try {
      final position = await getCurrentLocation();
      return 'Location test successful: ${position.latitude}, ${position.longitude}';
    } catch (e) {
      return 'Location test failed: $e';
    }
  }
}
