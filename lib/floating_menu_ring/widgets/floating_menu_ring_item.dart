import 'package:flutter/material.dart';

class FloatingMenuRingItem extends StatelessWidget {
  FloatingMenuRingItem({
    @required this.icon,
    @required this.onPressed,
    this.color = Colors.green,
  });

  final Function onPressed;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: icon.codePoint,
      backgroundColor: color,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
