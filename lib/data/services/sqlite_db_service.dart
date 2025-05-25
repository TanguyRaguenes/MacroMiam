import 'package:macromiam/data/models/aliment_model.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/models/enums_model.dart';
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
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE aliments(id INTEGER PRIMARY KEY AUTOINCREMENT, name text, proteins double, carbohydrates double, fat double, calories double, imageSource String);',
        );
        await db.execute(
          'CREATE TABLE consumptions(id INTEGER PRIMARY KEY AUTOINCREMENT, alimentId integer, quantityInGrams double, mealType String, dayOfWeek String);',
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

  Future<void> saveConsumption(ConsumptionModel consumption) async {
    final Database db = await getDatabase;
    print('insertConsumption :');
    print(consumption.toString());
    db.insert('consumptions', consumption.toMap());
  }

  Future<void> updateAliment({required AlimentModel aliment}) async {
    final Database db = await getDatabase;
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

  Future<void> updateConsumption({
    required ConsumptionModel consumption,
  }) async {
    final Database db = await getDatabase;
    db.rawUpdate(
      'UPDATE consumptions SET alimentId=?, quantityInGrams=?,mealType=?,dayOfWeek=? WHERE id=?;',
      [
        consumption.aliment!.id,
        consumption.quantityInGrams,
        consumption.mealType.label,
        consumption.dayOfWeek.label,
        consumption.id,
      ],
    );
  }

  //'CREATE TABLE consumptions(id INTEGER PRIMARY KEY AUTOINCREMENT, alimentId integer, quantityInGrams double, mealType String, dayOfWeek String);',

  Future<List<Map<String, dynamic>>> getAliments() async {
    final Database db = await getDatabase;
    final List<Map<String, dynamic>> queryResult = await db.query('aliments');
    return queryResult;
  }

  Future<List<Map<String, dynamic>>> getConsumptions() async {
    final Database db = await getDatabase;
    final List<Map<String, dynamic>> queryResult = await db.query(
      'consumptions',
    );
    return queryResult;
  }

  Future<Map<String, dynamic>?> getAlimentById({required int id}) async {
    final Database db = await getDatabase;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM aliments WHERE id=?',
      [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getConsumptionById({required int id}) async {
    final Database db = await getDatabase;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM consumptions WHERE id=?',
      [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> deleteAliment(int id) async {
    final Database db = await getDatabase;
    db.rawDelete('DELETE FROM aliments WHERE id=?', [id]);
  }

  Future<void> deleteConsumption({required int id}) async {
    final Database db = await getDatabase;
    db.rawDelete('DELETE FROM consumptions WHERE id=?', [id]);
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
