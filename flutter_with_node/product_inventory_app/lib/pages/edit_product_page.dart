import 'package:flutter/material.dart';

class EditProductPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${product['name']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Editing product: ${product['name']}'),
      ),
    );
  }
}
