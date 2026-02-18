import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/compras/presentation/presentation.dart';
import 'package:gestprod_app/features/sucursales/domain/domain.dart';
import 'package:go_router/go_router.dart';

class ComprasPage extends StatefulWidget {
  const ComprasPage({super.key});

  @override
  State<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  List<Sucursal> _sucursales = [];

  @override
  void initState() {
    super.initState();
    _cargarSucursales();
  }

  Future<void> _cargarSucursales() async {
    try {
      final repo = getIt<SucursalesRepository>();
      final list = await repo.obtenerSucursales();
      if (!mounted) return;
      setState(() => _sucursales = list);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: false,
      body: _buildBody(context),
      title: 'Compras',
      isGridview: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/compra/0'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ComprasBloc, ComprasState>(
      builder: (context, state) {
        if (state is ComprasCargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ComprasCargado) {
          final compras = state.comprasVisibles;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: _buildFiltroSucursal(context, state),
              ),
              Expanded(
                child: compras.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay compras para la sucursal seleccionada.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 24,
                        ),
                        itemCount: compras.length,
                        itemBuilder: (context, index) {
                          final compra = compras[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () =>
                                  context.push('/compra/${compra.id}'),
                              leading: CircleAvatar(
                                child: Icon(Icons.shopping_cart,
                                    color: Colors.grey[700]),
                              ),
                              title: Text(
                                _formatFecha(compra.fecha),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'Total: \$${compra.total.toStringAsFixed(2)}  •  Gastos: \$${compra.totalGastos.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }

        if (state is ComprasError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildFiltroSucursal(BuildContext context, ComprasCargado state) {
    final idsSucursales = _sucursales.map((s) => s.id).toSet();
    final value = state.sucursalIdFiltro != null &&
            idsSucursales.contains(state.sucursalIdFiltro)
        ? state.sucursalIdFiltro
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CustomDropdownField<Sucursal>(
        items: _sucursales,
        value: value,
        onChanged: (value) {
          context.read<ComprasBloc>().add(FiltrarComprasPorSucursal(value));
        },
        itemLabel: (s) => s.nombre,
        itemValue: (s) => s.id,
        label: 'Sucursal',
        hint: 'Todas',
        icon: Icons.store_outlined,
        allowNull: true,
        nullLabel: 'Todas las sucursales',
        fieldKey: ValueKey(value ?? 'todas'),
      ),
    );
  }

  String _formatFecha(String fecha) {
    if (fecha.isEmpty) return 'Sin fecha';
    try {
      final d = DateTime.parse(fecha);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return fecha;
    }
  }
}
