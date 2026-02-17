import '../../domain/domain.dart';

class CategoriaModel {
  final String id;
  final String nombre;
  final bool activo;

  CategoriaModel({
    required this.id,
    required this.nombre,
    this.activo = true,
  });

  factory CategoriaModel.fromMap(Map<String, dynamic> map) {
    return CategoriaModel(
      id: (map['id'] as String?) ?? '',
      nombre: (map['categoria'] as String?) ?? '',
      activo: (map['activo'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': nombre,
      'activo': activo ? 1 : 0,
    };
  }

  Categoria toEntity() => Categoria(id: id, nombre: nombre, activo: activo);
}
