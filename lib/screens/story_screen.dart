import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:visual_novel/visual_novel.dart'; // Your custom VN logic
import '../components/overlay_progress_bar.dart';

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
  List<Map<String, String>> messages = [
    {
      "role": "system",
      "content": "You are my friend, talk to me in short consise snippets.",
    },
    {"role": "assistant", "content": "Welcome! What is your name?"},
  ];

  List<VisualNovelStep> steps = [];
  int currentStep = 0;
  bool isThinkingAnimated = false;

  final mainCharacter = platypusSprite;

  @override
  void initState() {
    super.initState();
    // Initialise the steps with the assistant's first reply
    steps.add(
      VisualNovelStep(
        text: messages.last["content"]!,
        backgroundAsset: "assets/images/backgrounds/japan_1.png",
        stateTag: "default",
        expectsInput: true,
      ),
    );
  }

  Future<void> fetchNextStep(String userContent) async {
    setState(() => isThinkingAnimated = true);

    // Add user reply to messages
    messages.add({"role": "user", "content": userContent});
    final dio = Dio();
    // Send conversation to ai.hackclub.com
    final response = await dio.post(
      'https://ai.hackclub.com/chat/completions',
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {"messages": messages},
    );

    // Parse assistant reply
    String aiReply;
    try {
      aiReply = response.data["choices"][0]["message"]["content"];
    } catch (_) {
      aiReply = "Sorry, there was an error. Try again!";
    }

    // Add assistant reply to messages
    messages.add({"role": "assistant", "content": aiReply});

    // Parse reply for choices (primitive example; use RegEx/AI parsing for more)
    final choiceRegex = RegExp(r'\[(.*?)\]', multiLine: true);
    final matches = choiceRegex.allMatches(aiReply);
    List<String>? choices;
    if (matches.isNotEmpty) {
      choices = matches.map((m) => m.group(1) ?? '').toList();
      aiReply = aiReply.replaceAll(choiceRegex, '').trim();
    }

    // Guess if input is expected (no choices = expects input)
    bool expectsInput = choices == null || choices.isEmpty;

    // Append next step
    setState(() {
      steps.add(
        VisualNovelStep(
          text: aiReply,
          backgroundAsset: "assets/images/backgrounds/japan_1.png",
          stateTag: "default",
          expectsInput: expectsInput,
          choices: choices,
        ),
      );
      currentStep++;
      isThinkingAnimated = false;
    });
  }

  void _handleInput(String value) async {
    await fetchNextStep(value);
  }

  void _handleChoice(String choice) async {
    await fetchNextStep(choice);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isEnd = false; // Never ends (infinite)

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main VN content
          Positioned.fill(
            child: VisualNovelReader(
              character: mainCharacter,
              step: steps[currentStep],
              isThinkingAnimated: isThinkingAnimated,
              onInput: _handleInput,
              onChoice: _handleChoice,
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
