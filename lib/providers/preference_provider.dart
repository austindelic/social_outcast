import 'package:flutter_riverpod/flutter_riverpod.dart';
class Preference {
  final String name;
  final String level;
  final String purpose;
  final String fromCountry;
  final String toCountry;

  Preference copyWith({
    String? name,
    String? level,
    String? purpose,
    String? fromCountry,
    String? toCountry,
  }) {
    return Preference(
      name: name ?? this.name,
      level: level ?? this.level,
      purpose: purpose ?? this.purpose,
      fromCountry: fromCountry ?? this.fromCountry,
      toCountry: toCountry ?? this.toCountry,
    );
  }

  Preference({
    required this.name,
    required this.level,
    required this.purpose,
    required this.fromCountry,
    required this.toCountry,
  });
}

class PreferenceProvider extends Notifier<Preference> {
  @override
  Preference build() {
    return Preference(
      name: '',
      level: '',
      purpose: '',
      fromCountry: '',
      toCountry: '',
    );
  }

  void setPreference(Preference preference) {
    state = preference;
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setLevel(String level) {
    state = state.copyWith(level: level);
  }

  void setPurpose(String purpose) {
    state = state.copyWith(purpose: purpose);
  }

  void setFromCountry(String fromCountry) {
    state = state.copyWith(fromCountry: fromCountry);
  }

  void setToCountry(String toCountry) {
    state = state.copyWith(toCountry: toCountry);
  }
}

final preferenceProvider =
    NotifierProvider<PreferenceProvider, Preference>(PreferenceProvider.new);