import '../data.dart';

abstract class SucursalesDataSource {
  Future<List<SucursalModel>> getAll();
  Future<SucursalModel> getById(String id);
  Future<void> insert(SucursalModel model);
  Future<void> update(SucursalModel model);
  Future<void> delete(String id);
}
