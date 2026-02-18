import 'package:gestprod_app/features/sucursales/data/data.dart';
import 'package:gestprod_app/features/sucursales/domain/domain.dart';

class SucursalesRepositoryImpl implements SucursalesRepository {
  final SucursalesDataSource local;

  SucursalesRepositoryImpl(this.local);

  @override
  Future<List<Sucursal>> obtenerSucursales() async {
    final models = await local.getAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Sucursal> obtenerSucursal(String id) async {
    final model = await local.getById(id);
    return model.toEntity();
  }

  @override
  Future<void> crearSucursal(Sucursal sucursal) async {
    await local.insert(SucursalModel.fromEntity(sucursal));
  }

  @override
  Future<void> actualizarSucursal(Sucursal sucursal) async {
    await local.update(SucursalModel.fromEntity(sucursal));
  }

  @override
  Future<void> eliminarSucursal(String id) async {
    await local.delete(id);
  }
}
