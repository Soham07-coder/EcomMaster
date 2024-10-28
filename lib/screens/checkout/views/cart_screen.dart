import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cartItems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders'));
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final title = product['title'] ?? 'No Title';
              final price = product['price'] ?? 0.0;
              final quantity = product['quantity'] ?? 1;
              final imageUrl = product['imageUrl'] ??
                  'https://via.placeholder.com/150'; // Default image if none provided

              return ListTile(
                leading: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(title),
                subtitle: Text('Quantity: $quantity | Price: \$${price.toStringAsFixed(2)}'),
                trailing: Text('\$${(price * quantity).toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
