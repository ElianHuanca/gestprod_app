import 'package:gestprod_app/features/productos/data/data.dart';
import 'package:gestprod_app/features/productos/domain/domain.dart';

class ProductosRepositoryImpl implements ProductosRepository {
  final ProductosDataSource local;

  ProductosRepositoryImpl(this.local);

  @override
  Future<void> actualizarProducto(Producto producto) async {
    await local.update(
      ProductoModel(
        id: producto.id,
        nombre: producto.nombre,
        precio: producto.precio,
        imageUrl: producto.imageUrl,
        categoriaId: producto.categoriaId,
      ),
    );
  }

  @override
  Future<void> crearProducto(Producto producto) async {
    await local.insert(
      ProductoModel(
        id: producto.id,
        nombre: producto.nombre,
        precio: producto.precio,
        imageUrl: producto.imageUrl,
        categoriaId: producto.categoriaId,
      ),
    );
  }

  @override
  Future<void> eliminarProducto(String id) async {
    await local.delete(id);
  }

  @override
  Future<Producto> obtenerProducto(String id) async {
    final model = await local.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<Producto>> obtenerProductos() async {
    final models = await local.getAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
