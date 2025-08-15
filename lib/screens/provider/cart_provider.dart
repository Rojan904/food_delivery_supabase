import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;
  //calcu;ate tota; price
  double get totalPrice => _items.fold(
    0,
    (sum, item) => sum + ((item.productData['price'] ?? 0) * item.quantity),
  );
  CartProvider() {
    loadCart();
  }

  //load cart items
  Future<void> loadCart() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final response = await supabase
          .from('cart')
          .select()
          .eq('user_id', userId);
      _items = (response as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading cart: $e ');
    }
  }

  //add iatems in cart
  Future<void> addCart(
    String productId,
    Map<String, dynamic> productData,
    int quantity,
  ) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      //check if item already exist in supabase
      final existion = await supabase
          .from('cart')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existion != null) {
        //items exist-> update quamtity
        final newQuantity = (existion['quantity'] ?? 0) + quantity;
        await supabase
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('user_id', userId)
            .eq('product_id', productId);

        //also iupdate in local state
        final index = _items.indexWhere(
          (item) => item.productId == productId && item.userId == userId,
        );
        if (index != -1) {
          _items[index].quantity = newQuantity;
        }
      } else {
        //new item in the cart
        final response = await supabase.from('cart').insert({
          'product_id': productId,
          'product_data': productData,
          'quantity': quantity,
          'user_id': userId,
        }).select();

        if (response.isNotEmpty) {
          _items.add(
            CartItem(
              id: response.first['id'],
              productId: productId,
              productData: productData,
              quantity: quantity,
              userId: userId,
            ),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeItems(String itemId) async {
    try {
      await supabase.from('cart').delete().eq('id', itemId);
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    } catch (e) {
      print('Error ermoving item: $e');
    }
  }
}

final cartProvider = ChangeNotifierProvider((ref) => CartProvider());
