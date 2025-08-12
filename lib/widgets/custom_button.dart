import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.color = Colors.blueAccent,
  });
  final VoidCallback onTap;
  final String buttonText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
