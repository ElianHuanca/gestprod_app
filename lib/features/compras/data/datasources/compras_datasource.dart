import '../data.dart';

abstract class ComprasDataSource {
  Future<List<CompraModel>> getAllOrderByFechaDesc();
  Future<CompraModel?> getById(String id);
  Future<void> insert(CompraModel model);
  Future<void> update(CompraModel model);
  Future<void> delete(String id);
}
