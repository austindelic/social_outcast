import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_outcast/providers/preference_provider.dart';
import 'package:social_outcast/utilities/llm_helper.dart';
import 'package:social_outcast/utilities/prefs_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonMenuScreen extends ConsumerStatefulWidget {
  static const String routeName = '/lesson-menu';
  const LessonMenuScreen({Key? key}) : super(key: key);

  @override
  _LessonMenuScreenState createState() => _LessonMenuScreenState();
}


class Lesson {
  final String genre;
  final String type;

  Lesson({required this.genre, required this.type});
}

class _LessonMenuScreenState extends ConsumerState<LessonMenuScreen> {
  List suggestedLessons = [];
  bool isInit = true;

  final Map<String, String> questionTypes = {
    'Transportation': 'fourOption',
    'Hotel Behavior': 'fourOption',
    'Accent': 'speech',
    'Shopping Etiquette': 'fourOption',
    'Laws and Rules': 'fourOption',
    'Business Situation': 'text',
    'Home Stay': 'text',
    'Basic Language': 'speech',
    'Behavior on Street': 'fourOption',
    'Dining Etiquette': 'fourOption',
    'Technology Use and Communication': 'text',
    'Cultural Sensitivities': 'fourOption',
    'Greetings and Introductions': 'speech',
    'Slang': 'speech',
  };

  @override
  void initState() {
    super.initState();
    if (UserPreferences.getIsGenerated() == true) {
      generateLessons();
    }
  }

  Future<void> generateLessons() async {
    print('Generating lessons...');
    final genres = '''
  Transportation, Hotel Behavior, Dining Etiquette, Greetings and Introductions, Slang, Accent, Shopping Etiquette,Laws and Rules, Technology Use and Communication, Cultural Sensitivities,
''';
    final selectedGenre = ref.read(preferenceProvider).purpose;
    final selectedFromCountry = ref.read(preferenceProvider).fromCountry;
    final selectedToCountry = ref.read(preferenceProvider).toCountry;
    final selectedLevel = ref.read(preferenceProvider).level;
    final lessonResponce = await GeminiHelper.generateLessons(
      genres,
      selectedLevel,
      selectedGenre,
      selectedFromCountry,
      selectedToCountry,
    );

    Map<String, dynamic> result = jsonDecode(lessonResponce);
    var text = result['candidates'][0]['content']['parts'][0]['text'];
    print(text);
    // Convert text string into a list of lesson genres.
    String jsonString =
        '["Transportation","Dining Etiquette","Greetings and Introductions","Shopping Etiquette","Technology Use and Communication","Cultural Sensitivities"]';

    List<dynamic> rawList = jsonDecode(jsonString);
    List<String> stringList = List<String>.from(rawList);
    for (String genre in stringList) {
      print(questionTypes[genre]);
      setState(() {
        suggestedLessons.add(Lesson(genre: genre, type: questionTypes[genre]!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UserPreferences.getIsGenerated() != true && isInit) {
      generateLessons();
      isInit = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: (suggestedLessons.length == 6)
          ? ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                final lesson = suggestedLessons[index];
                return ListTile(
                  title: Text(lesson.genre),
                  subtitle: Text(lesson.type),
                  onTap: () {},
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Generating the best lessons for you...'),
                  LinearProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
