import 'package:flutter/material.dart';

import 'package:visual_novel/visual_novel.dart'; // Your custom VN logic
import '../components/overlay_progress_bar.dart';
import '../utilities/database_helper.dart';

const countryNameToCode = {
  'Australia': 'au',
  'France': 'fr',
  'Japan': 'jp',
  'Brazil': 'br',
  'United States': 'us',
  'India': 'in',
  // ...add more as needed
};

String getCountryCode(String? countryName) {
  if (countryName == null) return 'xx';
  return countryNameToCode[countryName] ?? 'xx';
}

final dawgSprite = Character(
  states: {
    "default": CharacterSpriteState(
      tag: "default",
      asset: "assets/images/sprites/dawg/dawg_default.png",
    ),
    "thinking": CharacterSpriteState(
      tag: "thinking",
      assetFrames: [
        "assets/images/sprites/dawg/dawg_thinking_1.png",
        "assets/images/sprites/dawg/dawg_thinking_2.png",
        "assets/images/sprites/dawg/dawg_thinking_3.png",
      ],
    ),
  },
);

final otterSprite = Character(
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

final platypusSprite = Character(
  states: {
    "default": CharacterSpriteState(
      tag: "default",
      asset: "assets/images/sprites/platypus/platypus_default.png",
    ),
    "thinking": CharacterSpriteState(
      tag: "thinking",
      assetFrames: [
        "assets/images/sprites/platypus/platypus_thinking_1.png",
        "assets/images/sprites/platypus/platypus_thinking_2.png",
        "assets/images/sprites/platypus/platypus_thinking_3.png",
      ],
    ),
  },
);

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<VisualNovelStep> steps = [];
  int currentStep = 0;
  bool isThinkingAnimated = false;
  final mainCharacter = dawgSprite;
  bool showHelp = false;
  String? helpQuestion;
  List<String> helpMessages = [];
  Set<int> stepsWithTextInput = {};
  TextEditingController tempInputController = TextEditingController();
  TextEditingController helpChatController = TextEditingController();
  String? feedbackMessage; // For wrong answer feedback

  @override
  void initState() {
    super.initState();
    _loadQuizFromDatabase();
  }

  @override
  void dispose() {
    tempInputController.dispose();
    helpChatController.dispose();
    super.dispose();
  }

  Future<void> _loadQuizFromDatabase() async {
    final puzzles = await PuzzleDatabaseHelper().getAllData();
    if (puzzles != null && puzzles.isNotEmpty) {
      setState(() {
        steps = puzzles
            .map(
              (puzzle) => VisualNovelStep(
                text: puzzle['prompt'] ?? '',
                backgroundAsset: "assets/images/backgrounds/japan_1.png",
                stateTag: "default",
                expectsInput: false,
                choices: [
                  puzzle['option1']?.toString() ?? '',
                  puzzle['option2']?.toString() ?? '',
                  puzzle['option3']?.toString() ?? '',
                  puzzle['option4']?.toString() ?? '',
                ].where((c) => c.isNotEmpty).toList(),
                showChoicesInsteadOfInput: true,
                correctAnswer: puzzle['answer']?.toString() ?? '',
              ),
            )
            .toList();
      });
    } else {
      setState(() {
        steps = [
          VisualNovelStep(
            text: "What is the capital of France?",
            backgroundAsset: "assets/images/backgrounds/japan_1.png",
            stateTag: "default",
            expectsInput: false,
            choices: ["Paris", "London", "Berlin", "Madrid"],
            showChoicesInsteadOfInput: true,
            correctAnswer: 'Paris',
          ),
          VisualNovelStep(
            text: "Which country is known as the Land of the Rising Sun?",
            backgroundAsset: "assets/images/backgrounds/japan_1.png",
            stateTag: "default",
            expectsInput: false,
            choices: ["Japan", "China", "Korea", "Thailand"],
            showChoicesInsteadOfInput: true,
            correctAnswer: 'Japan', // Make sure this matches exactly
          ),
          VisualNovelStep(
            text: "Which continent is Brazil located in?",
            backgroundAsset: "assets/images/backgrounds/japan_1.png",
            stateTag: "default",
            expectsInput: false,
            choices: ["South America", "Europe", "Asia", "Africa"],
            showChoicesInsteadOfInput: true,
            correctAnswer: 'South America',
          ),
        ];
      });
    }
  }

  void _handleInput(String value) async {
    // await fetchNextStep(value);
  }

  void _handleChoice(String choice) async {
    final correct = steps[currentStep].correctAnswer ?? '';
    if (choice.trim() == correct.trim()) {
      setState(() {
        feedbackMessage = null;
        stepsWithTextInput.remove(currentStep);
        tempInputController.clear();
        currentStep++;
        showHelp = false;
      });
    } else {
      setState(() {
        feedbackMessage = 'Incorrect. Try again!';
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            feedbackMessage = null;
          });
        }
      });
    }
  }

  void _showHelp(String question) {
    setState(() {
      showHelp = true;
      helpQuestion = question;
      helpMessages = [
        'You are now chatting with the bot about this question. Ask anything you need to understand!',
      ];
    });
  }

  void _sendHelpMessage(String message) async {
    // Here you would call your AI backend. For now, just echo.
    setState(() {
      helpMessages.add('You: $message');
      helpMessages.add('Bot: (AI response placeholder)');
    });
  }

  void _closeHelp() {
    setState(() {
      showHelp = false;
      helpQuestion = null;
      helpMessages = [];
    });
  }

  void _toggleTextInputForCurrentStep() {
    setState(() {
      if (stepsWithTextInput.contains(currentStep)) {
        stepsWithTextInput.remove(currentStep);
        tempInputController.clear();
      } else {
        stepsWithTextInput.add(currentStep);
        tempInputController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEnd = false; // Never ends (infinite)

    final showTextInput = stepsWithTextInput.contains(currentStep);
    final currentStepObj = steps.isNotEmpty
        ? steps[currentStep]
        : VisualNovelStep(text: '', stateTag: 'default');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (currentStep >= steps.length)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 80),
                  SizedBox(height: 24),
                  Text(
                    'Quiz Complete!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Exit'),
                  ),
                ],
              ),
            )
          else
            Positioned.fill(
              child: VisualNovelReader(
                character: mainCharacter,
                step: currentStepObj,
                isThinkingAnimated: isThinkingAnimated,
                onInput: _handleInput,
                onChoice: _handleChoice,
                // Pass help button builder
                helpButtonBuilder: () => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      showTextInput ? Icons.close : Icons.help_outline,
                      color: Colors.blue,
                    ),
                    tooltip: showTextInput
                        ? 'Return to multi-choice'
                        : 'Need help with this question?',
                    onPressed: _toggleTextInputForCurrentStep,
                  ),
                ),
                // Add a builder for the choices/text input UI
                customChoicesBuilder: showTextInput
                    ? (context, step) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: tempInputController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText:
                                    'Type your answer or thoughts... (press Enter to submit)',
                              ),
                              onSubmitted: (val) {
                                _handleInput(val);
                                setState(() {
                                  stepsWithTextInput.remove(currentStep);
                                  tempInputController.clear();
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: Icon(Icons.check),
                              label: Text('Submit'),
                              onPressed: () async {
                                final val = tempInputController.text.trim();
                                if (val.isNotEmpty) {
                                  setState(() {
                                    helpQuestion = 'Response:';
                                    isThinkingAnimated = true;
                                    showHelp = true;
                                    helpMessages.add('You: $val');
                                  });
                                  await Future.delayed(const Duration(seconds: 1));
                                  setState(() {
                                    helpMessages.add('Bot: (AI response placeholder)');
                                    isThinkingAnimated = false;
                                    tempInputController.clear();
                                    stepsWithTextInput.remove(currentStep);
                                  });
                                  // Do NOT auto-close help overlay; user must press End
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          if (showHelp)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Help for:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            helpQuestion ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: ListView(
                              children: helpMessages
                                  .map(
                                    (m) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Text(m),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: helpChatController,
                                  decoration: InputDecoration(
                                    hintText: 'Ask your question...',
                                  ),
                                  onSubmitted: (msg) {
                                    if (msg.trim().isNotEmpty) {
                                      _sendHelpMessage(msg.trim());
                                      helpChatController.clear();
                                    }
                                  },
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  final msg = helpChatController.text.trim();
                                  if (msg.isNotEmpty) {
                                    _sendHelpMessage(msg);
                                    helpChatController.clear();
                                  }
                                },
                                child: Text('Send'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: _closeHelp,
                                child: Text('End'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (feedbackMessage != null)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  color: Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    child: Text(
                      feedbackMessage!,
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ),
              ),
            ),
          // Overlay progress bar always on top
          OverlayProgressBar(
            currentStep: currentStep,
            totalSteps: steps.length,
          ),
        ],
      ),
    );
  }
}
