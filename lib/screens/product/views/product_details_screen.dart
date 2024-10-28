import 'package:ecomprj/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ecomprj/components/cart_button.dart';
import 'package:ecomprj/components/custom_modal_bottom_sheet.dart';
import 'package:ecomprj/components/product/product_card.dart';
import 'package:ecomprj/constants.dart';
import 'package:ecomprj/screens/product/views/product_returns_screen.dart';

import 'package:ecomprj/route/screen_export.dart';
import 'package:provider/provider.dart';
import 'package:ecomprj/providers/cart_provider.dart';
import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, this.isProductAvailable = true});

  final bool isProductAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isProductAvailable
          ? CartButton(
              price: 140,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductBuyNowScreen(),
                );
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(ProductModel as ProductModel);
                Navigator.pushNamed(context, '/cart');
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {

              },
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
            const ProductImages(
              images: [productDemoImg1, productDemoImg2, productDemoImg3],
            ),
            ProductInfo(
              brand: "LIPSY LONDON",
              title: "Sleeveless Ruffle",
              isAvailable: isProductAvailable,
              description:
                  "A cool gray cap in soft corduroy. Watch me.' By buying cotton products from Lindex, you’re supporting more responsibly...",
              rating: 4.4,
              numOfReviews: 126,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const Text("Hello"),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.3,
                  numOfReviews: 128,
                  numOfFiveStar: 80,
                  numOfFourStar: 30,
                  numOfThreeStar: 5,
                  numOfTwoStar: 4,
                  numOfOneStar: 1,
                ),
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(context, productReviewsScreenRoute);
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == 4 ? defaultPadding : 0),
                    child: ProductCard(
                      image: productDemoImg2,
                      title: "Sleeveless Tiered Dobby Swing Dress",
                      brandName: "LIPSY LONDON",
                      price: 24.65,
                      priceAfetDiscount: index.isEven ? 20.99 : null,
                      dicountpercent: index.isEven ? 25 : null,
                      press: () {},
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
