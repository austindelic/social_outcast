import 'package:flutter/material.dart';
import 'screens/account_screen.dart';
import 'screens/story_screen.dart';
import 'screens/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_outcast/screens/country_list_screen.dart';
import 'package:social_outcast/screens/lesson_menu_screen.dart';
import 'package:social_outcast/screens/lesson_preferences_screen.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  runApp(ProviderScope(child: const MyApp()));
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final baseLight = ThemeData.light();
    // (If you use dark mode, you can do the same with ThemeData.dark())

    return MaterialApp(
      home: const MainTabs(),
      debugShowCheckedModeBanner: false,
      theme: baseLight.copyWith(
        textTheme: GoogleFonts.gamjaFlowerTextTheme(baseLight.textTheme),
        primaryTextTheme: GoogleFonts.gamjaFlowerTextTheme(
          baseLight.primaryTextTheme,
        ),
        // Optionally also:
        // accentTextTheme: GoogleFonts.gamjaFlowerTextTheme(baseLight.accentTextTheme),
        // scaffoldBackgroundColor: ...,  etc.
      ),
      routes: {
        LessonPreferencesScreen.routeName: (_) =>
            const LessonPreferencesScreen(),
        LessonMenuScreen.routeName: (_) => const LessonMenuScreen(),
        MapScreen.routeName: (_) => const MapScreen(),
      },
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
    CountryListScreen(),
    StoryScreen(),
    AccountScreen(),
    LessonMenuScreen(),
    LessonPreferencesScreen(),
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
        ],
      ),
    );
  }
}
