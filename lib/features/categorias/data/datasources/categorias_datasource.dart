import '../data.dart';

abstract class CategoriasDataSource {
  Future<List<CategoriaModel>> getAll();
  Future<CategoriaModel> getById(String id);
  Future<void> insert(CategoriaModel categoria);
  Future<void> update(CategoriaModel categoria);
  Future<void> delete(String id);
}
