import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final houseImageHeight = 400.0;
    final containerOffset = houseImageHeight / 2;

    return Scaffold(
      body: Stack(
        children: [
          // Background
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

          // Main content (City, Temp, etc.)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "Monteral",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '25°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Mostly Sunny",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "H:24°C  L:18°C",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
              ],
            ),
          ),

          // House Image
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: Image.asset(
                "assets/house.png",
                height: 400,
                width: 500,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bottom Container
          Positioned(
            bottom: containerOffset,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Spacer(),
                        Text(
                          "Weekly Forecast",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
