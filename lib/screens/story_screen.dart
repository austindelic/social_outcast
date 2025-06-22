import 'package:flutter/material.dart';
import 'package:visual_novel/visual_novel.dart';
import '../components/overlay_progress_bar.dart';
// Import your VN core, e.g. visual_novel.dart, character_sprite.dart, etc.

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentStep = 0;
  bool isThinkingAnimated = false;

  final mainCharacter = Character(
    states: {
      "default": CharacterSpriteState(
        tag: "default",
        asset: "assets/images/sprites/otter/otter_default.png",
      ),
      "thinking": CharacterSpriteState(
        tag: "thinking",
        assetFrames: [
          "assets/images/sprites/otter/otter_thinking_1.png",
          "assets/images/sprites/otter/otter_thinking_2.png",
          "assets/images/sprites/otter/otter_thinking_3.png",
        ],
      ),
    },
  );

  late final List<VisualNovelStep> steps = [
    VisualNovelStep(
      text: "Welcome! What is your name?",
      backgroundAsset: "assets/images/backgrounds/japan_1.png",
      stateTag: "default",
      expectsInput: true,
    ),
    VisualNovelStep(
      text: "This is a test!!",
      backgroundAsset: "assets/images/backgrounds/japan_1.png",
      stateTag: "default",
      choices: ["Begin journey", "Exit"],
    ),
  ];

  void _handleInput(String value) async {
    setState(() {
      isThinkingAnimated = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      currentStep++;
      isThinkingAnimated = false;
    });
  }

  void _handleChoice(String choice) async {
    setState(() {
      isThinkingAnimated = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (choice == "Exit") {
        currentStep = steps.length;
      } else {
        currentStep++;
      }
      isThinkingAnimated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEnd = currentStep >= steps.length;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main VN content
          Positioned.fill(
            child: isEnd
                ? Center(
                    child: Text(
                      "The End!",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : VisualNovelReader(
                    character: mainCharacter,
                    step: steps[currentStep],
                    isThinkingAnimated: isThinkingAnimated,
                    onInput: _handleInput,
                    onChoice: _handleChoice,
                  ),
          ),
          // Overlay progress bar always on top
          if (!isEnd)
            OverlayProgressBar(
              currentStep: currentStep,
              totalSteps: steps.length,
            ),
        ],
      ),
    );
  }
}
