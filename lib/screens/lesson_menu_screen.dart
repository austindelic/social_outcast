import 'package:flutter/material.dart';
import 'package:social_outcast/utilities/prefs_helper.dart';

class LessonMenuScreen extends StatefulWidget {
  static const String routeName = '/lesson-menu';
  const LessonMenuScreen({Key? key}) : super(key: key);

  @override
  _LessonMenuScreenState createState() => _LessonMenuScreenState();
}

enum QuestionType { fourOption, speech, text }

class LessonType {
  final String genre;
  final QuestionType type;

  LessonType({required this.genre, required this.type});
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
    LessonType(genre: 'Transportation', type: QuestionType.fourOption),
    LessonType(genre: 'Hotel Behavior', type: QuestionType.fourOption),
    LessonType(genre: 'Dining Etiquette', type: QuestionType.text),
    LessonType(genre: 'Greetings and Introductions', type: QuestionType.speech),
    LessonType(genre: 'Slang', type: QuestionType.speech),
    LessonType(genre: 'Accent', type: QuestionType.fourOption),
    LessonType(genre: 'Shopping Etiquette', type: QuestionType.fourOption),
    LessonType(genre: 'Laws and Rules', type: QuestionType.fourOption),
    LessonType(genre: 'Technology Use and Communication', type: QuestionType.text),
    LessonType(genre: 'Cultural Sensitivities', type: QuestionType.text),
    LessonType(genre: 'Business Situation', type: QuestionType.fourOption),
    LessonType(genre: 'Home Stay', type: QuestionType.fourOption),
    LessonType(genre: 'Basic Language', type: QuestionType.fourOption),
    LessonType(genre: 'Behavior on Street', type: QuestionType.fourOption),
    LessonType(genre: 'Accent', type: QuestionType.fourOption),
  ];

@override
  void initState() {
    super.initState();
    if(UserPreferences.getIsGenerated() == true){
      generateLessons();
    }
  }

  Future<void> generateLessons() async {
    
    Navigator.pushNamed(context, '/lesson-screen');
  }

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
