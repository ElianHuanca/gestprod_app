import '../domain.dart';

abstract class ComprasRepository {
  Future<List<Compra>> obtenerCompras();
  Future<Compra?> obtenerCompra(String id);
  Future<void> crearCompra(Compra compra);
  Future<void> actualizarCompra(Compra compra);
  Future<void> eliminarCompra(String id);
}
