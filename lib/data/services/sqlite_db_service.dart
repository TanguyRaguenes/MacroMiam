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
          'CREATE TABLE aliments(id INTEGER PRIMARY KEY AUTOINCREMENT, name Text, protein double, carbohydrates double, fat double, calories double )',
        );
      },
      version: 1,
    );
  }

  Future<void> insertAliment(AlimentModel aliment) async {
    final db = await getDatabase;
    print('insertAliment :');
    print(aliment.toString());
    db.insert('aliments', aliment.toMap());
  }

  Future<List<AlimentModel>> getAliments() async {
    final db = await getDatabase;
    final List<Map<String, dynamic>> maps = await db.query('aliments');
    return List.generate(maps.length, (i) {
      return AlimentModel.fromMap(maps[i]);
    });
  }
}
