import 'package:gestprod_app/features/compras/data/data.dart';
import 'package:gestprod_app/features/compras/domain/domain.dart';

class ComprasRepositoryImpl implements ComprasRepository {
  final ComprasDataSource local;

  ComprasRepositoryImpl(this.local);

  @override
  Future<List<Compra>> obtenerCompras() async {
    final models = await local.getAllOrderByFechaDesc();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Compra?> obtenerCompra(String id) async {
    final model = await local.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> crearCompra(Compra compra) async {
    await local.insert(CompraModel.fromEntity(compra));
  }

  @override
  Future<void> actualizarCompra(Compra compra) async {
    await local.update(CompraModel.fromEntity(compra));
  }

  @override
  Future<void> eliminarCompra(String id) async {
    await local.delete(id);
  }
}
