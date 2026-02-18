import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'compras_event.dart';
part 'compras_state.dart';

class ComprasBloc extends Bloc<ComprasEvent, ComprasState> {
  final ComprasRepository repository;

  ComprasBloc(this.repository) : super(ComprasInitial()) {
    on<CargarCompras>(_onLoadCompras);
    on<FiltrarComprasPorSucursal>(_onFiltrarPorSucursal);
    on<AgregarCompra>(_onAgregarCompra);
    on<ActualizarCompra>(_onActualizarCompra);
    on<EliminarCompra>(_onEliminarCompra);
  }

  Future<void> _onLoadCompras(
    CargarCompras event,
    Emitter<ComprasState> emit,
  ) async {
    emit(ComprasCargando());
    try {
      final compras = await repository.obtenerCompras();
      emit(ComprasCargado(compras, null));
    } catch (e) {
      emit(ComprasError(e.toString()));
    }
  }

  void _onFiltrarPorSucursal(
    FiltrarComprasPorSucursal event,
    Emitter<ComprasState> emit,
  ) {
    final state = this.state;
    if (state is ComprasCargado) {
      emit(ComprasCargado(state.compras, event.sucursalId));
    }
  }

  Future<void> _onAgregarCompra(
    AgregarCompra event,
    Emitter<ComprasState> emit,
  ) async {
    try {
      await repository.crearCompra(event.compra);
      add(CargarCompras());
    } catch (e) {
      emit(ComprasError(e.toString()));
    }
  }

  Future<void> _onActualizarCompra(
    ActualizarCompra event,
    Emitter<ComprasState> emit,
  ) async {
    try {
      await repository.actualizarCompra(event.compra);
      add(CargarCompras());
    } catch (e) {
      emit(ComprasError(e.toString()));
    }
  }

  Future<void> _onEliminarCompra(
    EliminarCompra event,
    Emitter<ComprasState> emit,
  ) async {
    try {
      await repository.eliminarCompra(event.id);
      add(CargarCompras());
    } catch (e) {
      emit(ComprasError(e.toString()));
    }
  }
}
