import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/presentation/presentation.dart';
import 'package:go_router/go_router.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: false,
      body: _buildBody(context),
      title: 'Categorías',
      isGridview: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[50],
        onPressed: () {
          context.push('/categoria/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        if (state is CategoriasCargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoriasCargado) {
          final categorias = state.categorias;
          if (categorias.isEmpty) {
            return const Center(
              child: Text('No hay categorías. Agrega una.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.category, color: Colors.grey[700]),
                  ),
                  title: Text(categoria.nombre),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/categoria/${categoria.id}');
                  },
                ),
              );
            },
          );
        }

        if (state is CategoriasError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
