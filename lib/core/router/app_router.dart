import 'package:gestprod_app/features/catalog/presentation/pages/pages.dart';
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
      builder: (context, state) => ProductoPage(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/categorias',
      builder: (context, state) => const CategoriasPage(),
    ),
  ],
);
