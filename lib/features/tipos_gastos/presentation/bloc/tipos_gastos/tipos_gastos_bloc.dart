import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'tipos_gastos_event.dart';
part 'tipos_gastos_state.dart';

class TiposGastosBloc extends Bloc<TiposGastosEvent, TiposGastosState> {
  final TiposGastosRepository repository;

  TiposGastosBloc(this.repository) : super(TiposGastosInitial()) {
    on<CargarTiposGastos>(_onLoadTiposGastos);
    on<AgregarTipoGasto>(_onAddTipoGasto);
    on<ActualizarTipoGasto>(_onUpdateTipoGasto);
    on<EliminarTipoGasto>(_onDeleteTipoGasto);
  }

  Future<void> _onLoadTiposGastos(
    CargarTiposGastos event,
    Emitter<TiposGastosState> emit,
  ) async {
    emit(TiposGastosCargando());
    try {
      final tiposGastos = await repository.obtenerTiposGastos();
      emit(TiposGastosCargado(tiposGastos));
    } catch (e) {
      emit(TiposGastosError(e.toString()));
    }
  }

  Future<void> _onAddTipoGasto(
    AgregarTipoGasto event,
    Emitter<TiposGastosState> emit,
  ) async {
    await repository.crearTipoGasto(event.tipoGasto);
    add(CargarTiposGastos());
  }

  Future<void> _onUpdateTipoGasto(
    ActualizarTipoGasto event,
    Emitter<TiposGastosState> emit,
  ) async {
    await repository.actualizarTipoGasto(event.tipoGasto);
    add(CargarTiposGastos());
  }

  Future<void> _onDeleteTipoGasto(
    EliminarTipoGasto event,
    Emitter<TiposGastosState> emit,
  ) async {
    await repository.eliminarTipoGasto(event.id);
    add(CargarTiposGastos());
  }
}
