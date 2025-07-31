import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/product_services.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  double price = 0;
  String description = '';
  bool isFav = false;
  bool isLoading = false;
  int quantity = 1;
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedImage != null) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      final result = await ProductServices.uploadProductWithImage(
        name: name,
        price: price,
        description: description,
        isFav: isFav,
        quantity: quantity,
        file: selectedImage!,
      );

      setState(() {
        isLoading = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ Product Added Successfully")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Failed: ${result['data']}")));
      }
    } else if (selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("📷 Please select an image")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
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
                decoration: InputDecoration(labelText: "Quantity"),
                onSaved: (val) => quantity = int.parse(val!),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter Quantity' : null,
              ),
              SizedBox(height: 14),
              Text("📸 Product Image", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              if (selectedImage != null)
                Image.file(selectedImage!, height: 200)
              else
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text("No image selected")),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.photo),
                    label: Text("Gallery"),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text("Camera"),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
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
                      onPressed: _submitForm,
                      label: Text('Add Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// // import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/product_services.dart';

// class AddProductPage extends StatefulWidget {
//   const AddProductPage({Key? key}) : super(key: key);

//   @override
//   State<AddProductPage> createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _descController = TextEditingController();
//   final _imageUrlController = TextEditingController();
//   bool _isFav = false;
//   File? _imageFile;

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final name = _nameController.text.trim();
//       final price = double.tryParse(_priceController.text.trim()) ?? 0;
//       final description = _descController.text.trim();
//       final imageUrl = _imageUrlController.text.trim();

//       final result = _imageFile != null
//           ? await ProductServices.uploadProductWithImage(
//               name: name,
//               price: price,
//               description: description,
//               file: _imageFile!,
//               isFav: _isFav,
//             )
//           : await ProductServices.createProduct(
//               name: name,
//               price: price,
//               description: description,
//               imageUrl: imageUrl,
//               isFav: _isFav,
//             );

//       if (result['success']) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Product added successfully!")),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${result['data']}")),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _priceController.dispose();
//     _descController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Product'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Product Name'),
//                   validator: (val) => val!.isEmpty ? 'Enter product name' : null,
//                 ),
//                 TextFormField(
//                   controller: _priceController,
//                   decoration: const InputDecoration(labelText: 'Price'),
//                   keyboardType: TextInputType.number,
//                   validator: (val) => val!.isEmpty ? 'Enter price' : null,
//                 ),
//                 TextFormField(
//                   controller: _descController,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   validator: (val) => val!.isEmpty ? 'Enter description' : null,
//                 ),
//                 TextFormField(
//                   controller: _imageUrlController,
//                   decoration: const InputDecoration(labelText: 'Image URL (optional)'),
//                 ),
//                 const SizedBox(height: 12),
//                 if (_imageFile != null)
//                   Image.file(_imageFile!, height: 150),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () => _pickImage(ImageSource.gallery),
//                       icon: const Icon(Icons.photo),
//                       label: const Text('Gallery'),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () => _pickImage(ImageSource.camera),
//                       icon: const Icon(Icons.camera),
//                       label: const Text('Camera'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 SwitchListTile(
//                   title: const Text('Is Favorite?'),
//                   value: _isFav,
//                   onChanged: (val) {
//                     setState(() {
//                       _isFav = val;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: const Text('Add Product'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
