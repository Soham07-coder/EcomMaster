import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecomprj/screens/order/views/orders_screen.dart'; // Import OrdersScreen

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    // Retrieve the total price from the arguments
    final double? totalPrice = ModalRoute.of(context)?.settings.arguments as double?;
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: userEmail != null
          ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(userEmail)
            .collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching cart data'));
          }

          final products = snapshot.data?.docs;

          if (products == null || products.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index].data() as Map<String, dynamic>;
                    final productId = products[index].id;
                    final isSelected = selectedProducts.any((p) => p['id'] == productId);

                    return ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedProducts.add({
                                'id': productId,
                                'title': product['title'],
                                'price': product['price'],
                                'quantity': product['quantity'],
                              });
                            } else {
                              selectedProducts.removeWhere((p) => p['id'] == productId);
                            }
                          });
                        },
                      ),
                      title: Text(product['title']),
                      subtitle: Text('Price: \$${product['price'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Qty: ${product['quantity']}'),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              _removeFromCart(productId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Display the total price for selected products
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total Selected Price: \$${_calculateTotalPrice().toStringAsFixed(2)}", // Show the calculated total
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ElevatedButton(
                onPressed: selectedProducts.isEmpty
                    ? null
                    : () async {
                  await _placeOrder(userEmail!, selectedProducts);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                  );
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      )
          : const Center(child: Text('User not authenticated')),
    );
  }

  // Method to calculate the total price of selected products
  double _calculateTotalPrice() {
    double total = 0.0;
    for (var product in selectedProducts) {
      total += (product['price'] as double) * (product['quantity'] as int);
    }
    return total;
  }

  Future<void> _removeFromCart(String productId) async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      // Remove product from Firestore
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userEmail)
          .collection('products')
          .doc(productId)
          .delete();

      // Also remove from selected products list if it exists
      setState(() {
        selectedProducts.removeWhere((p) => p['id'] == productId);
      });
    }
  }

  Future<void> _placeOrder(String userEmail, List<Map<String, dynamic>> selectedProducts) async {
    final ordersRef = FirebaseFirestore.instance.collection('orders').doc(userEmail).collection('products');
    final cartRef = FirebaseFirestore.instance.collection('carts').doc(userEmail).collection('products');

    // Add selected products to the orders collection
    for (var product in selectedProducts) {
      await ordersRef.add(product);
    }

    // Remove selected products from the cart
    for (var product in selectedProducts) {
      await cartRef.doc(product['id']).delete();
    }

    setState(() {
      selectedProducts.clear(); // Clear selected products after placing order
    });
  }
}
