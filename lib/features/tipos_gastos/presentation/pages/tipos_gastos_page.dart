import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/tipos_gastos/presentation/presentation.dart';
import 'package:go_router/go_router.dart';

class TiposGastosPage extends StatelessWidget {
  const TiposGastosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: false,
      body: _buildBody(context),
      title: 'Tipos de gastos',
      isGridview: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[50],
        onPressed: () {
          context.push('/tipo-gasto/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<TiposGastosBloc, TiposGastosState>(
      builder: (context, state) {
        if (state is TiposGastosCargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TiposGastosCargado) {
          final tiposGastos = state.tiposGastos;
          if (tiposGastos.isEmpty) {
            return const Center(
              child: Text('No hay tipos de gastos. Agrega uno.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: tiposGastos.length,
            itemBuilder: (context, index) {
              final tipoGasto = tiposGastos[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.receipt_long, color: Colors.grey[700]),
                  ),
                  title: Text(tipoGasto.nombre),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/tipo-gasto/${tipoGasto.id}');
                  },
                ),
              );
            },
          );
        }

        if (state is TiposGastosError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
