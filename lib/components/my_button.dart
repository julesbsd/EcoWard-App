import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color color;
  final Color textColor;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.inversePrimary,
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(text,
              style: TextStyle(
                  fontSize: 20, color: textColor, fontFamily: 'Raleway')),
        ),
      ),
    );
  }
}
