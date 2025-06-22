import 'package:flutter/material.dart';
import 'package:culture_lessons/culture_lessons.dart';

class PuzzleRunnerScreen extends StatelessWidget {
  final Lesson lesson = Lesson(
    id: 1,
    unitId: 1,
    subjectContext: "Culture",
    title: "Sample Culture Lesson",
  );

  final List<Puzzle> puzzles = [
    Puzzle(
      id: 1,
      type: PuzzleType.multipleChoice,
      prompt: "What is the capital of France?",
      options: ["Berlin", "Madrid", "Paris", "Rome"],
      correctIndex: 2,
    ),
    Puzzle(
      id: 2,
      type: PuzzleType.textToText,
      prompt: "Say hello in Japanese.",
    ),
    Puzzle(
      id: 3,
      type: PuzzleType.voiceToVoice,
      prompt: "Introduce yourself in English.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: ListView.builder(
        itemCount: puzzles.length,
        itemBuilder: (context, index) {
          final puzzle = puzzles[index];
          return ListTile(
            title: Text(puzzle.prompt),
            subtitle: puzzle.type == PuzzleType.multipleChoice
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: puzzle.options!
                        .map((option) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(option),
                            ))
                        .toList(),
                  )
                : null,
          );
        },
      ),
    );
  }
}