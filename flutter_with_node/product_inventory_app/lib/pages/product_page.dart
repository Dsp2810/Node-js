import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../services/product_services.dart';
import '../pages/add_product_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> _products = [];
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
        _products = res['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${res['data']}")));
    }
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductPage()),
    );

    // Refresh only if a new product was added
    if (result == true) {
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            onPressed: _fetchProducts,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: _navigateToAddProduct,
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text("No Products"))
          : RefreshIndicator(
              onRefresh: _fetchProducts,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 10),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ProductCard(
                    name: product['name'] ?? "Unnamed",
                    price: double.tryParse(product['price'].toString()) ?? 0.0,
                    quantity: product['quantity'] ?? 0,
                    url: product['image'] != null
                        ? 'http://node-js-oerf.onrender.com/${product['image']}'
                        : '',
                  );
                },
              ),
            ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AddProductPage extends StatefulWidget {
//   const AddProductPage({Key? key}) : super(key: key);

//   @override
//   State<AddProductPage> createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '';
//   double price = 0;
//   String description = '';
//   bool isFav = false;
//   File? _imageFile;
//   final picker = ImagePicker();
//   bool isLoading = false;

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _imageFile = File(pickedFile.path));
//     }
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_imageFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please select an image')),
//         );
//         return;
//       }

//       _formKey.currentState!.save();
//       setState(() => isLoading = true);

//       // TODO: Upload image + form data to your backend via multipart/form-data

//       await Future.delayed(Duration(seconds: 2)); // simulate upload

//       setState(() => isLoading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Product added!')),
//       );
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Product"),
//         backgroundColor: Colors.deepPurpleAccent,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Product name
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Product Name'),
//                 onSaved: (val) => name = val!,
//                 validator: (val) =>
//                     val == null || val.isEmpty ? 'Enter name' : null,
//               ),
//               SizedBox(height: 12),
//               // Price
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 onSaved: (val) => price = double.parse(val!),
//                 validator: (val) =>
//                     val == null || double.tryParse(val) == null
//                         ? 'Enter valid price'
//                         : null,
//               ),
//               SizedBox(height: 12),
//               // Description
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 onSaved: (val) => description = val!,
//                 validator: (val) =>
//                     val == null || val.isEmpty ? 'Enter description' : null,
//               ),
//               SizedBox(height: 12),
//               // Image picker
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   height: 150,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.grey[200],
//                   ),
//                   child: _imageFile == null
//                       ? Center(child: Text("Tap to pick image"))
//                       : Image.file(_imageFile!, fit: BoxFit.cover),
//                 ),
//               ),
//               SizedBox(height: 12),
//               // Favorite switch
//               SwitchListTile(
//                 title: Text("Mark as Favorite"),
//                 value: isFav,
//                 onChanged: (val) => setState(() => isFav = val),
//               ),
//               SizedBox(height: 20),
//               isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton.icon(
//                       onPressed: _submitForm,
//                       icon: Icon(Icons.save),
//                       label: Text("Add Product"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurpleAccent,
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
