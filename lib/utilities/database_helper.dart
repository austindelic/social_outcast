import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyCurriculumDatabaseHelper {
  static final MyCurriculumDatabaseHelper _instance =
      MyCurriculumDatabaseHelper._internal();

  factory MyCurriculumDatabaseHelper() {
    return _instance;
  }

  MyCurriculumDatabaseHelper._internal();

  static Database? _database;
  Future<Database?> get database async {
    _database = await initMyLocationDatabase();

    return _database;
  }

  Future<Database?> initMyLocationDatabase() async {
    String path = join(await getDatabasesPath(), "my_preferences_database.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE curriculum_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fromCountry TEXT,
            toCountry TEXT,
            purpose TEXT
          )
        ''');
      },
    );
    return db;
  }

  Future<void> insertData(
    String userName,
    String fromCountry,
    String toCountry,
    String purpose,
  ) async {
    final Database? db = await database;
    final prevData = await getAllData();
    int index = prevData?.length ?? 0;

    Map<String, dynamic> data = {
      'id': index,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
      'purpose': purpose,
    };

    await db!.insert(
      'my_curriculum_table',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getData(
    int id,
  ) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'curriculum_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAllData() async {
    final Database? db = await database;
    final result = await db!.query('my_curriculum_table');
    return result;
  }

  Future<int> deleteData(String fromCountry, String purpose) async {
    final Database? db = await database;
    return await db!.delete(
      'my_curriculum_table',
      where: 'fromCountry = ? AND purpose = ?',
      whereArgs: [fromCountry, purpose],
    );
  }

  Future<void> deleteAllData() async {
    final Database? db = await database;
    db!.delete('my_curriculum_table');
    db.execute('DROP TABLE my_curriculum_table');
  }
}
