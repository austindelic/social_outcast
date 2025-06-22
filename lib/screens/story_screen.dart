import 'package:flutter/material.dart';
import 'package:visual_novel/visual_novel.dart';
import 'package:visual_novel/visual_novel_step.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentStep = 0;
  String? userName;

  late final List<VisualNovelStep> steps = [
    VisualNovelStep(
      text: "Welcome! What is your name?",
      backgroundAsset: "assets/images/backgrounds/example.png",
      characterAsset: "assets/images/sprites/example.png",
      expectsInput: true,
    ),
    VisualNovelStep(
      text: "Nice to meet you!",
      backgroundAsset: "assets/images/backgrounds/example.png",
      characterAsset: "assets/images/sprites/example.png",
      choices: ["Begin journey", "Exit"],
    ),
    // ... more steps or dynamic step generation
  ];

  void handleInput(String value) {
    setState(() {
      userName = value;
      currentStep++;
    });
  }

  void handleChoice(String choice) {
    setState(() {
      if (choice == "Exit") {
        // handle exit
      } else {
        currentStep++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Prevent going out of bounds!
    if (currentStep >= steps.length) {
      return Scaffold(
        body: Center(
          child: Text(
            'The End!',
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      );
    }

    return Scaffold(
      body: VisualNovelReader(
        step: steps[currentStep],
        onInput: handleInput,
        onChoice: handleChoice,
      ),
    );
  }
}
