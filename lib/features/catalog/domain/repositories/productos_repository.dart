import '../domain.dart';

abstract class ProductosRepository {
  Future<List<Producto>> obtenerProductos();
  Future<Producto> obtenerProducto(String id);
  Future<void> crearProducto(Producto producto);
  Future<void> actualizarProducto(Producto producto);
  Future<void> eliminarProducto(String id);
}