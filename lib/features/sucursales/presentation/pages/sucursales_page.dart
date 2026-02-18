import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/sucursales/domain/domain.dart';
import 'package:gestprod_app/features/sucursales/presentation/bloc/sucursales/sucursales_bloc.dart';
import 'package:go_router/go_router.dart';

class SucursalesPage extends StatelessWidget {
  const SucursalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: false,
      body: _buildBody(context),
      title: 'Sucursales',
      isGridview: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/sucursal/0'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<SucursalesBloc, SucursalesState>(
      builder: (context, state) {
        if (state is SucursalesCargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SucursalesCargado) {
          final sucursales = state.sucursales;
          if (sucursales.isEmpty) {
            return const Center(
              child: Text('No hay sucursales. Agrega una.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: sucursales.length,
            itemBuilder: (context, index) {
              final sucursal = sucursales[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () => context.push('/sucursal/${sucursal.id}'),
                  leading: CircleAvatar(
                    child: Icon(Icons.store, color: Colors.grey[700]),
                  ),
                  title: Text(sucursal.nombre),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        }

        if (state is SucursalesError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
