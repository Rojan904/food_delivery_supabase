import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/core/size_config.dart';
import 'package:food_delivery_supabase/models/product_model.dart';
import 'package:food_delivery_supabase/screens/food_detail_screen.dart';
import 'package:food_delivery_supabase/screens/provider/favorie_provider.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';

class ProductsItem extends ConsumerWidget {
  const ProductsItem({super.key, required this.foodModel});
  final FoodModel foodModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(favoriteProvider);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (_, ___, __) => FoodDetailScreen(foodModel: foodModel),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            child: Container(
              height: height * 0.180,
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    spreadRadius: 10,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                ref.read(favoriteProvider).toggleFavorite(foodModel.name);
              },

              child: CircleAvatar(
                radius: 15,
                backgroundColor: provider.isExist(foodModel.name)
                    ? Colors.red[100]
                    : Colors.transparent,
                child: provider.isExist(foodModel.name)
                    ? Image.asset(
                        'assets/food-delivery/icon/fire.png',
                        height: 22,
                      )
                    : Icon(Icons.local_fire_department_rounded, color: red),
              ),
            ),
          ),
          Container(
            width: width * 0.5,
            padding: EdgeInsets.symmetric(
              horizontal: kHorizontalMargin * 1.3,
              vertical: kVerticalMargin * 1.3,
            ),
            child: Column(
              children: [
                Hero(
                  tag: foodModel.imageCard,
                  child: CachedNetworkImage(
                    imageUrl: foodModel.imageCard,
                    height: height * 0.140,
                    width: width * 0.150,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
                  child: ResponsiveText(
                    foodModel.name,
                    maxLines: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black,
                  ),
                ),
                ResponsiveText(
                  foodModel.specialItems,
                  height: 0.1,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  textColor: Colors.black,
                ),
                SizedBox(height: kVerticalMargin * 2),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '\$',
                        style: TextStyle(fontSize: 14, color: red),
                      ),
                      TextSpan(
                        text: '${foodModel.price}',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ],
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
