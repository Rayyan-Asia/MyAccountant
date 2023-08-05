// database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  late Database _database;

  DatabaseHelper._internal() {
    initDatabase(); // Initialize the database in the constructor
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    throw Exception("Database not initialized"); // Add an error if the database is accessed before initialization
  }

  Future<void> initDatabase() async {
    final path = join(await getDatabasesPath(), 'expense_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category INTEGER NOT NULL,
            amount REAL NOT NULL,
            description TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert('expenses', expense.toMap(excludeId: true));
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final maps = await db.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }
}
