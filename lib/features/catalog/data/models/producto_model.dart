import '../../domain/domain.dart';

class ProductoModel {
  final String id;
  final String nombre;
  final double precio;
  final String imageUrl;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imageUrl,
  });

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      id: map['id'],
      nombre: map['nombre'],
      precio: map['precio'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'image_url': imageUrl,
    };
  }

  Producto toEntity() =>
      Producto(id: id, nombre: nombre, precio: precio, imageUrl: imageUrl);
}
