import 'package:flutter/material.dart';
import '../services/product_services.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddAddProductPagestate createState() => _AddAddProductPagestate();
}

class _AddAddProductPagestate extends State<AddProductPage> {
  final formkey = GlobalKey<FormState>();
  String name = '';
  double price = 0;
  String description = '';
  String imageUrl = '';
  bool isFav = false;
  bool isLoading = false;

  void _submitform() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      final result = await ProductServices.createProduct(
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
        isFav: isFav,
      );

      setState(() {
        isLoading = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Product Added Successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${result['data']}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                onSaved: (val) => name = val!,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter Product Name' : null,
              ),
              SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (val) => price = double.tryParse(val!) ?? 0.0,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter Price' : null,
              ),
              SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                onSaved: (val) => description = val!,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter Description' : null,
              ),
              SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(labelText: "Image URL"),
                onSaved: (val) => imageUrl = val!,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter Image URL' : null,
              ),
              SizedBox(height: 14),
              SwitchListTile(
                title: Text('Mark As Favorite'),
                value: isFav,
                onChanged: (val) => setState(() {
                  isFav = val;
                }),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: Icon(Icons.check),
                      onPressed: _submitform,
                      label: Text('Add Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
