import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../core/api_result.dart';
import '../models/product_model.dart';

class RemoteDataSource {
  Future<ApiResult<List<ProductModel>>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/products'));
      
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data']; // Sesuaikan dengan format JSON PHP
        final products = data.map((e) => ProductModel.fromJson(e)).toList();
        return ApiResult.success(products);
      } else {
        return ApiResult.failure('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure('Koneksi Gagal: $e');
    }
  }

  Future<ApiResult<int>> createProduct(ProductModel product) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResult.success(data['id']); // Ambil ID baru dari server
      }
      return ApiResult.failure('Gagal upload data');
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
