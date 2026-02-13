part of 'productos_bloc.dart';

abstract class ProductosEvent {}

/// Si [preservarCategoriaId] no es null, tras cargar se mantiene ese filtro.
class CargarProductos extends ProductosEvent {
  final String? preservarCategoriaId;
  CargarProductos({this.preservarCategoriaId});
}

/// [categoriaId] null = todas las categorías
class FiltrarPorCategoria extends ProductosEvent {
  final String? categoriaId;
  FiltrarPorCategoria(this.categoriaId);
}

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
