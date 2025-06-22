import 'package:flutter/material.dart';
import '../components/stepping_stone_map.dart'; // import your ProgressMap

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int currentLevel = 2; // Zero-based index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Map Example')),
      body: Center(
        child: SizedBox(
          height: 600,
          width: 400,
          child: ProgressMap(
            totalLevels: 10,
            currentLevel: currentLevel,
            onLevelTap: (level) {
              setState(() => currentLevel = level);
            },
          ),
        ),
      ),
    );
  }
}
