import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/domain/domain.dart';
import 'package:gestprod_app/features/productos/domain/domain.dart';
import 'package:gestprod_app/features/productos/presentation/bloc/productos/productos_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class ProductoPage extends StatefulWidget {
  final String id;

  const ProductoPage({super.key, required this.id});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  bool _loading = false;
  List<Categoria> _categorias = [];
  String? _categoriaId;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
    if (widget.id != '0') _loadProducto();
  }

  Future<void> _loadCategorias() async {
    try {
      final repo = getIt<CategoriasRepository>();
      final list = await repo.obtenerCategorias();
      if (!mounted) return;
      setState(() {
        _categorias = list;
        if (widget.id == '0' && list.isNotEmpty && _categoriaId == null) {
          _categoriaId = list.first.id;
        }
      });
    } catch (_) {}
  }

  Future<void> _loadProducto() async {
    setState(() => _loading = true);
    try {
      final repo = getIt<ProductosRepository>();
      final producto = await repo.obtenerProducto(widget.id);
      if (!mounted) return;
      _nombreCtrl.text = producto.nombre;
      _precioCtrl.text = producto.precio.toString();
      _imageCtrl.text = producto.imageUrl;
      setState(() => _categoriaId = producto.categoriaId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error cargando producto')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSubmit() {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) return;

    final categoriaId = _categoriaId ?? _categorias.firstOrNull?.id ?? '';
    if (categoriaId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione una categoría')));
      return;
    }

    final id = widget.id == '0' ? Uuid().v4() : widget.id;
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text.trim()) ?? 0;
    final imageUrl = _imageCtrl.text.trim();

    final producto = Producto(
      id: id,
      nombre: nombre,
      precio: precio,
      imageUrl: imageUrl,
      categoriaId: categoriaId,
    );

    final bloc = context.read<ProductosBloc>();
    if (widget.id == '0') {
      bloc.add(AgregarProducto(producto));
    } else {
      bloc.add(ActualizarProducto(producto));
    }

    context.pop();
  }

  void _onDelete() {
    context.read<ProductosBloc>().add(EliminarProducto(widget.id));
    context.pop();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: true,
      title: widget.id == '0' ? 'Crear Producto' : 'Editar Producto',
      isGridview: false,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomField(
                    isTopField: true,
                    textEditingController: _nombreCtrl,
                    label: 'Nombre',
                    hint: 'Ej. REDMI Buds 5 PRO',
                    icon: Icons.shopping_bag_outlined,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Ingrese el nombre'
                        : null,
                  ),
                  CustomField(
                    textEditingController: _precioCtrl,
                    label: 'Precio',
                    hint: '0.00',
                    icon: Icons.attach_money,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) => double.tryParse(v ?? '') == null
                        ? 'Precio inválido'
                        : null,
                  ),
                  CustomField(
                    textEditingController: _imageCtrl,
                    label: 'URL de la imagen',
                    hint: 'https://...',
                    icon: Icons.link,
                    keyboardType: TextInputType.url,
                  ),
                  CustomDropdownField<Categoria>(
                    items: _categorias,
                    value: _categoriaId,
                    onChanged: (value) =>
                        setState(() => _categoriaId = value),
                    itemLabel: (c) => c.nombre,
                    itemValue: (c) => c.id,
                    label: 'Categoría',
                    hint: 'Seleccione',
                    icon: Icons.category_outlined,
                    onSaved: (value) => _categoriaId = value,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Seleccione una categoría'
                        : null,
                    fieldKey: ValueKey(_categoriaId),
                  ),
                  const SizedBox(height: 15),
                  if (widget.id == '0')
                    MaterialButtonWidget(onPressed: _onSubmit, texto: 'Crear')
                  else
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButtonWidget(
                            onPressed: _onSubmit,
                            texto: 'Guardar',
                          ),
                        ),
                        const SizedBox(width: 10),
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
