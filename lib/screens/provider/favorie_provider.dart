import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';

final favoriteProvider = ChangeNotifierProvider<FavoriteProvider>(
  (ref) => FavoriteProvider(),
);

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  List<String> get favorite => _favoriteIds;
  String? get userId => supabase.auth.currentUser?.id;
  FavoriteProvider();

  void reset() {
    _favoriteIds = [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await removeFavorite(productId);
    } else {
      _favoriteIds.add(productId);
      await addFavorite(productId);
    }
    notifyListeners();
  }

  //check if product is favorite
  bool isExist(String productId) {
    return _favoriteIds.contains(productId);
  }

  //add fav to supabase
  Future<void> addFavorite(String productId) async {
    if (userId == null) return;
    try {
      await supabase.from('favorite').insert({
        "user_id": userId,
        "product_id": productId,
      });
    } catch (e) {
      print("Error adding to favorute, $e");
    }
  }

  //remove forom supabase
  Future<void> removeFavorite(String productId) async {
    try {
      await supabase.from('favorite').delete().match({
        "user_id": userId!,
        "product_id": productId,
      });
    } catch (e) {
      print("Error removing from favorute, $e");
    }
  }

  Future<void> loadFavorites() async {
    if (userId == null) return;
    try {
      final data = await supabase
          .from('favorite')
          .select('product_id')
          .eq('user_id', userId!);
      _favoriteIds = data.map((row) => row['product_id'] as String).toList();
    } catch (e) {
      print('Error loading favorite:$e');
    }
    notifyListeners();
  }
}
