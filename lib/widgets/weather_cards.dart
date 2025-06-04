import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String temperature;
  final String location;
  final String condition;
  final String high;
  final String low;
  final Widget weatherIcon;
  final List<Color> gradientColors;

  const WeatherCard({
    Key? key,
    required this.temperature,
    required this.location,
    required this.condition,
    required this.high,
    required this.low,
    required this.weatherIcon,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Decorative dots
          Positioned(
            top: 10,
            right: 20,
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Temperature and location
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$temperature°',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'H:$high° L:$low°',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side - Weather icon and condition
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    weatherIcon,
                    const SizedBox(height: 8),
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom weather icons with liquid/water design
class RainIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: RainIconPainter()),
    );
  }
}

class RainIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Main cloud shape
    paint.color = Colors.white.withOpacity(0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.4),
        width: 50,
        height: 30,
      ),
      paint,
    );

    paint.color = Colors.white.withOpacity(0.95);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.35, size.height * 0.35),
        width: 36,
        height: 24,
      ),
      paint,
    );

    paint.color = Colors.white.withOpacity(0.85);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.37),
        width: 30,
        height: 20,
      ),
      paint,
    );

    // Water drops
    paint.color = const Color(0xFF4FC3F7).withOpacity(0.8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * 0.7),
        width: 6,
        height: 10,
      ),
      paint,
    );

    paint.color = const Color(0xFF4FC3F7).withOpacity(0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.75),
        width: 6,
        height: 10,
      ),
      paint,
    );

    paint.color = const Color(0xFF29B6F6).withOpacity(0.7);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.65),
        width: 5,
        height: 8,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WindIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: WindIconPainter()),
    );
  }
}

class WindIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Main cloud shape
    paint.color = Colors.white.withOpacity(0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.4),
        width: 50,
        height: 30,
      ),
      paint,
    );

    paint.color = Colors.white.withOpacity(0.95);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.35, size.height * 0.35),
        width: 36,
        height: 24,
      ),
      paint,
    );

    paint.color = Colors.white.withOpacity(0.85);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.37),
        width: 30,
        height: 20,
      ),
      paint,
    );

    // Wind lines
    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withOpacity(0.8);

    final path1 = Path();
    path1.moveTo(size.width * 0.2, size.height * 0.6);
    path1.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.6,
    );
    canvas.drawPath(path1, linePaint);

    linePaint.color = Colors.white.withOpacity(0.7);
    final path2 = Path();
    path2.moveTo(size.width * 0.25, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.75,
      size.width * 0.55,
      size.height * 0.7,
    );
    canvas.drawPath(path2, linePaint);

    linePaint.color = Colors.white.withOpacity(0.6);
    final path3 = Path();
    path3.moveTo(size.width * 0.3, size.height * 0.8);
    path3.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.85,
      size.width * 0.6,
      size.height * 0.8,
    );
    canvas.drawPath(path3, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SunShowerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: SunShowerIconPainter()),
    );
  }
}

class SunShowerIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Sun
    paint.color = const Color(0xFFFFD54F).withOpacity(0.8);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.25), 12, paint);

    // Sun rays
    final rayPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFFFFD54F).withOpacity(0.7);

    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.18),
      rayPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.25),
      Offset(size.width * 0.4, size.height * 0.25),
      rayPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.13),
      Offset(size.width * 0.37, size.height * 0.18),
      rayPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.37),
      Offset(size.width * 0.37, size.height * 0.32),
      rayPaint,
    );

    // Main cloud shape
    paint.color = Colors.white.withOpacity(0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.55, size.height * 0.45),
        width: 40,
        height: 24,
      ),
      paint,
    );

    paint.color = Colors.white.withOpacity(0.95);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.45, size.height * 0.4),
        width: 30,
        height: 20,
      ),
      paint,
    );

    paint.color = Colors.white.withOpacity(0.85);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.65, size.height * 0.42),
        width: 24,
        height: 16,
      ),
      paint,
    );

    // Rain drops
    paint.color = const Color(0xFF4FC3F7).withOpacity(0.8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.7),
        width: 4,
        height: 8,
      ),
      paint,
    );

    paint.color = const Color(0xFF4FC3F7).withOpacity(0.7);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.6, size.height * 0.75),
        width: 4,
        height: 8,
      ),
      paint,
    );

    paint.color = const Color(0xFF29B6F6).withOpacity(0.6);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.55, size.height * 0.65),
        width: 3,
        height: 6,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Main weather app widget
class WeatherApp extends StatelessWidget {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Weather',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_horiz, color: Colors.white),
                  ],
                ),
              ),

              // Search bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                    const SizedBox(width: 12),
                    Text(
                      'Search for a city or airport',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Weather cards
              Expanded(
                child: ListView(
                  children: [
                    WeatherCard(
                      temperature: '19',
                      location: 'Montreal, Canada',
                      condition: 'Mid Rain',
                      high: '24',
                      low: '13',
                      weatherIcon: RainIcon(),
                      gradientColors: [
                        const Color(0xFF7B1FA2),
                        const Color(0xFF4A148C),
                      ],
                    ),
                    WeatherCard(
                      temperature: '20',
                      location: 'Toronto, Canada',
                      condition: 'Fast Wind',
                      high: '21',
                      low: '19',
                      weatherIcon: WindIcon(),
                      gradientColors: [
                        const Color(0xFF8E24AA),
                        const Color(0xFF5E35B1),
                      ],
                    ),
                    WeatherCard(
                      temperature: '13',
                      location: 'Tokyo, Japan',
                      condition: 'Showers',
                      high: '16',
                      low: '8',
                      weatherIcon: SunShowerIcon(),
                      gradientColors: [
                        const Color(0xFF7B1FA2),
                        const Color(0xFF3949AB),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
