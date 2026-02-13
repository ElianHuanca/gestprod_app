import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'categorias_event.dart';
part 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  final CategoriasRepository repository;

  CategoriasBloc(this.repository) : super(CategoriasInitial()) {
    on<CargarCategorias>(_onLoadCategorias);
    on<AgregarCategoria>(_onAddCategoria);
    on<ActualizarCategoria>(_onUpdateCategoria);
    on<EliminarCategoria>(_onDeleteCategoria);
  }

  Future<void> _onLoadCategorias(
    CargarCategorias event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriasCargando());
    try {
      final categorias = await repository.obtenerCategorias();
      emit(CategoriasCargado(categorias));
    } catch (e) {
      emit(CategoriasError(e.toString()));
    }
  }

  Future<void> _onAddCategoria(
    AgregarCategoria event,
    Emitter<CategoriasState> emit,
  ) async {
    await repository.crearCategoria(event.categoria);
    add(CargarCategorias());
  }

  Future<void> _onUpdateCategoria(
    ActualizarCategoria event,
    Emitter<CategoriasState> emit,
  ) async {
    await repository.actualizarCategoria(event.categoria);
    add(CargarCategorias());
  }

  Future<void> _onDeleteCategoria(
    EliminarCategoria event,
    Emitter<CategoriasState> emit,
  ) async {
    await repository.eliminarCategoria(event.id);
    add(CargarCategorias());
  }
}
