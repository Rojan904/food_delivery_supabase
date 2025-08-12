import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/screens/app_main_screen.dart';
import 'package:food_delivery_supabase/screens/auth/login_screen.dart';

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return AppMainScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
