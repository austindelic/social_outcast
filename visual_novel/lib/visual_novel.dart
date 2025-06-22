// visual_novel.dart
// Export the widgets for consumers of the package
export 'character_sprite.dart';
export 'visual_novel_reader.dart';
import 'package:flutter/material.dart';

class VisualNovel {
  final String title;
  final String backgroundAsset;
  final String characterAsset;
  final String introText;

  const VisualNovel({
    required this.title,
    required this.backgroundAsset,
    required this.characterAsset,
    required this.introText,
  });
}

class VisualNovelStep {
  final String text;
  final String? backgroundAsset;
  final String stateTag; // Only one character, so just which state to show
  final bool expectsInput;
  final List<String>? choices;
  final Widget? customWidget;
  final bool
      showChoicesInsteadOfInput; // NEW: allow forcing choices instead of input

  const VisualNovelStep({
    required this.text,
    this.backgroundAsset,
    required this.stateTag,
    this.expectsInput = false,
    this.choices,
    this.customWidget,
    this.showChoicesInsteadOfInput = false, // NEW: default to false
  });
}
