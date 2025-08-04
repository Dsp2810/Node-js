import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final int quantity;
  final String? url;
  final VoidCallback onedit;
  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.url,
    required this.onedit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: url != null
                    ? DecorationImage(
                        image: NetworkImage(
                          Uri.parse(url!).isAbsolute
                              ? url!
                              : 'http://node-js-oerf.onrender.com/$url',
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: url == null
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  Text(
                    "Price : \$${price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Quantity : $quantity",
                    style: TextStyle(
                      fontSize: 14,
                      color: quantity > 0 ? Colors.blueGrey : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onedit,
              icon: Icon(Icons.edit, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
