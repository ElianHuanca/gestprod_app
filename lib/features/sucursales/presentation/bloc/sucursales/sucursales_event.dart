part of 'sucursales_bloc.dart';

abstract class SucursalesEvent {}

class CargarSucursales extends SucursalesEvent {}

class AgregarSucursal extends SucursalesEvent {
  final Sucursal sucursal;
  AgregarSucursal(this.sucursal);
}

class ActualizarSucursal extends SucursalesEvent {
  final Sucursal sucursal;
  ActualizarSucursal(this.sucursal);
}

class EliminarSucursal extends SucursalesEvent {
  final String id;
  EliminarSucursal(this.id);
}
