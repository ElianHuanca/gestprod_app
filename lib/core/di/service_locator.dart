import 'package:gestprod_app/core/router/router.dart';
import 'package:gestprod_app/core/shared/shared.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void serviceLocatorInit() {
  getIt.registerSingleton(RouterCubit());
  getIt.registerSingleton(MenuIndexCubit());
}
