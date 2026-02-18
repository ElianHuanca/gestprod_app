import 'package:gestprod_app/features/categorias/presentation/pages/pages.dart';
import 'package:gestprod_app/features/compras/presentation/pages/pages.dart';
import 'package:gestprod_app/features/productos/presentation/pages/pages.dart';
import 'package:gestprod_app/features/sucursales/presentation/pages/pages.dart';
import 'package:gestprod_app/features/tipos_gastos/presentation/pages/pages.dart';
import 'package:go_router/go_router.dart';

final publicRoutes = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProductosPage()),
    GoRoute(
      path: '/productos',
      builder: (context, state) => const ProductosPage(),
    ),
    GoRoute(
      path: '/producto/:id',
      builder: (context, state) =>
          ProductoPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/categorias',
      builder: (context, state) => const CategoriasPage(),
    ),
    GoRoute(
      path: '/categoria/:id',
      builder: (context, state) =>
          CategoriaPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/tipos-gastos',
      builder: (context, state) => const TiposGastosPage(),
    ),
    GoRoute(
      path: '/compras',
      builder: (context, state) => const ComprasPage(),
    ),
    GoRoute(
      path: '/compra/:id',
      builder: (context, state) =>
          CompraPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/tipo-gasto/:id',
      builder: (context, state) =>
          TipoGastoPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/sucursales',
      builder: (context, state) => const SucursalesPage(),
    ),
    GoRoute(
      path: '/sucursal/:id',
      builder: (context, state) =>
          SucursalPage(id: state.pathParameters['id']!),
    ),
  ],
);
