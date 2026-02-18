import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/tipos_gastos/domain/domain.dart';
import 'package:gestprod_app/features/tipos_gastos/presentation/bloc/tipos_gastos/tipos_gastos_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class TipoGastoPage extends StatefulWidget {
  final String id;

  const TipoGastoPage({super.key, required this.id});

  @override
  State<TipoGastoPage> createState() => _TipoGastoPageState();
}

class _TipoGastoPageState extends State<TipoGastoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != '0') _loadTipoGasto();
  }

  Future<void> _loadTipoGasto() async {
    setState(() => _loading = true);
    try {
      final repo = getIt<TiposGastosRepository>();
      final tipoGasto = await repo.obtenerTipoGasto(widget.id);
      if (!mounted) return;
      _nombreCtrl.text = tipoGasto.nombre;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cargando tipo de gasto')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.id == '0' ? Uuid().v4() : widget.id;
    final nombre = _nombreCtrl.text.trim();
    final tipoGasto = TipoGasto(id: id, nombre: nombre);

    final bloc = context.read<TiposGastosBloc>();
    if (widget.id == '0') {
      bloc.add(AgregarTipoGasto(tipoGasto));
    } else {
      bloc.add(ActualizarTipoGasto(tipoGasto));
    }
    context.pop();
  }

  void _onDelete() {
    context.read<TiposGastosBloc>().add(EliminarTipoGasto(widget.id));
    context.pop();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: true,
      title: widget.id == '0' ? 'Crear tipo de gasto' : 'Editar tipo de gasto',
      isGridview: false,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomField(
                    isTopField: true,
                    isBottomField: true,
                    textEditingController: _nombreCtrl,
                    label: 'Nombre',
                    hint: 'Ej. Transporte Terrestre',
                    icon: Icons.receipt_long_outlined,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Ingrese el nombre' : null,
                  ),
                  const SizedBox(height: 20),
                  if (widget.id == '0')
                    MaterialButtonWidget(
                      onPressed: _onSubmit,
                      texto: 'Crear',
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButtonWidget(
                            onPressed: _onSubmit,
                            texto: 'Guardar',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MaterialButtonWidget(
                            onPressed: _onDelete,
                            texto: 'Eliminar',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
