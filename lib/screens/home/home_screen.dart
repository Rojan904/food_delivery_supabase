import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/core/size_config.dart';
import 'package:food_delivery_supabase/models/categories_model.dart';
import 'package:food_delivery_supabase/models/product_model.dart';
import 'package:food_delivery_supabase/screens/view_all_screen.dart';
import 'package:food_delivery_supabase/widgets/products_item.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CategoryModel>> futureCategories = fetchCategories();
  late Future<List<FoodModel>> futureProducts = Future.value([]);
  List<CategoryModel> categoryList = [];
  String? selectedCategory;
  @override
  void initState() {
    _initialozeData();
    super.initState();
  }

  void _initialozeData() async {
    try {
      final categories = await futureCategories;
      if (categories.isNotEmpty) {
        setState(() {
          categoryList = categories;
          selectedCategory = categoryList.first.name;
          futureProducts = fetchProducts(selectedCategory!);
        });
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  Future<List<FoodModel>> fetchProducts(String category) async {
    try {
      final response = await supabase
          .from('food_product')
          .select()
          .eq('category', category);
      print(response);
      return response.map((product) => FoodModel.fromJson(product)).toList();
    } catch (e) {
      print("Error feching products: $e");
      return [];
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await supabase.from('category_items').select();
      print(response);
      return (response).map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      print("Error feching categories: $e");
    }
    return [];
  }

  void handleCategoryOnTap(String category) {
    if (selectedCategory == category) return;
    setState(() {
      selectedCategory = category;
      futureProducts = fetchProducts(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: homeScreenAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kHorizontalMargin,
                vertical: kVerticalMargin * 1.3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBanner(),
                  SizedBox(height: kVerticalMargin * 1.4),
                  ResponsiveText(
                    "Categories",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            _buildCategoryList(),
            SizedBox(height: kVerticalMargin * 1.6),
            viewAll(),
            SizedBox(height: kVerticalMargin * 1.6),
            _buildProductSection(),
            SizedBox(height: kVerticalMargin),
          ],
        ),
      ),
    );
  }

  _buildProductSection() {
    return FutureBuilder(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error : ${snapshot.error}'));
        }
        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return Center(child: Text('No products found'));
        }
        return SizedBox(
          height: height * 0.33,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, idx) {
              final product = products[idx];
              return Padding(
                padding: EdgeInsets.only(
                  left: kHorizontalMargin,
                  right: idx == products.length - 1 ? kHorizontalMargin : 0,
                ),
                child: ProductsItem(foodModel: product),
              );
            },
          ),
        );
      },
    );
  }

  Padding viewAll() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveText(
            'Popular Now',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewAllScreen()),
              );
            },
            child: Row(
              children: [
                ResponsiveText('View All', textColor: orange),
                SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // color: Colors.white,
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCategoryList() {
    return FutureBuilder(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }
        return SizedBox(
          height: height * 0.075,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, idx) {
              final category = categoryList[idx];
              return Padding(
                padding: EdgeInsets.only(
                  left: idx == 0 ? kHorizontalMargin : 0,
                  right: kHorizontalMargin,
                ),
                child: GestureDetector(
                  onTap: () => handleCategoryOnTap(category.name),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalMargin,
                      // vertical: kVerticalMargin,
                    ),
                    decoration: BoxDecoration(
                      color: selectedCategory == category.name ? red : grey1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedCategory == category.name
                                ? Colors.white
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            category.image,
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.fastfood),
                          ),
                        ),
                        SizedBox(width: kHorizontalMargin),
                        ResponsiveText(
                          category.name,
                          fontSize: 16,
                          textColor: selectedCategory == category.name
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Container appBanner() {
    return Container(
      height: height * 0.21,
      decoration: BoxDecoration(
        color: imageBg,

        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.only(top: 25, right: 25, left: 25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: 'The Fastest In Delivery',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: ' Food',
                        style: TextStyle(color: red),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: kHorizontalMargin,
                    vertical: 9,
                  ),
                  child: ResponsiveText("Order Now", textColor: Colors.white),
                ),
              ],
            ),
          ),
          Image.asset('assets/food-delivery/courier.png'),
        ],
      ),
    );
  }

  AppBar homeScreenAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        SizedBox(width: width * 0.035),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kHorizontalMargin / 1.3,
            vertical: kVerticalMargin / 1.3,
          ),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            "assets/food-delivery/icon/dash.png",
            height: 15,
            width: 20,
          ),
        ),
        Spacer(),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 18, color: red),

            SizedBox(width: 5),
            ResponsiveText(
              "Kathmandu,Nepal",
              fontSize: 16,
              textColor: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: orange),
          ],
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kHorizontalMargin / 1.3,
            vertical: kVerticalMargin / 1.3,
          ),
          decoration: BoxDecoration(
            color: grey1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            "assets/food-delivery/profile.png",
            height: 15,
            width: 15,
          ),
        ),
        SizedBox(width: kHorizontalMargin * 1.5),
      ],
    );
  }
}
