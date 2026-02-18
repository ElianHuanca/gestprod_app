class TipoGasto {
  final String id;
  final String nombre;
  final bool activo;

  const TipoGasto({
    required this.id,
    required this.nombre,
    this.activo = true,
  });
}
