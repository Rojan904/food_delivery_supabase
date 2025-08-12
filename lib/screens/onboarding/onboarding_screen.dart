import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/color_constants.dart';
import 'package:food_delivery_supabase/core/size_config.dart';
import 'package:food_delivery_supabase/models/on_bording_model.dart';
import 'package:food_delivery_supabase/screens/app_main_screen.dart';
import 'package:food_delivery_supabase/widgets/responsive_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              "assets/food-delivery/food pattern.png",
              color: imageBg2,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Positioned(
            top: -80,
            right: 0,
            left: 0,
            child: Image.asset("assets/food-delivery/chef.png", width: 80),
          ),
          Positioned(
            top: height * 0.15,
            right: 50,

            child: Image.asset("assets/food-delivery/leaf.png", width: 80),
          ),
          Positioned(
            top: height * 0.5,
            right: 40,

            child: Image.asset("assets/food-delivery/chili.png", width: 80),
          ),
          Positioned(
            top: height * 0.3,
            left: -20,
            child: Image.asset(
              "assets/food-delivery/ginger.png",
              height: 70,
              width: 70,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: CustomClip(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: kHorizontalMargin * 3,
                  vertical: kVerticalMargin * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height * 0.2,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (val) {
                          setState(() {
                            currentPage = val;
                          });
                        },
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final onboardingData = data[index];
                          return Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: getResponsiveFont(35),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: onboardingData['title1'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: onboardingData['title2'],
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: kVerticalMargin),
                              ResponsiveText(
                                onboardingData['description']!,
                                textAlign: TextAlign.center,

                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                textColor: Colors.black,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        data.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: currentPage == index ? 20 : 10,
                          height: 10,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.orange
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: kVerticalMargin * 2),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (__) => const AppMainScreen(),
                          ),
                        );
                      },
                      color: Colors.red,
                      height: height * 0.085,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ResponsiveText(
                        "Get started",
                        fontSize: 18,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 30);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30);
    path.quadraticBezierTo(size.width / 2, -30, 0, 30);
    path.close();
    return path;
  }
}
