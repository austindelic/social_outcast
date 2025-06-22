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
          CREATE TABLE curriculum(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fromCountry TEXT,
            toCountry TEXT,
            purpose TEXT
            currentLevel integer DEFAULT 0,
          )
        ''');
      },
    );
    return db;
  }

  Future<void> insertData({
    required String fromCountry,
    required String toCountry,
    required String purpose,
  }) async {
    final Database? db = await database;
    final prevData = await getAllData();
    int index = prevData?.length ?? 0;

    Map<String, dynamic> data = {
      'id': index,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
      'purpose': purpose,
      'currentLevel': 0,
    };

    await db!.insert(
      'curriculum_table',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getData(int id) async {
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
  Future<int> getCurrentLevel(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'curriculum',
      columns: ['currentLevel'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first['currentLevel'] as int;
    }
    return 0; // Return 0 if no current level found
  }
  
  Future<void> updateCurrentLevel(int id, int currentLevel) async {
    final Database? db = await database;
    await db!.update(
      'curriculum',
      {'currentLevel': currentLevel},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<List<Map<String, dynamic>>?> getAllData() async {
    final Database? db = await database;
    final result = await db!.query('curriculum');
    return result;
  }

  Future<int> deleteData(int id) async {
    final Database? db = await database;
    return await db!.delete(
      'curriculum',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllData() async {
    final Database? db = await database;
    db!.delete('curriculum');
    db.execute('DROP TABLE curriculum');
  }
}
