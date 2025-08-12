import 'package:flutter/material.dart';
import 'package:food_delivery_supabase/screens/auth/signup_screen.dart';
import 'package:food_delivery_supabase/screens/onboarding/onboarding_screen.dart';
import 'package:food_delivery_supabase/service/auth_service.dart';
import 'package:food_delivery_supabase/widgets/custom_button.dart';
import 'package:food_delivery_supabase/widgets/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController pwController;
  bool isLoading = false;
  bool isPasswordHidden = true;
  @override
  void initState() {
    emailController = TextEditingController();
    pwController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    final AuthService authService = AuthService();
    String email = emailController.text.trim();
    String pw = pwController.text.trim();
    if (!email.contains('.com')) {
      CustomSnackbar.showFailureSnackbar(context, 'Invalid email');
    }
    final result = await authService.login(email, pw);
    if (result == null) {
      if (!mounted) return;
      CustomSnackbar.showSuccessSnackbar(context, 'Logged in successfuly');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) {
            return OnboardingScreen();
          },
        ),
      );
    } else {
      if (!mounted) return;

      CustomSnackbar.showFailureSnackbar(context, 'Login failed: $result');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/signup.jpg',
                  width: double.infinity,
                  height: 500,
                  fit: BoxFit.cover,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  controller: pwController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: CustomButton(onTap: login, buttonText: 'Login'),
                      ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (builder) {
                            return SignupScreen();
                          },
                        ),
                      ),
                      child: Text(
                        'Signup Here',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
