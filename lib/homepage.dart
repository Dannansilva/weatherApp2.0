import 'package:flutter/material.dart';
import 'package:weather_app/widgets/hourly_forcast.dart';
import 'package:weather_app/services/weather_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _currentWeather;
  List<HourlyWeather> _hourlyForecast = [];
  List<DailyWeather> _dailyForecast = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isLocationBased = false;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      Map<String, dynamic> weatherData;

      try {
        // Try to get location-based weather first
        weatherData = await _weatherService.getCompleteWeatherData();
        _isLocationBased = true;
      } catch (locationError) {
        // If location fails, try to get weather for a default city
        print('Location error: $locationError');

        try {
          final defaultWeather = await _weatherService.getCurrentWeatherByCity(
            'London',
          );

          // Get coordinates for London to fetch forecasts
          const londonLat = 51.5074;
          const londonLon = -0.1278;

          final hourlyForecast = await _weatherService.getHourlyForecast(
            londonLat,
            londonLon,
          );
          final dailyForecast = await _weatherService.getDailyForecast(
            londonLat,
            londonLon,
          );

          weatherData = {
            'current': defaultWeather,
            'hourly': hourlyForecast,
            'daily': dailyForecast,
            'location': {'lat': londonLat, 'lon': londonLon},
          };
          _isLocationBased = false;
        } catch (cityError) {
          // If both location and city weather fail, use mock data
          weatherData = await _getMockWeatherData();
          _isLocationBased = false;
        }
      }

      setState(() {
        _currentWeather = weatherData['current'];
        _hourlyForecast = weatherData['hourly'] ?? [];
        _dailyForecast = weatherData['daily'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      _showErrorDialog(e.toString());
    }
  }

  Future<Map<String, dynamic>> _getMockWeatherData() async {
    // Create mock weather data for testing
    final mockWeather = WeatherData(
      cityName: 'Demo City',
      temperature: 22.0,
      description: 'Partly cloudy',
      icon: '02d',
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 3.5,
      tempMin: 18.0,
      tempMax: 26.0,
      hourlyForecast: [],
      dailyForecast: [],
    );

    final mockHourly = List.generate(24, (index) {
      return HourlyWeather(
        time: DateTime.now().add(Duration(hours: index)),
        temperature: 22.0 + (index % 5) - 2,
        icon: ['01d', '02d', '03d', '04d', '10d'][index % 5],
        description:
            [
              'Clear',
              'Partly cloudy',
              'Cloudy',
              'Overcast',
              'Light rain',
            ][index % 5],
        humidity: 60 + (index % 20),
        windSpeed: 2.0 + (index % 3),
      );
    });

    final mockDaily = List.generate(7, (index) {
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

    return {
      'current': mockWeather,
      'hourly': mockHourly,
      'daily': mockDaily,
      'location': {'lat': 0.0, 'lon': 0.0},
    };
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Weather Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(error),
                const SizedBox(height: 16),
                const Text(
                  'Suggestions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('• Enable location services'),
                const Text('• Check internet connection'),
                const Text('• Grant location permissions'),
                const Text('• Try again in a moment'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _loadWeatherData(); // Retry
                },
                child: const Text('Retry'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Location'),
            content: Text(
              _isLocationBased
                  ? 'Weather data is based on your current location.'
                  : 'Unable to access location. Showing weather for London.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
              if (!_isLocationBased)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _loadWeatherData();
                  },
                  child: const Text('Try Location Again'),
                ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final houseImageHeight = 400.0;
    final containerOffset = houseImageHeight / 2;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadWeatherData,
        color: Colors.white,
        backgroundColor: const Color(0xFF48319D),
        child: Stack(
          children: [
            // Background
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E3C72),
                    Color(0xFF2A5298),
                    Color(0xFF48319D),
                  ],
                ),
              ),
            ),

            // Fallback background image if assets exist
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Loading indicator
            if (_isLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading weather data...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

            // Main content (City, Temp, etc.)
            if (!_isLoading && _currentWeather != null)
              SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Top weather info
                      Container(
                        height: screenHeight * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Location indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isLocationBased
                                      ? Icons.location_on
                                      : Icons.location_off,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isLocationBased
                                      ? 'Current Location'
                                      : 'Default Location',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // City name
                            Text(
                              _currentWeather!.cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Temperature
                            Text(
                              _weatherService.formatTemperature(
                                _currentWeather!.temperature,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.w300,
                              ),
                            ),

                            // Description
                            Text(
                              _currentWeather!.description.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // High/Low temperatures
                            Text(
                              "H:${_weatherService.formatTemperature(_currentWeather!.tempMax)}  L:${_weatherService.formatTemperature(_currentWeather!.tempMin)}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Additional weather info
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildWeatherDetail(
                                    'Feels like',
                                    '${_currentWeather!.feelsLike.round()}°C',
                                    Icons.thermostat,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  _buildWeatherDetail(
                                    'Humidity',
                                    '${_currentWeather!.humidity}%',
                                    Icons.water_drop,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  _buildWeatherDetail(
                                    'Wind',
                                    '${_currentWeather!.windSpeed.toStringAsFixed(1)} m/s',
                                    Icons.air,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // House Image (if asset exists)
            if (!_isLoading)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Image.asset(
                    "assets/house.png",
                    height: 400,
                    width: 500,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(); // Hide if image doesn't exist
                    },
                  ),
                ),
              ),

            // Bottom Container with Gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: containerOffset + 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF48319D).withOpacity(0.9),
                      const Color(0xFF1F1D47).withOpacity(0.9),
                      const Color(0xFF1C1B33).withOpacity(1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Hourly Forecast",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Weekly Forecast",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white38),

                    // Hourly forecast row
                    if (!_isLoading && _hourlyForecast.isNotEmpty)
                      Expanded(
                        child: HourlyForecastWidget(
                          hourlyData: _hourlyForecast,
                        ),
                      ),

                    if (!_isLoading && _hourlyForecast.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No forecast data available',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                    if (_isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),

                    // Bottom navigation
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Location icon
                          GestureDetector(
                            onTap: _showLocationDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                _isLocationBased
                                    ? Icons.location_on
                                    : Icons.location_off,
                                color: Colors.white.withOpacity(0.8),
                                size: 24,
                              ),
                            ),
                          ),

                          // Refresh/Add icon
                          GestureDetector(
                            onTap: _loadWeatherData,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white.withOpacity(0.9),
                                size: 28,
                              ),
                            ),
                          ),

                          // Menu icon
                          GestureDetector(
                            onTap: () {
                              // Add menu functionality here
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Menu functionality coming soon!',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white.withOpacity(0.8),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}
