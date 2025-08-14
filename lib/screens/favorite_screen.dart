import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/core/size_config.dart';
import 'package:food_delivery_supabase/models/product_model.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = supabase.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: ResponsiveText('Favorites', fontWeight: FontWeight.bold),
      ),
      body: userId == null
          ? Center(child: ResponsiveText('Please login to view favorites'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('favorites')
                  .stream(primaryKey: ['id'])
                  .eq('userId', userId)
                  .map((data) => data.cast<Map<String, dynamic>>()),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final favorites = snapshot.data!;
                if (favorites.isEmpty) {
                  return Center(child: ResponsiveText('No facorites yet'));
                }
                return FutureBuilder(
                  future: _fetchFavoriteItems(favorites),
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final favItems = snapshot.data!;
                    if (favItems.isEmpty) {
                      return Center(child: ResponsiveText('No facorites yet'));
                    }
                    return ListView.builder(
                      itemBuilder: (ctx, index) {
                        final FoodModel items = favItems[index];
                        return Stack(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: kHorizontalMargin,
                                vertical: 5,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            items.imageCard,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Padding(
                                            padding: EdgeInsetsGeometry.only(
                                              right: 20,
                                            ),
                                            child: ResponsiveText(
                                              items.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          ResponsiveText(items.category),
                                          ResponsiveText(
                                            '\$ ${items.price}.00',
                                            fontWeight: FontWeight.w600,
                                            textColor: Colors.pink,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                child: Icon(Icons.delete, color: red, size: 25),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Future<List<FoodModel>> _fetchFavoriteItems(
    List<Map<String, dynamic>> favorites,
  ) async {
    final List<String> productNames = favorites
        .map((fav) => fav['product_id'].toString())
        .toList();
    if (productNames.isEmpty) return [];

    try {
      final response = await supabase
          .from('food_product')
          .select()
          .inFilter('name', productNames);
      if (response.isEmpty) return [];
    } catch (e) {
      print('Error fetching $e');
      return [];
    }
    return [];
  }
}
