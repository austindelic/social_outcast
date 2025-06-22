// models.dart
enum PuzzleType {
  multipleChoice,
  textToText,
  voiceToVoice,
}

class Puzzle {
  final PuzzleType type;
  final String prompt; // unified
  final List<String>? options; // only for multiple choice
  final int? correctIndex;     // only for multiple choice

  Puzzle.multipleChoice({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  }) : type = PuzzleType.multipleChoice;

  Puzzle.textToText({
    required this.prompt,
  }) : type = PuzzleType.textToText,
       options = null,
       correctIndex = null;

  Puzzle.voiceToVoice({
    required this.prompt,
  }) : type = PuzzleType.voiceToVoice,
       options = null,
       correctIndex = null;
}

class Lesson {
  final String subjectContext;
  final String title;
  final List<Puzzle> puzzles;

  Lesson({
    required this.subjectContext,
    required this.title,
    required this.puzzles,
  });
}

class Unit {
  final String title;
  final List<Lesson> lessons;

  Unit({
    required this.title,
    required this.lessons,
  });
}