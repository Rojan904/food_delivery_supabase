import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
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
                  future: _fetchFavoriteItems(),
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
                        return Stack(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: kHorizontalMargin,
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

  Future<List<FoodModel>> _fetchFavoriteItems() {
    return [];
  }
}
