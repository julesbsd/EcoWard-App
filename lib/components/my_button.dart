import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color color;
  final Color textColor;
  final Widget? child;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.textColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-6.0, -6.0),
              blurRadius: 16.0,
            ),
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(5.0, 6.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(5),
        child: Center(
          child: child ??
              Text(
                  // Utiliser child s'il existe, sinon utiliser le texte
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Raleway')),
        ),
      ),
    );
  }
}
