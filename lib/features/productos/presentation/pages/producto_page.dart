import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/domain/domain.dart';
import 'package:gestprod_app/features/productos/domain/domain.dart';
import 'package:gestprod_app/features/productos/presentation/bloc/productos/productos_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  bool _loading = false;
  bool _uploadingImage = false;
  List<Categoria> _categorias = [];
  String? _categoriaId;
  final ImagePicker _picker = ImagePicker();
  /// Imagen local seleccionada (galería o cámara), aún no subida.
  File? _pickedFile;
  /// URL de la imagen (después de subir a Cloudinary o al cargar producto al editar).
  String _imageUrl = '';

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
      setState(() {
        _categoriaId = producto.categoriaId;
        _imageUrl = producto.imageUrl;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error cargando producto')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) return;

    final categoriaId = _categoriaId ?? _categorias.firstOrNull?.id ?? '';
    if (categoriaId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione una categoría')));
      return;
    }

    String imageUrl = _imageUrl;

    // Si hay imagen nueva seleccionada, subir a Cloudinary antes de guardar
    if (_pickedFile != null) {
      setState(() => _uploadingImage = true);
      try {
        final cloudinary = getIt<CloudinaryService>();
        final url = await cloudinary.uploadImage(_pickedFile!);
        if (!mounted) return;
        if (url != null) {
          imageUrl = url;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al subir la imagen')),
          );
          setState(() => _uploadingImage = false);
          return;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir imagen: $e')),
          );
          setState(() => _uploadingImage = false);
        }
        return;
      }
      if (mounted) setState(() => _uploadingImage = false);
    }

    final id = widget.id == '0' ? Uuid().v4() : widget.id;
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text.trim()) ?? 0;

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

    if (mounted) context.pop();
  }

  void _onDelete() {
    context.read<ProductosBloc>().add(EliminarProducto(widget.id));
    context.pop();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (picked == null || !mounted) return;
    setState(() => _pickedFile = File(picked.path));
  }

  void _discardImage() {
    setState(() {
      _pickedFile = null;
      _imageUrl = '';
    });
  }

  Widget _buildImageSection() {
    final hasPreview = _pickedFile != null || _imageUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Imagen del producto',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              color: Colors.grey[200],
              child: hasPreview
                  ? _pickedFile != null
                      ? Image.file(
                          _pickedFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                  : _placeholder(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loading ? null : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined, size: 20),
                label: const Text('Galería'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loading ? null : () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined, size: 20),
                label: const Text('Sacar foto'),
              ),
            ),
          ],
        ),
        if (hasPreview) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _loading ? null : _discardImage,
            icon: const Icon(Icons.delete_outline, size: 20),
            label: const Text('Descartar imagen'),
          ),
        ],
      ],
    );
  }

  Widget _placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 56, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Selecciona una imagen',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
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
                  // Vista previa de imagen al inicio
                  _buildImageSection(),
                  const SizedBox(height: 20),
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
                    MaterialButtonWidget(
                      onPressed: _uploadingImage ? () {} : () => _onSubmit(),
                      texto: _uploadingImage ? 'Subiendo imagen...' : 'Crear',
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButtonWidget(
                            onPressed: _uploadingImage ? () {} : () => _onSubmit(),
                            texto: _uploadingImage ? 'Guardando...' : 'Guardar',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MaterialButtonWidget(
                            onPressed: _uploadingImage ? () {} : _onDelete,
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
