import 'package:flutter/material.dart';

class LessonMenuScreen extends StatefulWidget {
  static const String routeName = '/lesson-menu';
  const LessonMenuScreen({Key? key}) : super(key: key);

  @override
  _LessonMenuScreenState createState() => _LessonMenuScreenState();
}

enum QuestionType { fourOption, speech, text }

class Lesson {
  final String genre;
  final QuestionType type;

  Lesson({required this.genre, required this.type});
}

class _LessonMenuScreenState extends State<LessonMenuScreen> {
  /*
  choose 6 based on user's preference
  Transportation
  Hotel Behavior
  Dining Etiquette
  Greetings and Introductions
  Slang
  Accent
  Shopping Etiquette
  Laws and Rules
  Technology Use and Communication
  Cultural Sensitivities
  Business Situation
  Home Stay
  Basic Language
  Behavior on Street
  Accent
  */
  final lessons = [
    Lesson(genre: 'Transportation', type: QuestionType.fourOption),
    Lesson(genre: 'Hotel Behavior', type: QuestionType.fourOption),
    Lesson(genre: 'Dining Etiquette', type: QuestionType.text),
    Lesson(genre: 'Greetings and Introductions', type: QuestionType.speech),
    Lesson(genre: 'Slang', type: QuestionType.speech),
    Lesson(genre: 'Accent', type: QuestionType.fourOption),
    Lesson(genre: 'Shopping Etiquette', type: QuestionType.fourOption),
    Lesson(genre: 'Laws and Rules', type: QuestionType.fourOption),
    Lesson(genre: 'Technology Use and Communication', type: QuestionType.text),
    Lesson(genre: 'Cultural Sensitivities', type: QuestionType.text),
    Lesson(genre: 'Business Situation', type: QuestionType.fourOption),
    Lesson(genre: 'Home Stay', type: QuestionType.fourOption),
    Lesson(genre: 'Basic Language', type: QuestionType.fourOption),
    Lesson(genre: 'Behavior on Street', type: QuestionType.fourOption),
    Lesson(genre: 'Accent', type: QuestionType.fourOption),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return ListTile(
            title: Text(lesson.genre),
            subtitle: Text(lesson.type.name),
            onTap: () {
              // Navigate to detail screen (implement as needed)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => LessonDetailScreen(lesson)));
            },
          );
        },
      ),
    );
  }
}
