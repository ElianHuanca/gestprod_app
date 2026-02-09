import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/* final menuIndexProvider =
    StateNotifierProvider<MenuIndexNotifier, MenuIndexState>(
      (ref) => MenuIndexNotifier(),
    ); */

class MenuIndexCubit extends Cubit<MenuIndexState> {
  MenuIndexCubit() : super(MenuIndexState());

  void setIndex(int index) {
    emit(state.copyWith(index: index));
  }
}

class MenuIndexState {
  final int index;
  MenuIndexState({this.index = 1});
  MenuIndexState copyWith({int? index}) =>
      MenuIndexState(index: index ?? this.index);
}

class SideMenu extends StatelessWidget {
  final appLinkItems = ['/', '/productos', '/categorias'];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SideMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;

    //final menuIndexState = ref.watch(menuIndexProvider);

    return BlocBuilder<MenuIndexCubit, MenuIndexState>(
      builder: (context, menuIndexState) {
        return NavigationDrawer(
          elevation: 1,
          selectedIndex: menuIndexState.index,
          onDestinationSelected: (value) {
            context.read<MenuIndexCubit>().setIndex(value);
            context.go(appLinkItems[value]);
            scaffoldKey.currentState?.closeDrawer();
          },
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
              child: Text('Saludos', style: textStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
              child: Text(
                'Bienvenido a GestProd',
                style: textStyles.titleSmall,
              ),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.house_rounded),
              label: Text('Home Page'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.playlist_add),
              label: Text('Productos'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.add_shopping_cart_rounded),
              label: Text('Categorias'),
            ),
          ],
        );
      },
    );
  }
}
