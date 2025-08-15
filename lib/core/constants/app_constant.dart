import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/screens/cart_screen.dart';
import 'package:food_delivery_supabase/screens/favorite_screen.dart';
import 'package:food_delivery_supabase/screens/home/home_screen.dart';
import 'package:food_delivery_supabase/screens/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final List<Widget> pages = [
  HomeScreen(),
  FavoriteScreen(),
  ProfileScreen(),
  CartScreen(),
];
