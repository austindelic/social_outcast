import 'package:flutter/material.dart';
import 'screens/account_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/story_screen.dart';
import 'screens/map.dart';
import 'screens/puzzle_runner_screen.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainTabs(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});
  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    MapScreen(),
    StoryScreen(),
    AccountScreen(),
    PuzzleRunnerScreen(),
  ];

  void _onItemTapped(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black.withValues(
          alpha: 0.1,
          red: 0.0,
          green: 0.0,
          blue: 0.0,
        ),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey, // Icon colour
        selectedLabelStyle: const TextStyle(color: Colors.amber),
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
        ), // <-- Add this line
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.extension), label: 'Puzzles'),
        ],
      ),
    );
  }
}
