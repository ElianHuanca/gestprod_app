import 'package:sqflite/sqflite.dart';

import '../data.dart';

class ComprasDatasourceImpl implements ComprasDataSource {
  final Database db;

  ComprasDatasourceImpl(this.db);

  @override
  Future<List<CompraModel>> getAllOrderByFechaDesc() async {
    final result = await db.query(
      'compras',
      orderBy: 'fecha DESC',
    );
    return result.map(CompraModel.fromMap).toList();
  }

  @override
  Future<CompraModel?> getById(String id) async {
    final result = await db.query(
      'compras',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return CompraModel.fromMap(result.first);
  }

  @override
  Future<void> insert(CompraModel model) async {
    await db.insert('compras', model.toMap());
  }

  @override
  Future<void> update(CompraModel model) async {
    await db.update(
      'compras',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await db.delete(
      'compras',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
