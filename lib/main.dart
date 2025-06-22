import 'package:flutter/material.dart';
import 'package:social_outcast/screens/lesson_menu_screen.dart';
import 'package:social_outcast/screens/lesson_preferences_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/account_screen.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainTabs(),
      debugShowCheckedModeBanner: false,
      routes: {
        LessonPreferencesScreen.routeName: (context) => const LessonPreferencesScreen(),
        LessonMenuScreen.routeName: (context) => const LessonMenuScreen(),
      }
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
    ChatScreen(),
    AccountScreen(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
