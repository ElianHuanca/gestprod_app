import 'package:gestprod_app/features/tipos_gastos/data/data.dart';
import 'package:gestprod_app/features/tipos_gastos/domain/domain.dart';

class TiposGastosRepositoryImpl implements TiposGastosRepository {
  final TiposGastosDataSource local;

  TiposGastosRepositoryImpl(this.local);

  @override
  Future<void> actualizarTipoGasto(TipoGasto tipoGasto) async {
    await local.update(
      TipoGastoModel(
        id: tipoGasto.id,
        nombre: tipoGasto.nombre,
        activo: tipoGasto.activo,
      ),
    );
  }

  @override
  Future<void> crearTipoGasto(TipoGasto tipoGasto) async {
    await local.insert(
      TipoGastoModel(
        id: tipoGasto.id,
        nombre: tipoGasto.nombre,
        activo: tipoGasto.activo,
      ),
    );
  }

  @override
  Future<void> eliminarTipoGasto(String id) async {
    await local.delete(id);
  }

  @override
  Future<TipoGasto> obtenerTipoGasto(String id) async {
    final model = await local.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<TipoGasto>> obtenerTiposGastos() async {
    final models = await local.getAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
