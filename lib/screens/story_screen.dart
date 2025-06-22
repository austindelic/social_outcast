import 'package:flutter/material.dart';
import 'package:visual_novel/visual_novel.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VisualNovelReader(
        novel: VisualNovel(
          title: 'The Social Outcast',
          backgroundAsset: 'assets/images/backgrounds/example.png',
          characterAsset: 'assets/images/sprites/example.png',
          introText: 'Welcome to your journey. What is your name?',
        ),
        onInput: (name) {
          // You can do whatever you like here! For now, just print.
          print('User entered: $name');
          // You could also navigate, update state, etc.
        },
      ),
    );
  }
}
