import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:visual_novel/visual_novel.dart'; // Your custom VN logic
import '../components/overlay_progress_bar.dart';

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
  List<Map<String, String>> messages = [
    {
      "role": "system",
      "content":
          "You are a friendly quizmaster AI. Generate a JSON array of 10 fun and educational multiple-choice questions about world cultures, traditions, or geography. Each question should be an object with the following fields: question (the question text), choices (an array of 4 possible answers), and answer (the correct answer, which must match one of the choices). Return only the JSON array, not a string or any extra commentary. Do not wrap the array in quotes or markdown. The output must be valid JSON and directly parsable. Example output: [ { \"question\": \"Which Japanese festival is known for its fireworks displays?\", \"choices\": [\"Hanami\", \"Obon\", \"Tanabata\", \"Setsubun\"], \"answer\": \"Tanabata\" }, { \"question\": \"In India, what is the name of the festival of colors?\", \"choices\": [\"Diwali\", \"Holi\", \"Navratri\", \"Ganesh Chaturthi\"], \"answer\": \"Holi\" } ]"
    },
    {
      "role": "assistant",
      "content":
          "Welcome! Ready to test your knowledge of world cultures? Here is your quiz:",
    },
  ];
  List<VisualNovelStep> steps = [];
  int currentStep = 0;
  bool isThinkingAnimated = false;

  final mainCharacter = dawgSprite;

  @override
  void initState() {
    super.initState();
    // Initialise the steps with the assistant's first reply
    steps.add(
      VisualNovelStep(
        text: messages.last["content"]!,
        backgroundAsset: "assets/images/backgrounds/japan_1.png",
        stateTag: "default",
        expectsInput: false,
        choices: ["Alice", "Bob", "Charlie"], // Example choices
        showChoicesInsteadOfInput: true, // Use the new feature
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
    print(response);
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
