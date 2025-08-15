import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/core/size_config.dart';
import 'package:food_delivery_supabase/screens/provider/cart_provider.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    var discountPrice = cart.totalPrice * 0.1;
    var grandTotal = (cart.totalPrice - discountPrice + 2.99).toStringAsFixed(
      2,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: ResponsiveText('Your Cart', fontSize: 16),
      ),
      body: cart.items.isEmpty
          ? Center(child: ResponsiveText('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final items = cart.items[index];
                      return Dismissible(
                        key: Key(items.id),
                        onDismissed: (_) => cart.removeItems(items.id),
                        background: Container(color: red),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: items.productData['imageCard'] ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: ResponsiveText(
                            items.productData['name'],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          subtitle: ResponsiveText(
                            '\$${items.productData['price']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: items.quantity > 1
                                    ? () {
                                        cart.addCart(
                                          items.productId,
                                          items.productData,
                                          -1,
                                        );
                                      }
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: kHorizontalMargin / 2,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(8),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                    horizontal: BorderSide(),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: kHorizontalMargin * 0.8,
                                    vertical: 2.5,
                                  ),
                                  child: ResponsiveText(
                                    '${items.quantity}',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  cart.addCart(
                                    items.productId,
                                    items.productData,
                                    1,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: kHorizontalMargin / 2,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(8),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        title: ResponsiveText(
                          "Total",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: ResponsiveText(
                          '\$ ${cart.totalPrice.toStringAsFixed(2)}',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ListTile(
                        title: ResponsiveText(
                          "Shipping Charge",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: ResponsiveText(
                          '(+) \$2.99',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ListTile(
                        title: ResponsiveText(
                          "Discount",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: ResponsiveText(
                          '(-) 10% = \$ ${discountPrice.toStringAsFixed(2)}',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),

                      ListTile(
                        title: ResponsiveText(
                          "Grand Total",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          textColor: red,
                        ),
                        trailing: ResponsiveText(
                          '\$$grandTotal',
                          fontSize: 20,
                          textColor: red,
                          fontWeight: FontWeight.bold,
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
