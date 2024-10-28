import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';

class AddedToCartMessageScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items; // Accept the list of items

  const AddedToCartMessageScreen({super.key, required this.items}); // Accept items through constructor

  Future<void> _addItemsToCart() async {
    // Get a reference to the Firestore collection
    final cartCollection = FirebaseFirestore.instance.collection('carts');

    // Iterate through the items and add each one to Firestore
    for (var item in items) {
      await cartCollection.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the method to add items to Firestore when the screen is built
    _addItemsToCart();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/Illustration/success.png"
                    : "assets/Illustration/success_dark.png",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const Spacer(flex: 2),
              Text(
                "Added to cart",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                "Click the checkout button to complete the purchase process.",
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, entryPointScreenRoute);
                },
                child: const Text("Continue Shopping"),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, cartScreenRoute);
                },
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
