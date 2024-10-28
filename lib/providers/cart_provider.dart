// providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Add item to cart and Firestore
  Future<void> addToCart(ProductModel product) async {
    final item = {
      'id': product.id,
      'title': product.title,
      'image': product.image,
      'price': product.price,
      'quantity': 1,
    };

    _cartItems.add(item);
    await _firestore.collection('carts').add(item);
    notifyListeners();
  }

  // Fetch items from Firestore
  Future<void> fetchCartItems() async {
    final querySnapshot = await _firestore.collection('carts').get();
    _cartItems = querySnapshot.docs.map((doc) {
      return {
        'id': doc['id'],
        'title': doc['title'],
        'image': doc['image'],
        'price': doc['price'],
        'quantity': doc['quantity'],
      };
    }).toList();
    notifyListeners();
  }

  // Remove item from cart and Firestore
  Future<void> removeItem(String itemId) async {
    _cartItems.removeWhere((item) => item['id'] == itemId);
    // To implement: find and remove from Firestore based on itemId
    notifyListeners();
  }

  void incrementQuantity(String itemId) {
    final item = _cartItems.firstWhere((item) => item['id'] == itemId);
    item['quantity'] += 1;
    notifyListeners();
  }

  void decrementQuantity(String itemId) {
    final item = _cartItems.firstWhere((item) => item['id'] == itemId);
    if (item['quantity'] > 1) {
      item['quantity'] -= 1;
      notifyListeners();
    }
  }

  double get totalPrice {
    return _cartItems.fold(
      0,
          (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }
}
