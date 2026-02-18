class Compra {
  final String id;
  final String? sucursalId;
  final String fecha;
  final double total;
  final double totalGastos;

  const Compra({
    required this.id,
    this.sucursalId,
    required this.fecha,
    this.total = 0,
    this.totalGastos = 0,
  });
}
