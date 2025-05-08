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
          'CREATE TABLE aliments(id INTEGER PRIMARY KEY AUTOINCREMENT, name text, proteins double, carbohydrates double, fat double, calories double, pathOrUrl String)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveAliment(AlimentModel aliment) async {
    final db = await getDatabase;
    print('insertAliment :');
    print(aliment.toString());
    db.insert('aliments', aliment.toMap());
  }

  Future<void> updateAliment(AlimentModel aliment) async {
    final db = await getDatabase;
    print('updateAliment :');
    print(aliment.toString());
    db.rawUpdate(
      'UPDATE aliments SET name=?, proteins=?,carbohydrates=?,fat=?,calories=?,pathOrUrl=? WHERE id=?',
      [
        aliment.name,
        aliment.proteins,
        aliment.carbohydrates,
        aliment.fat,
        aliment.calories,
        aliment.pathOrUrl,
        aliment.id,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> getAliments() async {
    final db = await getDatabase;
    final List<Map<String, dynamic>> maps = await db.query('aliments');
    return maps;
  }

  Future<void> deleteAliment(int id) async {
    final db = await getDatabase;
    db.delete('aliments', where: 'id=?', whereArgs: [id]);
  }

  Future<bool> isPathUsed({required String path}) async {
    final db = await getDatabase;
    final result = await db.rawQuery(
      'SELECT 1 FROM aliments WHERE pathOrUrl = ? LIMIT 1',
      [path],
    );
    return result.isNotEmpty;
  }
}
