part of 'categorias_bloc.dart';

abstract class CategoriasEvent {}

class CargarCategorias extends CategoriasEvent {}

class AgregarCategoria extends CategoriasEvent {
  final Categoria categoria;
  AgregarCategoria(this.categoria);
}

class ActualizarCategoria extends CategoriasEvent {
  final Categoria categoria;
  ActualizarCategoria(this.categoria);
}

class EliminarCategoria extends CategoriasEvent {
  final String id;
  EliminarCategoria(this.id);
}
