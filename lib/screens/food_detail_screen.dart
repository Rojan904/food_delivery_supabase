import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/core/size_config.dart';
import 'package:food_delivery_supabase/models/product_model.dart';
import 'package:food_delivery_supabase/screens/provider/cart_provider.dart';
import 'package:food_delivery_supabase/widgets/custom_snackbar.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';
import 'package:readmore/readmore.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final FoodModel foodModel;
  const FoodDetailScreen({super.key, required this.foodModel});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPart(context),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: width,
            height: height,
            color: imageBg,
            child: Image.asset(
              'assets/food-delivery/food pattern.png',
              repeat: ImageRepeat.repeatY,
              color: imageBg2,
            ),
          ),
          Container(
            width: width,
            height: height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 1.3),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 90),
                  Center(
                    child: Hero(
                      tag: widget.foodModel.imageCard,
                      child: CachedNetworkImage(
                        imageUrl: widget.foodModel.imageDetail,
                        height: height * 0.320,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: kVerticalMargin * 2),
                  Center(
                    child: Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  quantity = quantity > 1 ? quantity - 1 : 1;
                                });
                              },
                              child: Icon(Icons.remove, color: Colors.white),
                            ),
                            SizedBox(width: kHorizontalMargin),
                            ResponsiveText(
                              quantity.toString(),
                              fontSize: 18,
                              textColor: Colors.white,
                            ),
                            SizedBox(width: kHorizontalMargin),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: kVerticalMargin * 2.4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            widget.foodModel.name,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          ResponsiveText(
                            widget.foodModel.specialItems,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            textColor: Colors.black,
                            letterSpacing: 1.1,
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: '\$',
                              style: TextStyle(color: red, fontSize: 14),
                            ),
                            TextSpan(
                              text: '${widget.foodModel.price}',

                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      foodInfo(
                        'assets/food-delivery/icon/star.png',
                        widget.foodModel.rate.toString(),
                      ),
                      foodInfo(
                        'assets/food-delivery/icon/fire.png',
                        "${widget.foodModel.kcal.toString()} kcal",
                      ),
                      foodInfo(
                        'assets/food-delivery/icon/time.png',
                        '${widget.foodModel.rate.toString()} min',
                      ),
                    ],
                  ),
                  SizedBox(height: kVerticalMargin * 1.4),
                  ReadMoreText(
                    desc,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {},
          label: MaterialButton(
            onPressed: () async {
              await ref
                  .read(cartProvider)
                  .addCart(
                    widget.foodModel.name,
                    widget.foodModel.toMap(),
                    quantity,
                  );
              if (context.mounted) {
                CustomSnackbar.showSuccessSnackbar(
                  context,
                  '${widget.foodModel.name} addd to cart',
                );
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            height: 55,
            color: red,
            minWidth: width * 0.9,
            child: ResponsiveText(
              'Add to Cart',
              textColor: Colors.white,
              fontSize: 18,
              letterSpacing: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Row foodInfo(image, value) {
    return Row(
      children: [
        Image.asset(image, width: kHorizontalMargin * 1.3),
        SizedBox(width: kHorizontalMargin * 0.7),
        ResponsiveText(
          value,
          fontWeight: FontWeight.w500,
          textColor: Colors.black,
        ),
      ],
    );
  }

  AppBar appBarPart(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 80,
      forceMaterialTransparency: true,
      actions: [
        SizedBox(width: kHorizontalMargin * 1.5),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18,
            ),
          ),
        ),
        Spacer(),

        Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Icon(Icons.more_horiz_rounded, color: Colors.black, size: 18),
        ),
        SizedBox(width: kHorizontalMargin * 1.5),
      ],
    );
  }
}
