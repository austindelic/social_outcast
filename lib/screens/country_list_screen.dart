import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_outcast/providers/preference_provider.dart';
import 'package:social_outcast/screens/lesson_preferences_screen.dart';
import 'package:social_outcast/screens/map.dart';

// ─── COUNTRY CODE MAPPING ───────────────────────────────────────────────────

/// Map lower-cased country names (and common variants) to ISO codes:
const countryNameToCode = {
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

String getCountryCode(String? name) {
  if (name == null) return 'xx';
  final key = name.toLowerCase().trim();
  return countryNameToCode[key] ?? 'xx';
}

// ─── EMOJI CONVERSION ────────────────────────────────────────────────────────

/// Turn a 2-letter code (e.g. "us") into its regional-indicator emoji (🇺🇸).
String countryCodeToEmoji(String code) {
  if (code.length != 2) return '🏳️';
  final upper = code.toUpperCase();
  final base = 0x1F1E6 - 'A'.codeUnitAt(0);
  return String.fromCharCode(base + upper.codeUnitAt(0)) +
      String.fromCharCode(base + upper.codeUnitAt(1));
}

// ─── EMOJI-ONLY FLAG WIDGET ─────────────────────────────────────────────────

/// Pure-emoji flag, with fallback to two-letter code for broken platforms.
class CountryFlag extends StatelessWidget {
  final String code; // e.g. "us", "jp"
  final String name; // e.g. "United States", "Japan"
  const CountryFlag({super.key, required this.code, required this.name});

  static const fallbackCodes = {'us'};
  // Add any other codes here that your platform can't render

  @override
  Widget build(BuildContext context) {
    final lower = code.toLowerCase();
    final display = fallbackCodes.contains(lower)
        ? code.toUpperCase()
        : countryCodeToEmoji(lower);

    return CircleAvatar(
      radius: 19,
      backgroundColor: Colors.teal.shade50,
      child: Text(
        display,
        style: TextStyle(fontSize: display.length == 2 ? 18 : 24),
      ),
    );
  }
}

// ─── COUNTRY LIST SCREEN ────────────────────────────────────────────────────

class CountryListScreen extends ConsumerStatefulWidget {
  const CountryListScreen({super.key});

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends ConsumerState<CountryListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(preferenceProvider.notifier).loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final curriculums = ref.watch(preferenceProvider);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Your Curriculums'),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.pushNamed(context, LessonPreferencesScreen.routeName);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: curriculums == null
          ? const Center(child: CircularProgressIndicator())
          : curriculums.isEmpty
          ? const Center(
              child: Text(
                'No curriculums yet!\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              itemCount: curriculums.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final curriculum = curriculums[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MapScreen.routeName,
                      arguments: {'index': index, 'curriculum': curriculum},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.teal.shade100,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // FROM country flag
                        CountryFlag(
                          code: getCountryCode(curriculum.fromCountry),
                          name: curriculum.fromCountry ?? '?',
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.teal,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        // TO country flag
                        CountryFlag(
                          code: getCountryCode(curriculum.toCountry),
                          name: curriculum.toCountry ?? '?',
                        ),
                        const SizedBox(width: 22),
                        // Country names & purpose
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                curriculum.toCountry ?? '?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${curriculum.fromCountry ?? '?'}'
                                ' • ${curriculum.purpose ?? ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
