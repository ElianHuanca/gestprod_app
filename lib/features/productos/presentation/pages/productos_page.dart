import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/categorias/domain/domain.dart';
import 'package:gestprod_app/features/categorias/presentation/presentation.dart';
import 'package:gestprod_app/features/productos/domain/domain.dart';
import 'package:gestprod_app/features/productos/presentation/presentation.dart';
import 'package:gestprod_app/features/productos/presentation/utils/catalog_pdf_generator.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen1(
      backRoute: false,
      body: _buildBody(context),
      title: 'Productos',
      isGridview: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[50],
        onPressed: () {
          context.push('/producto/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProductosBloc, ProductosState>(
      builder: (context, state) {
        if (state is ProductosCargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductosCargado) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FiltroCategorias(selectedId: state.categoriaIdFilter),
              _BotonDescargarCatalogo(
                productos: state.productos,
                categoriaIdFilter: state.categoriaIdFilter,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: state.productosFiltrados.isEmpty
                    ? const Center(
                        child: Text('No hay productos en esta categoría'),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        children: _buildGrid(state.productosFiltrados, context),
                      ),
              ),
            ],
          );
        }

        if (state is ProductosError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  List<Widget> _buildGrid(List<Producto> productos, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return productos.map((producto) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            context.push('/producto/${producto.id}');
          },
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  producto.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      producto.nombre,
                      style: textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${producto.precio}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _BotonDescargarCatalogo extends StatefulWidget {
  final List<Producto> productos;
  final String? categoriaIdFilter;

  const _BotonDescargarCatalogo({
    required this.productos,
    this.categoriaIdFilter,
  });

  @override
  State<_BotonDescargarCatalogo> createState() => _BotonDescargarCatalogoState();
}

class _BotonDescargarCatalogoState extends State<_BotonDescargarCatalogo> {
  bool _loading = false;

  Future<void> _descargarCatalogo() async {
    final catState = context.read<CategoriasBloc>().state;
    if (catState is! CategoriasCargado) return;
    setState(() => _loading = true);
    try {
      final doc = await generateCatalogPdf(
        productos: widget.productos,
        categorias: catState.categorias,
        categoriaIdFilter: widget.categoriaIdFilter,
      );
      final bytes = await doc.save();
      await Printing.sharePdf(bytes: bytes, filename: 'catalogo_productos.pdf');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catálogo generado. Comparte o guarda el PDF.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el catálogo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: OutlinedButton.icon(
        onPressed: _loading ? null : _descargarCatalogo,
        icon: _loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf),
        label: Text(_loading ? 'Generando…' : 'Descargar catálogo PDF'),
      ),
    );
  }
}

class _FiltroCategorias extends StatelessWidget {
  final String? selectedId;

  const _FiltroCategorias({this.selectedId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, catState) {
        if (catState is! CategoriasCargado) {
          return const SizedBox.shrink();
        }
        final categorias = catState.categorias;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CustomDropdownField<Categoria>(
            items: categorias,
            value: selectedId,
            onChanged: (value) {
              context.read<ProductosBloc>().add(FiltrarPorCategoria(value));
            },
            itemLabel: (c) => c.nombre,
            itemValue: (c) => c.id,
            label: 'Categoría',
            hint: 'Todas',
            icon: Icons.filter_list,
            allowNull: true,
            nullLabel: 'Todas las categorías',
            fieldKey: ValueKey(selectedId ?? 'todas'),
          ),
        );
      },
    );
  }
}

