import 'package:gestprod_app/features/tipos_gastos/domain/domain.dart';

class GetTiposGastos {
  final TiposGastosRepository repository;
  GetTiposGastos(this.repository);

  Future<List<TipoGasto>> call() {
    return repository.obtenerTiposGastos();
  }
}
