class CharacterSpriteState {
  final String asset; // default for single frame states
  final List<String> assetFrames; // for animation (e.g., thinking)
  final String tag;

  const CharacterSpriteState({
    required this.tag,
    this.asset = '',
    this.assetFrames = const [],
  });
}

class Character {
  final Map<String, CharacterSpriteState> states;

  const Character({required this.states});

  CharacterSpriteState getState(String tag) =>
      states[tag] ?? states.values.first;
}
