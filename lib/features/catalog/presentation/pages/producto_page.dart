import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/catalog/domain/domain.dart';
import 'package:gestprod_app/features/catalog/presentation/bloc/productos/productos_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.id != '0') _loadProducto();
  }

  Future<void> _loadProducto() async {
    setState(() => _loading = true);
    try {
      final repo = context.read<ProductosBloc>().repository;
      final producto = await repo.obtenerProducto(widget.id.toString());
      _nombreCtrl.text = producto.nombre;
      _precioCtrl.text = producto.precio.toString();
      _imageCtrl.text = producto.imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cargando producto')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.id == '0'
        ? Uuid().v4()
        : widget.id.toString();
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text.trim()) ?? 0;
    final imageUrl = _imageCtrl.text.trim();

    final producto = Producto(
      id: id,
      nombre: nombre,
      precio: precio,
      imageUrl: imageUrl,
    );

    final bloc = context.read<ProductosBloc>();
    if (widget.id == '0') {
      bloc.add(AgregarProducto(producto));
    } else {
      bloc.add(ActualizarProducto(producto));
    }

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
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Ingrese el nombre'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _precioCtrl,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => double.tryParse(v ?? '') == null
                        ? 'Precio inválido'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _imageCtrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text(widget.id == '0' ? 'Crear' : 'Guardar'),
                  ),
                ],
              ),
            ),
    );
  }
}
