import 'package:flutter/material.dart';
import 'package:culture_lessons/culture_lessons.dart';

class PuzzleRunnerScreen extends StatelessWidget {
  final Lesson lesson = Lesson(
    subjectContext: "Culture",
    title: "Sample Culture Lesson",
    puzzles: [
      Puzzle.multipleChoice(
        prompt: "What is the capital of France?",
        options: ["Berlin", "Madrid", "Paris", "Rome"],
        correctIndex: 2,
      ),
      Puzzle.textToText(prompt: "Say hello in Japanese."),
      Puzzle.voiceToVoice(prompt: "Introduce yourself in English."),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: ListView.builder(
        itemCount: lesson.puzzles.length,
        itemBuilder: (context, index) {
          final puzzle = lesson.puzzles[index];
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