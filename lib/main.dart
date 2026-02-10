import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/di/service_locator.dart';
import 'package:gestprod_app/core/router/router.dart';
import 'package:gestprod_app/core/shared/widgets/widgets.dart';
import 'package:gestprod_app/features/catalog/presentation/presentation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  serviceLocatorInit();
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
        BlocProvider(create: (context) => getIt<ProductosBloc>(),lazy: false,),
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
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      routerConfig:appRouter,      
    );
  }
}
