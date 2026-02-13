import '../domain.dart';

abstract class CategoriasRepository {
  Future<List<Categoria>> obtenerCategorias();
  Future<Categoria> obtenerCategoria(String id);
  Future<void> crearCategoria(Categoria categoria);
  Future<void> actualizarCategoria(Categoria categoria);
  Future<void> eliminarCategoria(String id);
}
