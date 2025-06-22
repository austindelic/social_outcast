import 'package:flutter/material.dart';
import 'package:social_outcast/providers/preference_provider.dart';
import 'package:social_outcast/utilities/database_helper.dart';
import 'package:social_outcast/utilities/prefs_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonPreferencesScreen extends ConsumerStatefulWidget {
  static const String routeName = '/lesson-preferences';
  const LessonPreferencesScreen({Key? key}) : super(key: key);

  @override
  _LessonPreferencesScreenState createState() =>
      _LessonPreferencesScreenState();
}

enum DifficultyLevel { easy, medium, hard }

class _LessonPreferencesScreenState extends ConsumerState<LessonPreferencesScreen> {
  DifficultyLevel _selectedDifficulty = DifficultyLevel.easy;

  String _selectedName = '';

  String _selectedTopic = 'Sightseeing';
  String _selectedFromCountry = 'USA';
  String _selectedToCountry = 'Japan';

  PageController _pageController = PageController();

  final List<String> purpose = [
    'Sightseeing',
    'Business',
    'Study',
    'Visit People',
  ];

  final List<String> countries = [
    'USA',
    'UK',
    'Australia',
    'China',
    'Singapore',
    'Japan',
  ];

  void _submitPreferences() {
    if (_selectedFromCountry != _selectedToCountry) {
      // You might navigate to the lesson screen or perform some action.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved. Generating lessons...'),
        ),
      );
      
      ref.read(preferenceProvider.notifier).setPreference(
        Preference(
          level: _selectedDifficulty.name,
          purpose: _selectedTopic,
          fromCountry: _selectedFromCountry,
          toCountry: _selectedToCountry,
        ),
      );
      UserPreferences.setName(_selectedName);
      MyCurriculumDatabaseHelper().insertData(
        fromCountry: _selectedFromCountry,
        toCountry: _selectedToCountry,
        purpose: _selectedTopic,
      );
      
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select different countries.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson Preferences')),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              Container(height: 300, color: Colors.blue[100]),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter your username',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _selectedName = value;
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
          Column(
            children: [
              Container(height: 300, color: Colors.blue[100]),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = DifficultyLevel.easy;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("travel beginner & first visit"),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = DifficultyLevel.medium;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("travel enthusiast & first visit"),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDifficulty = DifficultyLevel.hard;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("travel lover & has visited before"),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Container(height: 300, color: Colors.blue[100]),
              SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTopic = 'Sightseeing';
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("Sightseeing"),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTopic = 'Business';
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("Business"),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTopic = 'Study';
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("Study"),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTopic = 'Visit People';
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("Visit People"),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Container(height: 300, color: Colors.blue[100]),
              SizedBox(height: 30),
              // Add this state variable above the build method if not already defined.

              // Then insert this widget code:
              Column(
                children: [
                  const Text('From'),
                  DropdownButton<String>(
                    value: _selectedFromCountry,
                    items: countries.map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFromCountry = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text('To'),
                  DropdownButton<String>(
                    value: _selectedToCountry,
                    items: countries.map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedToCountry = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitPreferences,
                    child: const Text('Submit Preferences'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
