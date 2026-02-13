import 'package:gestprod_app/features/categorias/presentation/pages/pages.dart';
import 'package:gestprod_app/features/productos/presentation/pages/pages.dart';
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
  ],
);
