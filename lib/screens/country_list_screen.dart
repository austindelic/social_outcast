import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_outcast/providers/preference_provider.dart';
import 'package:social_outcast/screens/lesson_preferences_screen.dart';
import 'package:social_outcast/screens/map.dart';
import 'package:social_outcast/utilities/database_helper.dart';

class CountryListScreen extends ConsumerStatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends ConsumerState<CountryListScreen> {
  List? curriculums = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurriculum();
    ref.read(preferenceProvider.notifier).loadPreferences();
    
  }

  Future<void> _fetchCurriculum() async {
    final data = await MyCurriculumDatabaseHelper().getAllData();
    setState(() {
      curriculums = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
     curriculums = ref.watch(preferenceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Country List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, LessonPreferencesScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (curriculums == null || curriculums!.isEmpty)
          ? Center(child: Text('Add new curriculum'))
          : ListView.builder(
              itemCount: curriculums!.length,
              itemBuilder: (context, index) {
                var curriculum = curriculums![index];
                return ListTile(
                  title: Text(curriculum.toCountry),
                  subtitle: Text(
                    "${curriculum.fromCountry} - ${curriculum.purpose}",
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MapScreen.routeName,
                      arguments: {
                        'index': index,
                        'curriculum': curriculum,
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
