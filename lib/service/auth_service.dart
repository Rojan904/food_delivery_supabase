import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/core/constants/app_constant.dart';
import 'package:food_delivery_supabase/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<String?> signup(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        password: password,
        email: email,
      );
      if (response.user != null) {
        return null; //indeicate success
      } else {
        return "An error occured";
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error :$e";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user != null) {
        return null; //indeicate success
      } else {
        return "Invalid email or password.";
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error :$e";
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) {
            return LoginScreen();
          },
        ),
      );
    } catch (e) {
      print("Logout error $e");
    }
  }
}
