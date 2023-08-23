import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final void Function()? onPressed;
  final Color? color;
  const CustomButton({super.key, required this.onPressed, this.color});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(widget.color ?? Colors.red)),
          onPressed: widget.onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 8),
            child: Text("Submit"),
          )),
    );
  }
}

class Length extends StatelessWidget {
  final String length;
  const Length({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(100)),
      child: Text(
        length,
        style: TextStyle(color: Colors.grey.shade300),
      ),
    );
  }
}
