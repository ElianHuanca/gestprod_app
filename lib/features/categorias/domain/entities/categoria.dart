class Categoria {
  final String id;
  final String nombre;
  final bool activo;

  const Categoria({
    required this.id,
    required this.nombre,
    this.activo = true,
  });
}
