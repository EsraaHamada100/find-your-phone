import 'package:flutter/material.dart';

import '../colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: secondaryColor, fontSize: 20, ),
      ),
    );
  }
}
