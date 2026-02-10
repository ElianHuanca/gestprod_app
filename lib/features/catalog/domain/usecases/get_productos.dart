import 'package:gestprod_app/features/catalog/domain/domain.dart';

class GetProducts {
  final ProductosRepository repository;
  GetProducts(this.repository);

  Future<List<Producto>> call() {
    return repository.obtenerProductos();
  }
}
