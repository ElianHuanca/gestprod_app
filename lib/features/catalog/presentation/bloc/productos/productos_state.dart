part of 'productos_bloc.dart';

abstract class ProductosState {}

class ProductosInitial extends ProductosState {}

class ProductosCargando extends ProductosState {}

class ProductosCargado extends ProductosState {
  final List<Producto> productos;
  ProductosCargado(this.productos);
}

class ProductosError extends ProductosState {
  final String message;
  ProductosError(this.message);
}
