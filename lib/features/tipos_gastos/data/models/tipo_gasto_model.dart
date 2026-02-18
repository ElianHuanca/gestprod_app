import '../../domain/domain.dart';

class TipoGastoModel {
  final String id;
  final String nombre;
  final bool activo;

  TipoGastoModel({
    required this.id,
    required this.nombre,
    this.activo = true,
  });

  factory TipoGastoModel.fromMap(Map<String, dynamic> map) {
    return TipoGastoModel(
      id: (map['id'] as String?) ?? '',
      nombre: (map['tipo_gasto'] as String?) ?? '',
      activo: (map['activo'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_gasto': nombre,
      'activo': activo ? 1 : 0,
    };
  }

  TipoGasto toEntity() => TipoGasto(id: id, nombre: nombre, activo: activo);
}
