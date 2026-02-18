part of 'tipos_gastos_bloc.dart';

abstract class TiposGastosEvent {}

class CargarTiposGastos extends TiposGastosEvent {}

class AgregarTipoGasto extends TiposGastosEvent {
  final TipoGasto tipoGasto;
  AgregarTipoGasto(this.tipoGasto);
}

class ActualizarTipoGasto extends TiposGastosEvent {
  final TipoGasto tipoGasto;
  ActualizarTipoGasto(this.tipoGasto);
}

class EliminarTipoGasto extends TiposGastosEvent {
  final String id;
  EliminarTipoGasto(this.id);
}
