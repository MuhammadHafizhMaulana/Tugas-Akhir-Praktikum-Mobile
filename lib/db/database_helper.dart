import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  // Mengakses database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 2, // Perbarui versi database
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Menambahkan fungsi onUpgrade
    );
  }

  // Membuat tabel users, favorites, dan history
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
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,  -- Menambahkan kolom quantity
        total_price REAL NOT NULL,           -- Menambahkan kolom total_price
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, 
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');
  }

  // Fungsi untuk menangani pembaruan database (update schema)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Menambahkan kolom quantity dan total_price jika belum ada
      await db.execute(''' 
        ALTER TABLE history ADD COLUMN quantity INTEGER NOT NULL DEFAULT 1
      ''');
      await db.execute(''' 
        ALTER TABLE history ADD COLUMN total_price REAL NOT NULL
      ''');
    }
  }

  // Insert user
  Future<int> insertUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Mengecek apakah user sudah ada berdasarkan email
  Future<bool> userExists(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty;
  }

  // Mendapatkan user berdasarkan email dan password
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Mendapatkan user berdasarkan email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update nama user berdasarkan email
  Future<int> updateUserName(String email, String newName) async {
    final db = await database;
    return await db.update(
      'users',
      {'name': newName},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Menambah riwayat pembayaran (user_id, product_id, quantity, total_price)
  Future<int> addPaymentHistory(int userId, int productId, int quantity, double totalPrice) async {
    final db = await database;
    return await db.insert('history', {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'total_price': totalPrice,
    });
  }

  // Mendapatkan riwayat pembayaran berdasarkan user_id
  Future<List<Map<String, dynamic>>> getPaymentHistory(int userId) async {
    final db = await database;
    final res = await db.query(
      'history',
      columns: ['product_id', 'quantity', 'total_price', 'created_at'], 
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return res;
  }
  // Menambah favorit (user_id dan product_id)
  Future<int> addFavorite(int userId, int productId) async {
    final db = await database;
    return await db.insert('favorites', {
      'user_id': userId,
      'product_id': productId,
    });
  }

  // Menghapus favorit berdasarkan user_id dan product_id
  Future<int> removeFavorite(int userId, int productId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  // Mengecek apakah produk sudah difavoritkan oleh user
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

  // Mendapatkan semua produk yang difavoritkan oleh user
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

  Future<void> deleteDatabaseIfExists() async {
    final path = join(await getDatabasesPath(), 'users.db');
    await deleteDatabase(path); // Menghapus database lama jika ada
  }
}
