import 'package:flutter/material.dart';
import '../services/product_services.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const EditProductPage({Key? key, required this.product}) : super(key: key);
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController namecontroller;
  late TextEditingController pricecontroller;
  late TextEditingController descontroller;
  late TextEditingController quantitycontroller;
  late TextEditingController imagecontroller;
  bool isfav = false;

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.product['name']);
    pricecontroller = TextEditingController(
      text: widget.product['price'].toString(),
    );
    descontroller = TextEditingController(text: widget.product['description']);
    quantitycontroller = TextEditingController(
      text: widget.product['quantity'].toString(),
    );
    imagecontroller = TextEditingController(text: widget.product['image']);
    isfav = widget.product['isFav'] ?? false;
  }

  @override
  void dispose() {
    namecontroller.dispose();
    pricecontroller.dispose();
    quantitycontroller.dispose();
    imagecontroller.dispose();
    descontroller.dispose();
  }

  void updateProduct() async {
    final res = await ProductServices.UpadteProduct(
      name: namecontroller.text,
      ProductId: widget.product['_id'],
      price: double.parse(pricecontroller.text) ?? 0.0,
      description: descontroller.text,
      imageUrl: imagecontroller.text,
      quantity: int.parse(quantitycontroller.text) ?? 0,
      isFav: isfav,
    );
    if (res['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Edited ")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res['data'].toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(labelText: 'Producut Name'),
            ),
            TextField(
              controller: pricecontroller,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantitycontroller,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descontroller,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: imagecontroller,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            SwitchListTile(
              title: Text("Mark As Favourite"),
              value: isfav,
              onChanged: (val) => setState(() {
                isfav = val;
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProduct,
              child: Text("Update Product"),
            ),
          ],
        ),
      ),
    );
  }
}
