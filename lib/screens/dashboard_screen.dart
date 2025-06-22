import 'package:flutter/material.dart';
import 'package:social_outcast/screens/lesson_menu_screen.dart';
import 'package:social_outcast/screens/lesson_preferences_screen.dart';
import 'package:social_outcast/utilities/prefs_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Welcome back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              if(UserPreferences.getIsGenerated() == null || UserPreferences.getIsGenerated() == false) {
                Navigator.pushNamed(context, LessonMenuScreen.routeName);
                Navigator.pushNamed(context, LessonPreferencesScreen.routeName);
              }
              else{
                Navigator.pushNamed(context, LessonMenuScreen.routeName);
              }
              
            },
            child: const Text("Get Started"),
          ),
          const SizedBox(height: 16),
          DashboardCard(
            title: "Total Chats",
            value: "132",
            icon: Icons.chat_bubble_outline,
            color: Colors.blue[100],
          ),
          DashboardCard(
            title: "Active Users",
            value: "7",
            icon: Icons.people_outline,
            color: Colors.green[100],
          ),
          DashboardCard(
            title: "Last Message",
            value: "Just now",
            icon: Icons.access_time,
            color: Colors.orange[100],
          ),
          // Add more cards as needed
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 36),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
