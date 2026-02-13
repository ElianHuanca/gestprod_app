import '../../domain/domain.dart';

class ProductoModel {
  final String id;
  final String nombre;
  final double precio;
  final String imageUrl;
  final String categoriaId;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imageUrl,
    required this.categoriaId,
  });

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      id: (map['id'] as String?) ?? '',
      nombre: (map['nombre'] as String?) ?? '',
      precio: (map['precio'] as num?)?.toDouble() ?? 0.0,
      imageUrl: (map['image_url'] as String?) ?? '',
      categoriaId: (map['categoria_id'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'image_url': imageUrl,
      'categoria_id': categoriaId,
    };
  }

  Producto toEntity() => Producto(
        id: id,
        nombre: nombre,
        precio: precio,
        imageUrl: imageUrl,
        categoriaId: categoriaId,
      );
}
