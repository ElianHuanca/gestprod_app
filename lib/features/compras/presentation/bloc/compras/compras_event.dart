part of 'compras_bloc.dart';

abstract class ComprasEvent {}

class CargarCompras extends ComprasEvent {}

class AgregarCompra extends ComprasEvent {
  final Compra compra;
  AgregarCompra(this.compra);
}

class ActualizarCompra extends ComprasEvent {
  final Compra compra;
  ActualizarCompra(this.compra);
}

class EliminarCompra extends ComprasEvent {
  final String id;
  EliminarCompra(this.id);
}

class FiltrarComprasPorSucursal extends ComprasEvent {
  /// null = todas las sucursales
  final String? sucursalId;
  FiltrarComprasPorSucursal(this.sucursalId);
}
