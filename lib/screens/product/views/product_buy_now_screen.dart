import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecomprj/components/cart_button.dart';
import 'package:ecomprj/components/custom_modal_bottom_sheet.dart';
import 'package:ecomprj/components/network_image_with_loader.dart';
import 'package:ecomprj/screens/product/views/added_to_cart_message_screen.dart';
import 'package:ecomprj/screens/product/views/components/product_list_tile.dart';
import 'package:ecomprj/screens/product/views/location_permission_store_availability_screen.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int _itemCount = 1; // State variable to keep track of item count

  void _incrementItemCount() {
    setState(() {
      _itemCount++;
    });
  }

  void _decrementItemCount() {
    if (_itemCount > 1) { // Prevent count from going below 1
      setState(() {
        _itemCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: 269.4,
        title: "Add to cart",
        subTitle: "Total price",
        press: () {
          // Here you can pass the _itemCount to the cart provider if needed
          customModalBottomSheet(
            context,
            isDismissible: false,
            child: const AddedToCartMessageScreen(items: [],),
          );
        },
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
                  onPressed: () {},
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
                          numOfItem: _itemCount, // Pass the current count
                          onIncrement: _incrementItemCount, // Increment function
                          onDecrement: _decrementItemCount, // Decrement function
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: SelectedColors(
                    colors: const [
                      Color(0xFFEA6262),
                      Color(0xFFB1CC63),
                      Color(0xFFFFBF5F),
                      Color(0xFF9FE1DD),
                      Color(0xFFC482DB),
                    ],
                    selectedColorIndex: 2,
                    press: (value) {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: const ["S", "M", "L", "XL", "XXL"],
                    selectedIndex: 1,
                    press: (value) {},
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                            "Select a size to check store availability and In-Store pickup options.")
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Check stores",
                    svgSrc: "assets/icons/Stores.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const LocationPermissonStoreAvailabilityScreen(),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }
}
