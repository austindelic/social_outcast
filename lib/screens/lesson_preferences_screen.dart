import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_outcast/providers/preference_provider.dart';
import 'package:social_outcast/utilities/database_helper.dart';
import 'package:social_outcast/utilities/prefs_helper.dart';

enum DifficultyLevel { easy, medium, hard }

class LessonPreferencesScreen extends ConsumerStatefulWidget {
  static const String routeName = '/lesson-preferences';
  const LessonPreferencesScreen({super.key});

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
      return;
    }

    // persist
    ref
        .read(preferenceProvider.notifier)
        .setPreference(
          Preference(
            // name: _name, //TODO: FIX
            level: _difficulty!.name,
            purpose: _purpose!,
            fromCountry: _fromCountry!,
            toCountry: _toCountry!,
          ),
        );
    UserPreferences.setName(_name);
    MyCurriculumDatabaseHelper().insertData(
      _name,
      _fromCountry!,
      _toCountry!,
      _purpose!,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Preferences saved!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Preferences'),
        backgroundColor: Colors.teal,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == _steps.length - 1) {
            _submitPreferences();
          } else {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        steps: _steps,
        controlsBuilder: (context, details) {
          final isLast = _currentStep == _steps.length - 1;
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text(isLast ? 'Submit' : 'Next'),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Step> get _steps => [
    // 1. Name
    Step(
      title: const Text('Your Name'),
      isActive: _currentStep >= 0,
      state: _name.isNotEmpty ? StepState.complete : StepState.indexed,
      content: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Enter your name',
          border: OutlineInputBorder(),
        ),
        onChanged: (val) => setState(() => _name = val.trim()),
      ),
    ),

    // 2. Difficulty
    Step(
      title: const Text('Experience'),
      isActive: _currentStep >= 1,
      state: _difficulty != null ? StepState.complete : StepState.indexed,
      content: Column(
        children: DifficultyLevel.values.map((level) {
          final label = {
            DifficultyLevel.easy: 'Beginner',
            DifficultyLevel.medium: 'Enthusiast',
            DifficultyLevel.hard: 'Experienced',
          }[level]!;
          return RadioListTile<DifficultyLevel>(
            value: level,
            groupValue: _difficulty,
            title: Text(label),
            activeColor: Colors.teal,
            onChanged: (v) => setState(() => _difficulty = v),
          );
        }).toList(),
      ),
    ),

    // 3. Purpose
    Step(
      title: const Text('Purpose'),
      isActive: _currentStep >= 2,
      state: _purpose != null ? StepState.complete : StepState.indexed,
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _purposes.map((p) {
          return ChoiceChip(
            label: Text(p),
            selected: _purpose == p,
            selectedColor: Colors.teal.shade200,
            onSelected: (_) => setState(() => _purpose = p),
          );
        }).toList(),
      ),
    ),

    // 4. Countries
    Step(
      title: const Text('Route'),
      isActive: _currentStep >= 3,
      state:
          (_fromCountry != null &&
              _toCountry != null &&
              _fromCountry != _toCountry)
          ? StepState.complete
          : StepState.indexed,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'From',
              border: OutlineInputBorder(),
            ),
            items: _countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            value: _fromCountry,
            onChanged: (v) => setState(() => _fromCountry = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'To',
              border: OutlineInputBorder(),
            ),
            items: _countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            value: _toCountry,
            onChanged: (v) => setState(() => _toCountry = v),
          ),
          if (_fromCountry != null &&
              _toCountry != null &&
              _fromCountry == _toCountry)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Please choose different countries',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    ),

    // 5. Review
    Step(
      title: const Text('Review'),
      isActive: _currentStep >= 4,
      state: StepState.indexed,
      content: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
