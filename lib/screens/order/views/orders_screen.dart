import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: userEmail != null
          ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(userEmail)
            .collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders'));
          }

          final orderedProducts = snapshot.data?.docs;

          if (orderedProducts == null || orderedProducts.isEmpty) {
            return const Center(child: Text('No orders placed.'));
          }

          return ListView.builder(
            itemCount: orderedProducts.length,
            itemBuilder: (context, index) {
              final product = orderedProducts[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(product['title']),
                subtitle: Text('Price: ${product['price']}'),
                trailing: Text('Qty: ${product['quantity']}'),
              );
            },
          );
        },
      )
          : const Center(child: Text('User not authenticated')),
    );
  }
}
