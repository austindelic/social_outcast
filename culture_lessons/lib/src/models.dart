enum PuzzleType {
  multipleChoice,
  textToText,
  voiceToVoice,
}

class Puzzle {
  final int id;
  final PuzzleType type;
  final int unitId;
  final String prompt;
  final List<String>? options; // Stored as joined string in SQLite
  final int? correctIndex;

  Puzzle({
    required this.id,
    required this.unitId,
    required this.type,
    required this.prompt,
    this.options,
    this.correctIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'prompt': prompt,
      'options': options?.join('|'),
      'correctIndex': correctIndex,
    };
  }

  factory Puzzle.fromMap(Map<String, dynamic> map) {
    return Puzzle(
      id: map['id'],
      unitId: map['unitId'],
      type: PuzzleType.values[map['type']],
      prompt: map['prompt'],
      options:
          map['options'] != null ? (map['options'] as String).split('|') : null,
      correctIndex: map['correctIndex'],
    );
  }
}

class Unit {
  final int id;
  final int tripId; // FK to Trip
  final String title;

  Unit({
    required this.id,
    required this.tripId,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'title': title,
    };
  }

  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      id: map['id'],
      tripId: map['tripId'],
      title: map['title'],
    );
  }
}

class Trip {
  final int id;
  final String fromCountry;
  final String toCountry;

  Trip({
    required this.id,
    required this.fromCountry,
    required this.toCountry,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      fromCountry: map['fromCountry'],
      toCountry: map['toCountry'],
    );
  }
}
