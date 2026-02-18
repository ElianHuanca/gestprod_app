import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'sucursales_event.dart';
part 'sucursales_state.dart';

class SucursalesBloc extends Bloc<SucursalesEvent, SucursalesState> {
  final SucursalesRepository repository;

  SucursalesBloc(this.repository) : super(SucursalesInitial()) {
    on<CargarSucursales>(_onLoadSucursales);
    on<AgregarSucursal>(_onAgregarSucursal);
    on<ActualizarSucursal>(_onActualizarSucursal);
    on<EliminarSucursal>(_onEliminarSucursal);
  }

  Future<void> _onLoadSucursales(
    CargarSucursales event,
    Emitter<SucursalesState> emit,
  ) async {
    emit(SucursalesCargando());
    try {
      final sucursales = await repository.obtenerSucursales();
      emit(SucursalesCargado(sucursales));
    } catch (e) {
      emit(SucursalesError(e.toString()));
    }
  }

  Future<void> _onAgregarSucursal(
    AgregarSucursal event,
    Emitter<SucursalesState> emit,
  ) async {
    try {
      await repository.crearSucursal(event.sucursal);
      add(CargarSucursales());
    } catch (e) {
      emit(SucursalesError(e.toString()));
    }
  }

  Future<void> _onActualizarSucursal(
    ActualizarSucursal event,
    Emitter<SucursalesState> emit,
  ) async {
    try {
      await repository.actualizarSucursal(event.sucursal);
      add(CargarSucursales());
    } catch (e) {
      emit(SucursalesError(e.toString()));
    }
  }

  Future<void> _onEliminarSucursal(
    EliminarSucursal event,
    Emitter<SucursalesState> emit,
  ) async {
    try {
      await repository.eliminarSucursal(event.id);
      add(CargarSucursales());
    } catch (e) {
      emit(SucursalesError(e.toString()));
    }
  }
}
