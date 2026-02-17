import 'package:sqflite/sqflite.dart';

import '../data.dart';

class CategoriasDatasourceImpl implements CategoriasDataSource {
  final Database db;

  CategoriasDatasourceImpl(this.db);

  @override
  Future<List<CategoriaModel>> getAll() async {
    final result = await db.query(
      'categorias',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return result.map(CategoriaModel.fromMap).toList();
  }

  @override
  Future<CategoriaModel> getById(String id) async {
    final result = await db.query(
      'categorias',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      throw Exception('Categoría no encontrada');
    }
    return CategoriaModel.fromMap(result.first);
  }

  @override
  Future<void> insert(CategoriaModel categoria) async {
    await db.insert(
      'categorias',
      categoria.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(CategoriaModel categoria) async {
    await db.update(
      'categorias',
      categoria.toMap(),
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await db.update(
      'categorias',
      {'activo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
