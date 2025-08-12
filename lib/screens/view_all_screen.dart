import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/models/product_model.dart';
import 'package:food_delivery_supabase/widgets/products_item.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  List<FoodModel> products = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase.from('food_product').select();
      final data = response as List;
      setState(() {
        products = data.map((json) => FoodModel.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error feching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: ResponsiveText('All Products'),
        backgroundColor: Colors.blue[50],
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.59,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (ctx, index) {
                return ProductsItem(foodModel: products[index]);
              },
            ),
    );
  }
}
