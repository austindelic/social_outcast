import 'package:flutter/material.dart';

class CharacterSprite extends StatelessWidget {
  final String imagePath;
  final double height;

  const CharacterSprite({
    super.key,
    required this.imagePath,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath, height: height);
  }
}
