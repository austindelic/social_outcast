import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_outcast/providers/preference_provider.dart';
import 'package:social_outcast/utilities/database_helper.dart';
import 'package:social_outcast/utilities/prefs_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';

enum DifficultyLevel { easy, medium, hard }

class LessonPreferencesScreen extends ConsumerStatefulWidget {
  static const String routeName = '/lesson-preferences';
  const LessonPreferencesScreen({Key? key}) : super(key: key);

  @override
  _LessonPreferencesScreenState createState() =>
      _LessonPreferencesScreenState();
}

class _LessonPreferencesScreenState
    extends ConsumerState<LessonPreferencesScreen> {
  int _currentStep = 0;

  // form state
  String _name = '';
  DifficultyLevel? _difficulty;
  String? _purpose;
  String? _fromCountry;
  String? _toCountry;


  // options
  final _purposes = ['Sightseeing', 'Business', 'Study', 'Visit People'];
  final _countries = ['USA', 'UK', 'Australia', 'China', 'Singapore', 'Japan'];

  void _submitPreferences() {
    if (_name.isEmpty ||
        _difficulty == null ||
        _purpose == null ||
        _fromCountry == null ||
        _toCountry == null ||
        _fromCountry == _toCountry) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields correctly.')),
      );
      
      ref.read(preferenceProvider.notifier).setPreference(
        Preference(
          level: _difficulty!.name,
          purpose: _purpose!,
          fromCountry: _fromCountry!,
          toCountry: _toCountry!,
        ),
      );
      UserPreferences.setName(_name);
      MyCurriculumDatabaseHelper().insertData(
        fromCountry: _fromCountry!,
        toCountry: _toCountry!,
        purpose: _purpose!,
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
              Text('Name: $_name'),
              Text('Level: ${_difficulty?.name ?? ''}'),
              Text('Purpose: $_purpose'),
              Text('From: $_fromCountry'),
              Text('To: $_toCountry'),
            ],
          ),
        ),
      ),
    ),
  ];
}