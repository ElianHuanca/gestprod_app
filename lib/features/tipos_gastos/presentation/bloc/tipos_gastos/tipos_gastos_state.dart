part of 'tipos_gastos_bloc.dart';

abstract class TiposGastosState {}

class TiposGastosInitial extends TiposGastosState {}

class TiposGastosCargando extends TiposGastosState {}

class TiposGastosCargado extends TiposGastosState {
  final List<TipoGasto> tiposGastos;
  TiposGastosCargado(this.tiposGastos);
}

class TiposGastosError extends TiposGastosState {
  final String message;
  TiposGastosError(this.message);
}
