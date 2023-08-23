import 'package:flutter/material.dart';

class CustomListButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const CustomListButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.red),
        ));
  }
}
