import 'package:flutter/material.dart';
import 'package:game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:game_levels_scrolling_map/model/point_model.dart';
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
      appBar: AppBar(title: const Text('Progress Map Example')),
      body: Center(
        child: SizedBox(
          height: 600,
          width: 400,
          child: GameLevelsScrollingMap.scrollable(
              imageUrl: "https://i.ibb.co/nMHHv7PR/Copilot-20250622-003755.png",
              direction: Axis.vertical,
              reverseScrolling: true,
              points: points,
            ),
          ),
      ),
    );
  }
}
