import 'package:culture_lessons/culture_lessons.dart';

class TripData {
  static const countryNameToCode = {
    'australia': 'au',
    'france': 'fr',
    'japan': 'jp',
    'brazil': 'br',
    'united states': 'us',
    'usa': 'us',
    'us': 'us',
    'india': 'in',
    // …add more as you need
  };
  static int? getTripId(String fromCountry, String toCountry) {
    try {
      var trips = tripData.values.toList();
      return trips
          .firstWhere(
            (trip) =>
                trip.fromCountry == fromCountry && trip.toCountry == toCountry,
          )
          .id;
    } catch (e) {
      return null;
    }
  }

  static final List<String> countries = countryNameToCode.keys.toList();

  static Map<int, Trip> tripData = (() {
    final data = <int, Trip>{};
    int tripId = 1;
    for (var from in countries) {
      for (var to in countries) {
        if (from != to) {
          data[tripId] = Trip(id: tripId, fromCountry: from, toCountry: to);
          tripId++;
        }
      }
    }
    return data;
  })();
}

class UnitData {
  static final Map<String, String> questionTypeMap = {
    'Transportation': 'fourOption',
    'Hotel Behavior': 'fourOption',
    'Accent': 'speech',
    'Shopping Etiquette': 'fourOption',
    'Laws and Rules': 'fourOption',
    'Business Situation': 'text',
    'Home Stay': 'text',
    'Basic Language': 'speech',
    'Behavior on Street': 'fourOption',
    'Dining Etiquette': 'fourOption',
    'Technology Use and Communication': 'text',
    'Cultural Sensitivities': 'fourOption',
    'Greetings and Introductions': 'speech',
    'Slang': 'speech',
  };
  static int getUnitId(String fromCountry, String toCountry, String genre) {
    try {
      var tripId = TripData.getTripId(fromCountry, toCountry);
      return unitData.values
          .firstWhere((unit) => unit.tripId == tripId && unit.title == genre)
          .id;
    } catch (e) {
      return 0;
    }
  }

  static final List<String> genres = questionTypeMap.keys.toList();
  static Map<int, Unit> unitData = (() {
    final data = <int, Unit>{};
    int unitId = 1;
    for (var trip in TripData.tripData.values) {
      for (var genre in genres) {
        data[unitId] = Unit(id: unitId, tripId: trip.id, title: genre);
        unitId++;
      }
    }
    return data;
  })();
}
