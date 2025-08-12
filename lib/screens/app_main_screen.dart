import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';
import 'package:iconsax/iconsax.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItems(Iconsax.home_15, "A", 0),
                SizedBox(width: 10),
                _buildNavItems(Iconsax.heart, "B", 1),
                SizedBox(width: 90),
                _buildNavItems(Icons.person_outline, "C", 2),
                SizedBox(width: 10),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildNavItems(Iconsax.shopping_cart, "D", 3),
                    Positioned(
                      right: -7,
                      top: 7,
                      child: CircleAvatar(
                        backgroundColor: red,
                        radius: 10,
                        child: ResponsiveText(
                          '0',
                          fontSize: 12,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              left: 0,
              top: -25,
              child: CircleAvatar(
                backgroundColor: red,
                radius: 30,
                child: Icon(
                  CupertinoIcons.search,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildNavItems(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: currentIndex == index ? Colors.red : Colors.grey,
          ),
          SizedBox(height: 3),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentIndex == index ? red : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
