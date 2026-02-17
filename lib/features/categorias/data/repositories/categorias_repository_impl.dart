import 'package:gestprod_app/features/categorias/data/data.dart';
import 'package:gestprod_app/features/categorias/domain/domain.dart';

class CategoriasRepositoryImpl implements CategoriasRepository {
  final CategoriasDataSource local;

  CategoriasRepositoryImpl(this.local);

  @override
  Future<void> actualizarCategoria(Categoria categoria) async {
    await local.update(
      CategoriaModel(
        id: categoria.id,
        nombre: categoria.nombre,
        activo: categoria.activo,
      ),
    );
  }

  @override
  Future<void> crearCategoria(Categoria categoria) async {
    await local.insert(
      CategoriaModel(
        id: categoria.id,
        nombre: categoria.nombre,
        activo: categoria.activo,
      ),
    );
  }

  @override
  Future<void> eliminarCategoria(String id) async {
    await local.delete(id);
  }

  @override
  Future<Categoria> obtenerCategoria(String id) async {
    final model = await local.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<Categoria>> obtenerCategorias() async {
    final models = await local.getAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
