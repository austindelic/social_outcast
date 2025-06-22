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
      'options': options != null ? options!.join('|') : null,
      'correctIndex': correctIndex,
    };
  }
}

// class Lesson {
//   final int id;
//   final int unitId; // FK to Unit
//   final String subjectContext;
//   final String title;

//   Lesson({
//     required this.id,
//     required this.unitId,
//     required this.subjectContext,
//     required this.title,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'unitId': unitId,
//       'subjectContext': subjectContext,
//       'title': title,
//     };
//   }

//   factory Lesson.fromMap(Map<String, dynamic> map) {
//     return Lesson(
//       id: map['id'],
//       unitId: map['unitId'],
//       subjectContext: map['subjectContext'],
//       title: map['title'],
//     );
//   }
// }

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