import '../../domain/domain.dart';

class ProductoModel {
  final String id;
  final String nombre;
  final double precio;
  final String imageUrl;
  final String categoriaId;
  /// Costo por defecto 0; no se muestra en el formulario (solo en backup/DB).
  final double costo;
  final bool activo;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imageUrl,
    required this.categoriaId,
    this.costo = 0.0,
    this.activo = true,
  });

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    final nombre = (map['producto'] as String?) ?? (map['nombre'] as String?) ?? '';
    final imageUrl = (map['url'] as String?) ?? (map['image_url'] as String?) ?? '';
    return ProductoModel(
      id: (map['id'] as String?) ?? '',
      nombre: nombre,
      precio: (map['precio'] as num?)?.toDouble() ?? 0.0,
      imageUrl: imageUrl,
      categoriaId: (map['categoria_id'] as String?) ?? '',
      costo: (map['costo'] as num?)?.toDouble() ?? 0.0,
      activo: (map['activo'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producto': nombre,
      'url': imageUrl,
      'precio': precio,
      'costo': costo,
      'categoria_id': categoriaId,
      'activo': activo ? 1 : 0,
    };
  }

  Producto toEntity() => Producto(
        id: id,
        nombre: nombre,
        precio: precio,
        imageUrl: imageUrl,
        categoriaId: categoriaId,
        activo: activo,
      );
}
