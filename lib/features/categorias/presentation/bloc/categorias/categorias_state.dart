part of 'categorias_bloc.dart';

abstract class CategoriasState {}

class CategoriasInitial extends CategoriasState {}

class CategoriasCargando extends CategoriasState {}

class CategoriasCargado extends CategoriasState {
  final List<Categoria> categorias;
  CategoriasCargado(this.categorias);
}

class CategoriasError extends CategoriasState {
  final String message;
  CategoriasError(this.message);
}
