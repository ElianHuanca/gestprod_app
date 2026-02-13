import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/domain/domain.dart';
import 'package:gestprod_app/features/categorias/presentation/bloc/categorias/categorias_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class CategoriaPage extends StatefulWidget {
  final String id;

  const CategoriaPage({super.key, required this.id});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != '0') _loadCategoria();
  }

  Future<void> _loadCategoria() async {
    setState(() => _loading = true);
    try {
      final repo = getIt<CategoriasRepository>();
      final categoria = await repo.obtenerCategoria(widget.id);
      if (!mounted) return;
      _nombreCtrl.text = categoria.nombre;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cargando categoría')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.id == '0' ? Uuid().v4() : widget.id;
    final nombre = _nombreCtrl.text.trim();
    final categoria = Categoria(id: id, nombre: nombre);

    final bloc = context.read<CategoriasBloc>();
    if (widget.id == '0') {
      bloc.add(AgregarCategoria(categoria));
    } else {
      bloc.add(ActualizarCategoria(categoria));
    }
    context.pop();
  }

  void _onDelete() {
    context.read<CategoriasBloc>().add(EliminarCategoria(widget.id));
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
      title: widget.id == '0' ? 'Crear Categoría' : 'Editar Categoría',
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
                    hint: 'Ej. Auriculares',
                    icon: Icons.category_outlined,
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
