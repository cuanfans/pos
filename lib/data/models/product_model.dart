import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({super.id, required super.name, required super.price, required super.stock});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      // Pastikan konversi ke int aman
      id: int.tryParse(json['id'].toString()),
      name: json['name'],
      price: int.tryParse(json['price'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      stock: product.stock,
    );
  }
}
