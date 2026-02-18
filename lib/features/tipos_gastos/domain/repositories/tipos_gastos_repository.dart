import '../domain.dart';

abstract class TiposGastosRepository {
  Future<List<TipoGasto>> obtenerTiposGastos();
  Future<TipoGasto> obtenerTipoGasto(String id);
  Future<void> crearTipoGasto(TipoGasto tipoGasto);
  Future<void> actualizarTipoGasto(TipoGasto tipoGasto);
  Future<void> eliminarTipoGasto(String id);
}
