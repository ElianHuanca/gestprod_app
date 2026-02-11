import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'productos_event.dart';
part 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  final ProductosRepository repository;

  ProductosBloc(this.repository) : super(ProductosInitial()) {
    on<CargarProductos>(_onLoadProductos);
    on<AgregarProducto>(_onAddProducto);
    on<ActualizarProducto>(_onUpdateProducto);
    on<EliminarProducto>(_onDeleteProducto);
  }

  Future<void> _onLoadProductos(
    CargarProductos event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosCargando());
    try {
      final productos = await repository.obtenerProductos();    
      emit(ProductosCargado(productos));
    } catch (e) {
      emit(ProductosError(e.toString()));
    }
  }

  Future<void> _onAddProducto(
    AgregarProducto event,
    Emitter<ProductosState> emit,
  ) async {
    await repository.crearProducto(event.producto);
    add(CargarProductos());
  }

  Future<void> _onUpdateProducto(
    ActualizarProducto event,
    Emitter<ProductosState> emit,
  ) async {
    await repository.actualizarProducto(event.producto);
    add(CargarProductos());
  }

  Future<void> _onDeleteProducto(
    EliminarProducto event,
    Emitter<ProductosState> emit,
  ) async {
    await repository.eliminarProducto(event.id);
    add(CargarProductos());
  }
}
