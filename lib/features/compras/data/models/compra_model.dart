import '../../domain/domain.dart';

class CompraModel {
  final String id;
  final String? sucursalId;
  final String fecha;
  final double total;
  final double totalGastos;

  CompraModel({
    required this.id,
    this.sucursalId,
    required this.fecha,
    this.total = 0,
    this.totalGastos = 0,
  });

  factory CompraModel.fromMap(Map<String, dynamic> map) {
    return CompraModel(
      id: (map['id'] as String?) ?? '',
      sucursalId: map['sucursal_id'] as String?,
      fecha: (map['fecha'] as String?) ?? '',
      total: (map['total'] as num?)?.toDouble() ?? 0,
      totalGastos: (map['total_gastos'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'sucursal_id': sucursalId,
        'fecha': fecha,
        'total': total,
        'total_gastos': totalGastos,
      };

  Compra toEntity() => Compra(
        id: id,
        sucursalId: sucursalId,
        fecha: fecha,
        total: total,
        totalGastos: totalGastos,
      );

  static CompraModel fromEntity(Compra e) => CompraModel(
        id: e.id,
        sucursalId: e.sucursalId,
        fecha: e.fecha,
        total: e.total,
        totalGastos: e.totalGastos,
      );
}
