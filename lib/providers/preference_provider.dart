import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_outcast/utilities/database_helper.dart';

class Preference {
  final String purpose;
  final String fromCountry;
  final String toCountry;
  final String? level;


  Preference copyWith({
    String? purpose,
    String? fromCountry,
    String? toCountry,
    String? level,
  }) {
    return Preference(
      purpose: purpose ?? this.purpose,
      fromCountry: fromCountry ?? this.fromCountry,
      toCountry: toCountry ?? this.toCountry,
      level: level ?? this.level,
    );
  }

  Preference({
    required this.purpose,
    required this.fromCountry,
    required this.toCountry,
    this.level,
  });
}

class PreferenceProvider extends Notifier<List<Preference>> {
  @override
  List<Preference> build() {
    return [];
  }

  void setPreference(Preference preference) {
    state = [...state, preference];
  }

  Future<void> loadPreferences() async {
    final database = await MyCurriculumDatabaseHelper().getAllData();
    state = database!.map((data) {
      return Preference(
        purpose: data['purpose'],
        fromCountry: data['fromCountry'],
        toCountry: data['toCountry'],
      );
    }).toList();
  }
}

final preferenceProvider =
    NotifierProvider<PreferenceProvider, List<Preference>>(
      PreferenceProvider.new,
    );
