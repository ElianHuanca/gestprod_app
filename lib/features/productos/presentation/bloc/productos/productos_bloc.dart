import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'productos_event.dart';
part 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  final ProductosRepository repository;

  ProductosBloc(this.repository) : super(ProductosInitial()) {
    on<CargarProductos>(_onLoadProductos);
    on<FiltrarPorCategoria>(_onFiltrarPorCategoria);
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
      emit(ProductosCargado(productos, event.preservarCategoriaId));
    } catch (e) {
      emit(ProductosError(e.toString()));
    }
  }

  void _onFiltrarPorCategoria(
    FiltrarPorCategoria event,
    Emitter<ProductosState> emit,
  ) {
    final state = this.state;
    if (state is ProductosCargado) {
      emit(ProductosCargado(state.productos, event.categoriaId));
    }
  }

  Future<void> _onAddProducto(
    AgregarProducto event,
    Emitter<ProductosState> emit,
  ) async {
    await repository.crearProducto(event.producto);
    final current = state;
    final filter = current is ProductosCargado ? current.categoriaIdFilter : null;
    add(CargarProductos(preservarCategoriaId: filter));
  }

  Future<void> _onUpdateProducto(
    ActualizarProducto event,
    Emitter<ProductosState> emit,
  ) async {
    await repository.actualizarProducto(event.producto);
    final current = state;
    final filter = current is ProductosCargado ? current.categoriaIdFilter : null;
    add(CargarProductos(preservarCategoriaId: filter));
  }

  Future<void> _onDeleteProducto(
    EliminarProducto event,
    Emitter<ProductosState> emit,
  ) async {
    await repository.eliminarProducto(event.id);
    final current = state;
    final filter = current is ProductosCargado ? current.categoriaIdFilter : null;
    add(CargarProductos(preservarCategoriaId: filter));
  }
}
