import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestprod_app/core/core.dart';
import 'package:gestprod_app/features/catalog/domain/domain.dart';
import 'package:gestprod_app/features/catalog/presentation/presentation.dart';
import 'package:go_router/go_router.dart';

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
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            children: _buildGrid(state.productos, context),
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

  /* List<Widget> _buildBody(
    BuildContext context,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return productos.map((producto) {
      return Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // luego puedes navegar al detalle
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen
              Expanded(
                child: Image.network(
                  producto['image'],
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),

              // Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      producto['nombre'],
                      style: textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${producto['precio']}',
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
  } */
}
