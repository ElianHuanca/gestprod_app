part of 'productos_bloc.dart';

abstract class ProductosEvent {}

class CargarProductos extends ProductosEvent {}

class AgregarProducto extends ProductosEvent {
  final Producto producto;
  AgregarProducto(this.producto);
}

class ActualizarProducto extends ProductosEvent {
  final Producto producto;
  ActualizarProducto(this.producto);
}

class EliminarProducto extends ProductosEvent {
  final String id;
  EliminarProducto(this.id);
}
