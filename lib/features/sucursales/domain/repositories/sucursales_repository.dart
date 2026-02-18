import '../domain.dart';

abstract class SucursalesRepository {
  Future<List<Sucursal>> obtenerSucursales();
  Future<Sucursal> obtenerSucursal(String id);
  Future<void> crearSucursal(Sucursal sucursal);
  Future<void> actualizarSucursal(Sucursal sucursal);
  Future<void> eliminarSucursal(String id);
}
