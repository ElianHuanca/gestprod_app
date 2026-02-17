import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _dbName = 'gestprod.db';
  static const _dbVersion = 1;
  static const _backupAsset = 'assets/backup_sqlite.sql';

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

  /// Ejecuta el script SQL del backup (tablas textiles: categorias, colores,
  /// compras, productos, sucursales, ventas, inventario, etc.) con IDs en UUID.
  static Future<void> _runBackupScript(Database db) async {
    final String sqlContent =
        await rootBundle.loadString(_backupAsset);

    // Dividir por ; seguido de salto de línea (cada sentencia termina así)
    final statements = sqlContent
        .split(RegExp(r';\s*[\r\n]+'))
        .map((s) => s.trim())
        .where((s) {
      if (s.isEmpty) return false;
      // Quitar líneas que son solo comentarios al inicio
      final withoutCommentLines = s
          .split('\n')
          .where((line) =>
              line.trim().isNotEmpty && !line.trim().startsWith('--'))
          .join('\n')
          .trim();
      return withoutCommentLines.isNotEmpty;
    });

    final batch = db.batch();
    for (final stmt in statements) {
      // Quitar comentarios al inicio de la sentencia
      final lines = stmt.split('\n');
      final sql = lines
          .where((line) =>
              line.trim().isNotEmpty && !line.trim().startsWith('--'))
          .join('\n')
          .trim();
      if (sql.isEmpty) continue;
      batch.execute(sql);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _runBackupScript(db);
  }
}
