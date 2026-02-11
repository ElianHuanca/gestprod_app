import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/catalog/data/data.dart';
import 'package:gestprod_app/features/catalog/domain/domain.dart';
import 'package:gestprod_app/features/catalog/presentation/presentation.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

GetIt getIt = GetIt.instance;

Future<void> serviceLocatorInit() async {
  getIt.registerSingleton(RouterCubit());
  getIt.registerSingleton(MenuIndexCubit());
  //Database
  final db = await AppDatabase.database;
  getIt.registerSingleton<Database>(db);

  //Datasource
  getIt.registerLazySingleton<ProductosDataSource>(
    () => ProductosDatasourceImpl(getIt<Database>()),
  );

  //Repository
  getIt.registerLazySingleton<ProductosRepository>(
    () => ProductosRepositoryImpl(getIt<ProductosDataSource>()),
  );

  //Bloc
  getIt.registerFactory(
    () => ProductosBloc(getIt<ProductosRepository>()),
  );
}