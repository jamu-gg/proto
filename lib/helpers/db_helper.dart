import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Membuka atau membuat database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('toko_digital.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Naikkan versi menjadi 2 untuk update skema
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE master_products ADD COLUMN image_path TEXT');
      await db.execute('ALTER TABLE local_cart ADD COLUMN image_path TEXT');
    }
  }

  // Membuat tabel dan mengisi data awal (seed data)
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullType = 'TEXT';
    const realType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Tabel master_products
    await db.execute('''
      CREATE TABLE master_products (
        id $idType,
        name $textType,
        price $realType,
        image_path $textNullType
      )
    ''');

    // Tabel local_cart
    await db.execute('''
      CREATE TABLE local_cart (
        id $idType,
        product_id $integerType,
        name $textType,
        price $realType,
        quantity $integerType,
        image_path $textNullType
      )
    ''');

    // Seed Data
    List<ProductModel> initialProducts = [
      ProductModel(name: 'Kopi Susu Gula Aren', price: 15000),
      ProductModel(name: 'Roti Bakar Coklat', price: 12000),
      ProductModel(name: 'Es Teh Manis', price: 5000),
      ProductModel(name: 'Mie Goreng Spesial', price: 20000),
      ProductModel(name: 'Kentang Goreng', price: 10000),
    ];

    for (var product in initialProducts) {
      await db.insert('master_products', product.toMap());
    }
  }

  // === Fungsi CRUD untuk Master Products ===
  Future<int> insertProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.insert('master_products', product.toMap());
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.update(
      'master_products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    // Hapus juga produk tersebut di keranjang
    await db.delete('local_cart', where: 'product_id = ?', whereArgs: [id]);
    return await db.delete(
      'master_products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    final db = await instance.database;
    final result = await db.query('master_products');
    return result.map((json) => ProductModel.fromMap(json)).toList();
  }

  // === Fungsi CRUD untuk Cart ===
  Future<List<CartModel>> fetchCartItems() async {
    final db = await instance.database;
    final result = await db.query('local_cart');
    return result.map((json) => CartModel.fromMap(json)).toList();
  }

  // Mencari apakah produk sudah ada di keranjang
  Future<CartModel?> getCartItemByProductId(int productId) async {
    final db = await instance.database;
    final maps = await db.query(
      'local_cart',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    if (maps.isNotEmpty) {
      return CartModel.fromMap(maps.first);
    }
    return null;
  }

  // Menambahkan item baru ke keranjang
  Future<int> insertCartItem(CartModel cartItem) async {
    final db = await instance.database;
    return await db.insert('local_cart', cartItem.toMap());
  }

  // Mengupdate kuantitas item di keranjang
  Future<int> updateCartItem(CartModel cartItem) async {
    final db = await instance.database;
    return await db.update(
      'local_cart',
      cartItem.toMap(),
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );
  }

  // Menghapus item dari keranjang (ketika quantity 0)
  Future<int> deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'local_cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menghapus seluruh item di keranjang (untuk proses Checkout)
  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('local_cart');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
