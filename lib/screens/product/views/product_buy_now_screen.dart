import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';
import '../../../route/route_constants.dart';
import 'added_to_cart_message_screen.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';
import 'package:ecomprj/components/cart_button.dart';
import 'package:ecomprj/components/network_image_with_loader.dart';
import 'package:ecomprj/screens/product/views/components/product_list_tile.dart';
import 'package:ecomprj/screens/product/views/location_permission_store_availability_screen.dart';
import 'package:ecomprj/models/product_model.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int _itemCount = 1;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isConnected = true;

  // State variables for selected color and size
  int _selectedColorIndex = 2; // Default selected color index
  int _selectedSizeIndex = 1; // Default selected size index

  @override
  void initState() {
    super.initState();
    _checkNetworkConnectivity();
  }

  void _checkNetworkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _incrementItemCount() {
    setState(() {
      _itemCount++;
    });
  }

  void _decrementItemCount() {
    if (_itemCount > 1) {
      setState(() {
        _itemCount--;
      });
    }
  }

  Future<void> _saveProductData(ProductModel product) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'title': product.title,
        'price': product.price,
        'quantity': _itemCount,
        'brandName': product.brandName,
        'discountPercent': product.dicountpercent,
        'priceAfterDiscount': product.priceAfetDiscount,
      });
      print('Product data saved successfully!');
    } catch (e) {
      print('Error saving product data: ${e.toString()}');
    }
  }

  void _onAddToCart() async {
    ProductModel product = ProductModel(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      image: _selectedImage?.path ?? '',
      title: "Sleeveless Ruffle",
      brandName: "Your Brand Name",
      price: 145.0,
      priceAfetDiscount: 134.7,
      dicountpercent: 5,
    );

    await _saveProductData(product);

    // Navigate to the AddedToCartMessageScreen with the added product details
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddedToCartMessageScreen(
          items: [
            {
              'title': product.title,
              'price': product.price,
              'quantity': _itemCount,
              'brandName': product.brandName,
              'discountPercent': product.dicountpercent,
              'priceAfterDiscount': product.priceAfetDiscount,
            },
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: 269.4,
        title: "Buy Now",
        subTitle: "Total price",
        press: _onAddToCart,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  "Sleeveless Ruffle",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {}, // No image selection needed
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: NetworkImageWithLoader(productDemoImg1),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: UnitPrice(
                            price: 145,
                            priceAfterDiscount: 134.7,
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: _itemCount,
                          onIncrement: _incrementItemCount,
                          onDecrement: _decrementItemCount,
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                // Color Selection
                SliverToBoxAdapter(
                  child: SelectedColors(
                    colors: const [
                      Color(0xFFEA6262),
                      Color(0xFFB1CC63),
                      Color(0xFFFFBF5F),
                      Color(0xFF9FE1DD),
                      Color(0xFFC482DB),
                    ],
                    selectedColorIndex: _selectedColorIndex,
                    press: (value) {
                      setState(() {
                        _selectedColorIndex = value; // Update the selected color index
                      });
                    },
                  ),
                ),
                // Size Selection
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: const ["S", "M", "L", "XL", "XXL"],
                    selectedIndex: _selectedSizeIndex,
                    press: (value) {
                      setState(() {
                        _selectedSizeIndex = value; // Update the selected size index
                      });
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Size guide",
                    svgSrc: "assets/icons/Sizeguid.svg",
                    isShowBottomBorder: true,
                    press: () {},
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Select a size to check store availability and In-Store pickup options."),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "View details",
                    svgSrc: "assets/icons/Details.svg",
                    press: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LocationPermissonStoreAvailabilityScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

