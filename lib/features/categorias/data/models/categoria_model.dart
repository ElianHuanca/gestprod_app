import '../../domain/domain.dart';

class CategoriaModel {
  final String id;
  final String nombre;

  CategoriaModel({
    required this.id,
    required this.nombre,
  });

  factory CategoriaModel.fromMap(Map<String, dynamic> map) {
    return CategoriaModel(
      id: (map['id'] as String?) ?? '',
      nombre: (map['categoria'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': nombre,
    };
  }

  Categoria toEntity() => Categoria(id: id, nombre: nombre);
}
