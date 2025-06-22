import 'package:flutter/material.dart';
import 'package:game_levels_scrolling_map/model/point_model.dart';
import 'package:level_map/level_map.dart';
//import '../components/stepping_stone_map.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map-screen';
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int currentLevel = 2; // Zero-based index\
  List<PointModel> points = [];

  @override
  void initState() {
    super.initState();
    // Load the current level from the provider or database if needed

    for (int i = 0; i < 6; i++) {
      PointModel point = PointModel(
        100,
        Container(width: 40, height: 40, color: Colors.red, child: Text("$i")),
      );

      /* To make the map scroll to a specific point just make its parameter 'isCurrent' = true like the following which will make the map scroll to it once created*/
      if (i == currentLevel) point.isCurrent = true;

      points.add(point);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to the lesson preferences screen
          },
          child: Text('Move Next'),
        ),
      ),
      appBar: AppBar(title: const Text('Progress Map Example')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/map_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LevelMap(
          levelMapParams: LevelMapParams(
            levelCount: 5,
            currentLevel: 2.4,
            currentLevelImage: ImageParams(
              path: "assets/images/backgrounds/pngegg.png",
              size: Size(30, 30),
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/backgrounds/deactivated_stage.png",
              size: Size(30, 30),
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/backgrounds/activated_stage.png",
              size: Size(30, 30),
            ),
          ),
        ),
      ),
    );
  }
}
