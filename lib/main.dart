import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/presentation/presentation.dart';
import 'package:gestprod_app/features/productos/presentation/presentation.dart';
import 'package:gestprod_app/features/compras/presentation/presentation.dart';
import 'package:gestprod_app/features/sucursales/presentation/presentation.dart';
import 'package:gestprod_app/features/tipos_gastos/presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocatorInit();
  runApp(const BlocsProvider());
}

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<RouterCubit>()),
        BlocProvider(create: (context) => getIt<MenuIndexCubit>()),
        BlocProvider(
          create: (context) => getIt<ProductosBloc>()..add(CargarProductos()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<CategoriasBloc>()..add(CargarCategorias()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<TiposGastosBloc>()..add(CargarTiposGastos()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<ComprasBloc>()..add(CargarCompras()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<SucursalesBloc>()..add(CargarSucursales()),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = context.watch<RouterCubit>().state;
    return MaterialApp.router(
      title: 'GestProd',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}
