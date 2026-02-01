import '../../core/api_result.dart';
import '../../domain/entities/product.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepository {
  final RemoteDataSource remote;
  final LocalDataSource local;

  ProductRepository(this.remote, this.local);

  Future<ApiResult<List<Product>>> getAllProducts() async {
    // 1. Coba ambil dari Server (Online)
    final remoteResult = await remote.getProducts();

    if (remoteResult.isSuccess) {
      // Jika Online: Update data lokal agar sama dengan server
      await local.clearProducts();
      for (var item in remoteResult.data!) {
        await local.insertProduct(item);
      }
      return ApiResult.success(remoteResult.data!);
    } else {
      // 2. Jika Offline/Gagal: Ambil dari SQLite
      final localData = await local.getProducts();
      if (localData.isNotEmpty) {
        return ApiResult.success(localData);
      }
      return ApiResult.failure(remoteResult.message ?? 'Data kosong');
    }
  }

  Future<ApiResult<void>> addProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    // Logika simpan sederhana: Kirim server dulu
    final result = await remote.createProduct(model);
    
    // Nanti bisa ditambahkan logika antrian (Queue) jika offline
    return result.isSuccess ? ApiResult.success(null) : ApiResult.failure(result.message);
  }
}
