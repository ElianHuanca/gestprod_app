import 'package:sqflite/sqflite.dart';

import '../data.dart';

class TiposGastosDatasourceImpl implements TiposGastosDataSource {
  final Database db;

  TiposGastosDatasourceImpl(this.db);

  @override
  Future<List<TipoGastoModel>> getAll() async {
    final result = await db.query(
      'tipos_gastos',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return result.map(TipoGastoModel.fromMap).toList();
  }

  @override
  Future<TipoGastoModel> getById(String id) async {
    final result = await db.query(
      'tipos_gastos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      throw Exception('Tipo de gasto no encontrado');
    }
    return TipoGastoModel.fromMap(result.first);
  }

  @override
  Future<void> insert(TipoGastoModel tipoGasto) async {
    await db.insert(
      'tipos_gastos',
      tipoGasto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(TipoGastoModel tipoGasto) async {
    await db.update(
      'tipos_gastos',
      tipoGasto.toMap(),
      where: 'id = ?',
      whereArgs: [tipoGasto.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await db.update(
      'tipos_gastos',
      {'activo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
