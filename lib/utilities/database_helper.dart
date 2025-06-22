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
class TripDatabaseHelper {
  static final TripDatabaseHelper _instance = TripDatabaseHelper._internal();

  factory TripDatabaseHelper() {
    return _instance;
  }

  TripDatabaseHelper._internal();

  static Database? _database;
  Future<Database?> get database async {
    _database = await initTripDatabase();

    return _database;
  }

  Future<Database?> initTripDatabase() async {
    String path = join(await getDatabasesPath(), "trip_database.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE trip_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fromCountry TEXT,
            toCountry TEXT,
          )
        ''');
      },
    );
    return db;
  }

  Future<void> insertData(String fromCountry, String toCountry) async {
    final Database? db = await database;
    final prevData = await getAllData();
    int index = prevData?.length ?? 0;

    Map<String, dynamic> data = {
      'id': index,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
    };

    await db!.insert(
      'trip_table',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getData(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'trip_table',
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
    final result = await db!.query('trip_table');
    return result;
  }
}
class UnitDatabaseHelper {
  static final UnitDatabaseHelper _instance = UnitDatabaseHelper._internal();

  factory UnitDatabaseHelper() {
    return _instance;
  }

  UnitDatabaseHelper._internal();

  static Database? _database;
  Future<Database?> get database async {
    _database = await initUnitDatabase();

    return _database;
  }

  Future<Database?> initUnitDatabase() async {
    String path = join(await getDatabasesPath(), "unit_database.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE unit_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tripId INTEGER,
            genre TEXT,
          )
        ''');
      },
    );
    return db;
  }

  Future<void> insertData(String genre, int tripId) async {
    final Database? db = await database;
    final prevData = await getAllData();
    int index = prevData?.length ?? 0;

    Map<String, dynamic> data = {'id': index, 'tripId': tripId, 'genre': genre};

    await db!.insert(
      'unit_table',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getData(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'unit_table',
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
    final result = await db!.query('unit_table');
    return result;
  }
}
class LessonDatabaseHelper {
  static final LessonDatabaseHelper _instance =
      LessonDatabaseHelper._internal();

  factory LessonDatabaseHelper() {
    return _instance;
  }

  LessonDatabaseHelper._internal();

  static Database? _database;
  Future<Database?> get database async {
    _database = await initLessonDatabase();

    return _database;
  }

  Future<Database?> initLessonDatabase() async {
    String path = join(await getDatabasesPath(), "lesson_database.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE lesson_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            unitId INTEGER,
            subjectContext TEXT,
            title TEXT
          )
        ''');
      },
    );
    return db;
  }

  Future<void> insertData(
    int unitId,
    String subjectContext,
    String title,
  ) async {
    final Database? db = await database;
    final prevData = await getAllData();
    int index = prevData?.length ?? 0;

    Map<String, dynamic> data = {
      'id': index,
      'unitId': unitId,
      'subjectContext': subjectContext,
      'title': title,
    };

    await db!.insert(
      'lesson_table',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getData(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'lesson_table',
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
    final result = await db!.query('lesson_table');
    return result;
  }
}

class PuzzleDatabaseHelper {
  static final PuzzleDatabaseHelper _instance =
      PuzzleDatabaseHelper._internal();

  factory PuzzleDatabaseHelper() {
    return _instance;
  }

  PuzzleDatabaseHelper._internal();

  static Database? _database;
  Future<Database?> get database async {
    _database = await initPuzzleDatabase();

    return _database;
  }

  Future<Database?> initPuzzleDatabase() async {
    String path = join(await getDatabasesPath(), "puzzle_database.db");
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE puzzle_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            lessonId INTEGER,
            prompt TEXT,
            option1 TEXT,
            option2 TEXT,
            option3 TEXT,
            option4 TEXT,
            correctIndex INTEGER
          )
        ''');
      },
    );
    return db;
  }

  Future<void> insertData(
    int lessonId,
    String prompt,
    String option1,
    String option2,
    String option3,
    String option4,
    int correctIndex,
  ) async {
    final Database? db = await database;
    final prevData = await getAllData();
    int index = prevData?.length ?? 0;

    Map<String, dynamic> data = {
      'id': index,
      'lessonId': lessonId,
      'prompt': prompt,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'correctIndex': correctIndex,
    };

    await db!.insert(
      'puzzle_table',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getData(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query(
      'puzzle_table',
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
    final result = await db!.query('puzzle_table');
    return result;
  }
}
