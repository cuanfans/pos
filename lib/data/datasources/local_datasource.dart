import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class LocalDataSource {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'pos_baru.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            price INTEGER, 
            stock INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertProduct(ProductModel product) async {
    final dbClient = await db;
    await dbClient.insert(
      'products', 
      product.toJson(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<ProductModel>> getProducts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('products');
    return maps.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> clearProducts() async {
    final dbClient = await db;
    await dbClient.delete('products');
  }
}
