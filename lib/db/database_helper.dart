import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 3,  // Naikkan versi jika skema baru dibuat
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        title TEXT,
        price REAL,
        description TEXT,
        category TEXT,
        imageUrl TEXT,
        rating REAL,
        ratingCount INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Versi 2: buat tabel favorites
      await db.execute('''
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 3) {
      // Versi 3: buat tabel products
      await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY,
          title TEXT,
          price REAL,
          description TEXT,
          category TEXT,
          imageUrl TEXT,
          rating REAL,
          ratingCount INTEGER
        )
      ''');
    }
  }

  // CRUD Users

  Future<int> insertUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<bool> userExists(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUserName(String email, String newName) async {
    final db = await database;
    return await db.update(
      'users',
      {'name': newName},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // CRUD Products

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert(
      'products',
      product,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getProductById(int productId) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // CRUD Favorites

  Future<int> addFavorite(int userId, int productId) async {
    final db = await database;
    return await db.insert('favorites', {
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<int> removeFavorite(int userId, int productId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<bool> isFavorited(int userId, int productId) async {
    final db = await database;
    final res = await db.query(
      'favorites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<List<int>> getFavoriteProductIdsByUser(int userId) async {
    final db = await database;
    final res = await db.query(
      'favorites',
      columns: ['product_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return res.map<int>((row) => row['product_id'] as int).toList();
  }
}
