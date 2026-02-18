part of 'sucursales_bloc.dart';

abstract class SucursalesState {}

class SucursalesInitial extends SucursalesState {}

class SucursalesCargando extends SucursalesState {}

class SucursalesCargado extends SucursalesState {
  final List<Sucursal> sucursales;
  SucursalesCargado(this.sucursales);
}

class SucursalesError extends SucursalesState {
  final String message;
  SucursalesError(this.message);
}
