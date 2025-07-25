import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../services/product_services.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);
  @override
  _productpagestate createState() => _productpagestate();
}

class _productpagestate extends State<ProductPage> {
  List<dynamic> _prducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final res = await ProductServices.fetchProduct();
    if (res['success']) {
      setState(() {
        _prducts = res['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res['data'].toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            onPressed: _fetchProducts,
            icon: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          /* navigation to add product*/
        },
        icon: Icon(Icons.add),
        label: Text("Add Product"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _prducts.isEmpty
          ? Center(child: Text("No Products"))
          : RefreshIndicator(
              onRefresh: _fetchProducts,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 80, top: 10),
                itemCount: _prducts.length,
                itemBuilder: (context, index) {
                  final product = _prducts[index];
                  return ProductCard(
                    name: product['name'],
                    price: (product['price'] as num).toDouble(),
                    quantity: product["quantity"],
                    url: product["image"],
                  );
                },
              ),
            ),
    );
  }
}
