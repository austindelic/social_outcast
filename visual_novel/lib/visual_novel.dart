// Export the widgets for consumers of the package
export 'character_sprite.dart';
export 'visual_novel_reader.dart';

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
