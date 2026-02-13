import 'package:gestprod_app/features/productos/domain/domain.dart';

class GetProducts {
  final ProductosRepository repository;
  GetProducts(this.repository);

  Future<List<Producto>> call() {
    return repository.obtenerProductos();
  }
}
