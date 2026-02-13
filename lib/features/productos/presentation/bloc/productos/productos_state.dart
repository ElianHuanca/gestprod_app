part of 'productos_bloc.dart';

abstract class ProductosState {}

class ProductosInitial extends ProductosState {}

class ProductosCargando extends ProductosState {}

class ProductosCargado extends ProductosState {
  final List<Producto> productos;
  final String? categoriaIdFilter;

  ProductosCargado(this.productos, [this.categoriaIdFilter]);

  List<Producto> get productosFiltrados =>
      categoriaIdFilter == null
          ? productos
          : productos.where((p) => p.categoriaId == categoriaIdFilter).toList();
}

class ProductosError extends ProductosState {
  final String message;
  ProductosError(this.message);
}
