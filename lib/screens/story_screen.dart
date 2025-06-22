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

  @override
  void initState() {
    super.initState();
    _loadQuizFromDatabase();
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
              ),
            )
            .toList();
      });
    } else {
      setState(() {
        steps = [
          VisualNovelStep(
            text: "No quiz data found in database.",
            backgroundAsset: "assets/images/backgrounds/japan_1.png",
            stateTag: "default",
            expectsInput: false,
            choices: [],
            showChoicesInsteadOfInput: false,
          ),
        ];
      });
    }
  }

  void _handleInput(String value) async {
    // await fetchNextStep(value);
  }

  void _handleChoice(String choice) async {
    // await fetchNextStep(choice);
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

  @override
  Widget build(BuildContext context) {
    final isEnd = false; // Never ends (infinite)

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main VN content
          Positioned.fill(
            child: VisualNovelReader(
              character: mainCharacter,
              step: steps.isNotEmpty
                  ? steps[currentStep]
                  : VisualNovelStep(text: '', stateTag: 'default'),
              isThinkingAnimated: isThinkingAnimated,
              onInput: _handleInput,
              onChoice: _handleChoice,
              // Pass help button builder
              helpButtonBuilder: () => IconButton(
                icon: Icon(Icons.help_outline, color: Colors.blue),
                tooltip: 'Need help with this question?',
                onPressed: () => _showHelp(steps[currentStep].text),
              ),
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
                                  onSubmitted: (msg) => _sendHelpMessage(msg),
                                  decoration: InputDecoration(
                                    hintText: 'Ask your question...',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: _closeHelp,
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
