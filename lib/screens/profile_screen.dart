import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_supabase/screens/provider/cart_provider.dart';
import 'package:food_delivery_supabase/screens/provider/favorie_provider.dart';
import 'package:food_delivery_supabase/service/auth_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                authService.logout(context);
                ref.invalidate(favoriteProvider);
                ref.invalidate(cartProvider);
              },
              child: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}
