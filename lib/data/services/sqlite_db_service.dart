import 'package:macromiam/data/models/aliment_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDbService {
  SqliteDbService._privateConstructor();

  static final _instance = SqliteDbService._privateConstructor();

  factory SqliteDbService() => _instance;

  static Database? _db;

  Future<Database> get getDatabase async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'macroMiam.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE aliments(id INTEGER PRIMARY KEY AUTOINCREMENT, name text, proteins double, carbohydrates double, fat double, calories double, imageSource String)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveAliment(AlimentModel aliment) async {
    final Database db = await getDatabase;
    print('insertAliment :');
    print(aliment.toString());
    db.insert('aliments', aliment.toMap());
  }

  Future<void> updateAliment(AlimentModel aliment) async {
    final Database db = await getDatabase;
    print('updateAliment :');
    print(aliment.toString());
    db.rawUpdate(
      'UPDATE aliments SET name=?, proteins=?,carbohydrates=?,fat=?,calories=?,imageSource=? WHERE id=?',
      [
        aliment.name,
        aliment.proteins,
        aliment.carbohydrates,
        aliment.fat,
        aliment.calories,
        aliment.imageSource,
        aliment.id,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getAliments() async {
    final Database db = await getDatabase;
    final List<Map<String, dynamic>> queryResult = await db.query('aliments');
    return queryResult;
  }

  Future<void> deleteAliment(int id) async {
    final Database db = await getDatabase;
    db.delete('aliments', where: 'id=?', whereArgs: [id]);
  }

  Future<bool> isPathUsed({required String path}) async {
    final Database db = await getDatabase;
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM aliments WHERE imageSource = ?',
      [path],
    );
    final count =
        queryResult.isNotEmpty ? queryResult.first['count'] as int? ?? 0 : 0;
    return count > 0;
  }
}
