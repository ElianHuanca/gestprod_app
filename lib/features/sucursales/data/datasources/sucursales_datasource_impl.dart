import 'package:sqflite/sqflite.dart';

import '../data.dart';

class SucursalesDatasourceImpl implements SucursalesDataSource {
  final Database db;

  SucursalesDatasourceImpl(this.db);

  @override
  Future<List<SucursalModel>> getAll() async {
    final result = await db.query(
      'sucursales',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return result.map(SucursalModel.fromMap).toList();
  }

  @override
  Future<SucursalModel> getById(String id) async {
    final result = await db.query(
      'sucursales',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) throw Exception('Sucursal no encontrada');
    return SucursalModel.fromMap(result.first);
  }

  @override
  Future<void> insert(SucursalModel model) async {
    await db.insert(
      'sucursales',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(SucursalModel model) async {
    await db.update(
      'sucursales',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await db.update(
      'sucursales',
      {'activo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
