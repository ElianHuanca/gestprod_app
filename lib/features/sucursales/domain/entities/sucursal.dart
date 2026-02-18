class Sucursal {
  final String id;
  final String nombre;
  final bool activo;

  const Sucursal({
    required this.id,
    required this.nombre,
    this.activo = true,
  });
}
