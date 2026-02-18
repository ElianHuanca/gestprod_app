import '../data.dart';

abstract class TiposGastosDataSource {
  Future<List<TipoGastoModel>> getAll();
  Future<TipoGastoModel> getById(String id);
  Future<void> insert(TipoGastoModel tipoGasto);
  Future<void> update(TipoGastoModel tipoGasto);
  Future<void> delete(String id);
}
