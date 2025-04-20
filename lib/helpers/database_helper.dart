import 'package:macromiam/models/custom_aliment_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  DataBaseHelper._privateConstructor();

  static final _dataBaseHelperInstance = DataBaseHelper._privateConstructor();

  factory DataBaseHelper() => _dataBaseHelperInstance;

  static Database? _database;

  Future<Database> get getDatabase async {
    _database ??= await _initDatabase();
    return _database!;
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

  Future<void> insertAliment(CustomAlimentModel aliment) async {
    final db = await getDatabase;
    print('insertAliment :');
    print(aliment.toString());
    db.insert('aliments', aliment.toMap());
  }

  Future<List<CustomAlimentModel>> getAliments() async {
    final db = await getDatabase;
    final List<Map<String, dynamic>> maps = await db.query('aliments');
    return List.generate(maps.length, (i) {
      return CustomAlimentModel.fromMap(maps[i]);
    });
  }
}
