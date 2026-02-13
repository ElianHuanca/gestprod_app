import 'package:gestprod_app/features/categorias/domain/domain.dart';

class GetCategorias {
  final CategoriasRepository repository;
  GetCategorias(this.repository);

  Future<List<Categoria>> call() {
    return repository.obtenerCategorias();
  }
}
