import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/compras/domain/domain.dart';
import 'package:gestprod_app/features/compras/presentation/bloc/compras/compras_bloc.dart';
import 'package:gestprod_app/features/sucursales/domain/domain.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class CompraPage extends StatefulWidget {
  final String id;

  const CompraPage({super.key, required this.id});

  @override
  State<CompraPage> createState() => _CompraPageState();
}

class _CompraPageState extends State<CompraPage> {
  final _formKey = GlobalKey<FormState>();
  final _fechaCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _totalGastosCtrl = TextEditingController();

  bool _loading = false;
  List<Sucursal> _sucursales = [];
  String? _sucursalId;

  @override
  void initState() {
    super.initState();
    _loadSucursales();
    if (widget.id != '0') _loadCompra();
  }

  Future<void> _loadSucursales() async {
    try {
      final repo = getIt<SucursalesRepository>();
      final list = await repo.obtenerSucursales();
      if (!mounted) return;
      setState(() {
        _sucursales = list;
        if (list.isNotEmpty && _sucursalId == null) _sucursalId = list.first.id;
      });
    } catch (_) {}
  }

  Future<void> _loadCompra() async {
    setState(() => _loading = true);
    try {
      final repo = getIt<ComprasRepository>();
      final compra = await repo.obtenerCompra(widget.id);
      if (!mounted) return;
      if (compra == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra no encontrada')),
        );
        return;
      }
      _fechaCtrl.text = compra.fecha;
      _totalCtrl.text = compra.total.toString();
      _totalGastosCtrl.text = compra.totalGastos.toString();
      setState(() => _sucursalId = compra.sucursalId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cargando compra')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime initial = now;
    if (_fechaCtrl.text.isNotEmpty) {
      final parsed = DateTime.tryParse(_fechaCtrl.text);
      if (parsed != null) initial = parsed;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      _fechaCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.id == '0' ? Uuid().v4() : widget.id;
    final fecha = _fechaCtrl.text.trim();
    final total = _parseDouble(_totalCtrl.text) ?? 0.0;
    final totalGastos = _parseDouble(_totalGastosCtrl.text) ?? 0.0;

    final compra = Compra(
      id: id,
      sucursalId: _sucursalId,
      fecha: fecha,
      total: total,
      totalGastos: totalGastos,
    );

    final bloc = context.read<ComprasBloc>();
    if (widget.id == '0') {
      bloc.add(AgregarCompra(compra));
    } else {
      bloc.add(ActualizarCompra(compra));
    }
    context.pop();
  }

  void _onDelete() {
    context.read<ComprasBloc>().add(EliminarCompra(widget.id));
    context.pop();
  }

  double? _parseDouble(String v) {
    if (v.trim().isEmpty) return null;
    return double.tryParse(v.trim().replaceFirst(',', '.'));
  }

  @override
  void dispose() {
    _fechaCtrl.dispose();
    _totalCtrl.dispose();
    _totalGastosCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: true,
      title: widget.id == '0' ? 'Nueva Compra' : 'Editar Compra',
      isGridview: false,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomField(
                          isTopField: true,
                          isBottomField: true,
                          textEditingController: _fechaCtrl,
                          label: 'Fecha',
                          hint: 'AAAA-MM-DD',
                          icon: Icons.calendar_today_outlined,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Ingrese la fecha';
                            if (DateTime.tryParse(v.trim()) == null) {
                              return 'Formato: AAAA-MM-DD';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.event),
                        tooltip: 'Seleccionar fecha',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomDropdownField<Sucursal>(
                    items: _sucursales,
                    value: _sucursalId,
                    onChanged: (value) => setState(() => _sucursalId = value),
                    itemLabel: (s) => s.nombre,
                    itemValue: (s) => s.id,
                    label: 'Sucursal',
                    hint: 'Seleccione sucursal',
                    icon: Icons.store_outlined,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Seleccione una sucursal' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomField(
                    isTopField: true,
                    isBottomField: false,
                    textEditingController: _totalCtrl,
                    label: 'Total',
                    hint: '0.00',
                    icon: Icons.attach_money,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ingrese el total';
                      if (_parseDouble(v) == null) return 'Valor numérico';
                      return null;
                    },
                  ),
                  CustomField(
                    isTopField: false,
                    isBottomField: true,
                    textEditingController: _totalGastosCtrl,
                    label: 'Total gastos',
                    hint: '0.00',
                    icon: Icons.receipt_long_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ingrese total gastos';
                      if (_parseDouble(v) == null) return 'Valor numérico';
                      return null;
                    },
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
