import '../../domain/domain.dart';

class SucursalModel {
  final String id;
  final String nombre;
  final bool activo;

  SucursalModel({
    required this.id,
    required this.nombre,
    this.activo = true,
  });

  factory SucursalModel.fromMap(Map<String, dynamic> map) {
    return SucursalModel(
      id: (map['id'] as String?) ?? '',
      nombre: (map['sucursal'] as String?) ?? '',
      activo: (map['activo'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'sucursal': nombre,
        'activo': activo ? 1 : 0,
      };

  Sucursal toEntity() => Sucursal(id: id, nombre: nombre, activo: activo);

  static SucursalModel fromEntity(Sucursal e) => SucursalModel(
        id: e.id,
        nombre: e.nombre,
        activo: e.activo,
      );
}
