import 'package:bloc/bloc.dart';
import 'package:gestprod_app/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class RouterCubit extends Cubit<GoRouter> {
  RouterCubit() : super(publicRoutes);

  void goBack() => state.pop();
  void goHome() => state.go('/');
  void goProductos() => state.go('/productos');
  void goCategorias() => state.go('/categorias');
  void goProducto(String id) => state.push('/producto/$id');
}