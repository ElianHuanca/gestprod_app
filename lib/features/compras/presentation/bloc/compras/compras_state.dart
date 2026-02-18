part of 'compras_bloc.dart';

abstract class ComprasState {}

class ComprasInitial extends ComprasState {}

class ComprasCargando extends ComprasState {}

class ComprasCargado extends ComprasState {
  final List<Compra> compras;
  /// Si es null se muestran todas; si no, solo las de esa sucursal.
  final String? sucursalIdFiltro;
  ComprasCargado(this.compras, [this.sucursalIdFiltro]);

  List<Compra> get comprasVisibles =>
      sucursalIdFiltro == null
          ? compras
          : compras.where((c) => c.sucursalId == sucursalIdFiltro).toList();
}

class ComprasError extends ComprasState {
  final String message;
  ComprasError(this.message);
}
