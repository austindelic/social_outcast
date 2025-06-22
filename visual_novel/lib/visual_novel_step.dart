import 'package:flutter/material.dart';

class VisualNovelStep {
  final String text;
  final String? backgroundAsset;
  final String? characterAsset;
  final bool expectsInput;
  final List<String>? choices;
  final Widget? customWidget;

  const VisualNovelStep({
    required this.text,
    this.backgroundAsset,
    this.characterAsset,
    this.expectsInput = false,
    this.choices,
    this.customWidget,
  });
}
