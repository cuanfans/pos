import 'package:flutter/material.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/entities/product.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider(this.repository);

  List<Product> _products = [];
  List<Product> get products => _products;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await repository.getAllProducts();

    if (result.isSuccess) {
      _products = result.data!;
    } else {
      _error = result.message;
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
