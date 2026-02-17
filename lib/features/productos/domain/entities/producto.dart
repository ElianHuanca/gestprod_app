class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String imageUrl;
  final String categoriaId;
  final bool activo;

  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imageUrl,
    required this.categoriaId,
    this.activo = true,
  });
}
