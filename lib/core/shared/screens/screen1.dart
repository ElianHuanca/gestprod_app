import 'package:flutter/material.dart';
import 'package:gestprod_app/core/shared/shared.dart';
import 'package:go_router/go_router.dart';

class Screen1 extends StatelessWidget {
  final Widget body;
  final String title;
  final bool isGridview;
  final FloatingActionButton? floatingActionButton;
  final bool backRoute;
  final Function? onTap;
  const Screen1({
    required this.body,
    super.key,
    required this.title,
    required this.isGridview,
    this.floatingActionButton,
    required this.backRoute,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: backRoute ? null : SideMenu(),
        appBar: AppBar(
          leading: backRoute
              ? BackButton(
                  onPressed: () {
                    context.pop();
                  },
                )
              : null,
          title: Text(title, style: Theme.of(context).textTheme.titleSmall),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          actions: [
            onTap != null
                ? IconButton(
                    onPressed: () => onTap!(),
                    icon: const Icon(Icons.add),
                  )
                : const SizedBox(),
          ],
        ),
        body: Padding(padding: const EdgeInsets.all(10), child: body),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
