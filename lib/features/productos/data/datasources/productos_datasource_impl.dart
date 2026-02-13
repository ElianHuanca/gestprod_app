import 'package:sqflite/sqflite.dart';

import '../data.dart';

class ProductosDatasourceImpl implements ProductosDataSource {
  final Database db; 

  ProductosDatasourceImpl (this.db);

  @override
  Future<List<ProductoModel>> getAll() async {
    final result = await db.query('productos');
    return result.map(ProductoModel.fromMap).toList();
  }

  @override
  Future<ProductoModel> getById(String id) async {
    final result = await db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      throw Exception('Producto no encontrado');
    }
    return ProductoModel.fromMap(result.first);
  }

  @override
  Future<void> insert(ProductoModel producto) async {
    await db.insert(
      'productos',
      producto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(ProductoModel producto) async {
    await db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }
}
