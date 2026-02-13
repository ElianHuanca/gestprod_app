import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _dbName = 'gestprod.db';
  static const _dbVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categorias (
        id TEXT PRIMARY KEY,
        categoria TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS productos (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        precio REAL NOT NULL,
        image_url TEXT,
        categoria_id TEXT NOT NULL,
        FOREIGN KEY (categoria_id) REFERENCES categorias(id)
      );
    ''');
    await db.insert('categorias', {'id': '1', 'categoria': 'Auriculares'});
    await db.insert('categorias', {'id': '2', 'categoria': 'Audífonos'});
    await db.insert('categorias', {'id': '3', 'categoria': 'Cargadores'});

    await db.insert('productos', {
      'id': '1',
      'nombre': 'REDMI Buds 8 Lite',
      'precio': 23,
      'image_url':
          'https://i05.appmifile.com/884_item_es/23/12/2025/c7c628d92903085367d0ff5e241c9c10.png',
      'categoria_id': '1',
    });

    await db.insert('productos', {
      'id': '2',
      'nombre': 'REDMI Buds 5 PRO',
      'precio': 180,
      'image_url':
          'https://i05.appmifile.com/377_item_es/26/02/2025/c18730ec0c6163f0ae30099837282a4c.png',
      'categoria_id': '1',
    });

    await db.insert('productos', {
      'id': '3',
      'nombre': 'REDMI Buds 6 PRO',
      'precio': 60,
      'image_url':
          'https://i05.appmifile.com/574_item_es/10/01/2025/895fb8e8079dc373a8931fcbd1521e8e.png',
      'categoria_id': '1',
    });
  }
}
