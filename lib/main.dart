import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/screens/auth/auth_check_screen..dart';
import 'package:food_delivery_supabase/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();

  await Supabase.initialize(anonKey: supabseAnonKey, url: supabaseUrl);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthCheckScreen(),
    );
  }
}
