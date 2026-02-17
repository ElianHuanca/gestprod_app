import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/data/data.dart';
import 'package:gestprod_app/features/categorias/domain/domain.dart';
import 'package:gestprod_app/features/categorias/presentation/presentation.dart';
import 'package:gestprod_app/features/productos/data/data.dart';
import 'package:gestprod_app/features/productos/domain/domain.dart';
import 'package:gestprod_app/features/productos/presentation/presentation.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

GetIt getIt = GetIt.instance;

Future<void> serviceLocatorInit() async {
  getIt.registerSingleton(RouterCubit());
  getIt.registerSingleton(MenuIndexCubit());
  // Database
  final db = await AppDatabase.database;
  getIt.registerSingleton<Database>(db);

  // Cloudinary (subida de imágenes)
  getIt.registerLazySingleton<CloudinaryService>(
    () => CloudinaryService(),
  );

  // Productos
  getIt.registerLazySingleton<ProductosDataSource>(
    () => ProductosDatasourceImpl(getIt<Database>()),
  );
  getIt.registerLazySingleton<ProductosRepository>(
    () => ProductosRepositoryImpl(getIt<ProductosDataSource>()),
  );
  getIt.registerFactory(
    () => ProductosBloc(getIt<ProductosRepository>()),
  );

  // Categorias
  getIt.registerLazySingleton<CategoriasDataSource>(
    () => CategoriasDatasourceImpl(getIt<Database>()),
  );
  getIt.registerLazySingleton<CategoriasRepository>(
    () => CategoriasRepositoryImpl(getIt<CategoriasDataSource>()),
  );
  getIt.registerFactory(
    () => CategoriasBloc(getIt<CategoriasRepository>()),
  );
}