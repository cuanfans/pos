import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/local_datasource.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/repositories/product_repository.dart';
import 'presentation/providers/product_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final remote = RemoteDataSource();
  final local = LocalDataSource();
  final repo = ProductRepository(remote, local);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider(repo)),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("POS V2 (MySQL + SQLite)")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text("Error: ${provider.error}\n(Cek Koneksi Server)"))
              : ListView.builder(
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final item = provider.products[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text("Stok: ${item.stock}"),
                      trailing: Text("Rp ${item.price}"),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => provider.loadProducts(),
      ),
    );
  }
}
