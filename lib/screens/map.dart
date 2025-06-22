import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';

class CountryCourse {
  final String name;
  final String countryCode; // Used for flag asset path

  CountryCourse(this.name, this.countryCode);
}

final List<CountryCourse> courses = [
  CountryCourse('Australia', 'au'),
  CountryCourse('France', 'fr'),
  CountryCourse('Japan', 'jp'),
  CountryCourse('Brazil', 'br'),
  CountryCourse('United States', 'us'),
  CountryCourse('India', 'in'),
];

class MapScreen extends StatefulWidget {
  static const String routeName = '/map-screen';
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int currentLevel = 2; // Example: Japan is current

  void _nextLevel() {
    setState(() {
      currentLevel = (currentLevel + 1) % courses.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Your World Progress',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/map_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          Column(
            children: [
              const SizedBox(height: 24),
              // List of countries (courses)
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: courses.length,
                  itemBuilder: (context, i) {
                    final isActive = i == currentLevel;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.all(isActive ? 10 : 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.95)
                            : Colors.white.withOpacity(0.75),
                        border: Border.all(
                          color: isActive ? Colors.teal : Colors.grey.shade300,
                          width: isActive ? 2.5 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          if (isActive)
                            BoxShadow(
                              color: Colors.tealAccent.withOpacity(0.3),
                              blurRadius: 14,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Country flag
                          Image.asset(
                            'assets/flags/${courses[i].countryCode}.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            courses[i].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? Colors.teal[900]
                                  : Colors.grey[800],
                            ),
                          ),
                          if (isActive)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Current',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Level Map
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LevelMap(
                    levelMapParams: LevelMapParams(
                      levelCount: courses.length,
                      currentLevel: currentLevel.toDouble(),
                      currentLevelImage: ImageParams(
                        path: "assets/images/backgrounds/pngegg.png",
                        size: const Size(36, 36),
                      ),
                      lockedLevelImage: ImageParams(
                        path: "assets/images/backgrounds/deactivated_stage.png",
                        size: const Size(32, 32),
                      ),
                      completedLevelImage: ImageParams(
                        path: "assets/images/backgrounds/activated_stage.png",
                        size: const Size(32, 32),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nextLevel,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        label: const Text(
          'Next Country',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
