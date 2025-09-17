import 'package:flutter/material.dart';

class FloatyButton extends StatelessWidget {
  final VoidCallback func;
  final Icon icon;
  final String heroTag;


  const FloatyButton({
    super.key,
    required this.func,
    required this.icon,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: func,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: icon,
    );
  }
}