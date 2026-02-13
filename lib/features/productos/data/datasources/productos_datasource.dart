import '../data.dart';

abstract class ProductosDataSource {
  Future<List<ProductoModel>> getAll();
  Future<ProductoModel> getById(String id);
  Future<void> insert(ProductoModel product);
  Future<void> update(ProductoModel product);
  Future<void> delete(String id);
}
