import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final void Function() onPressed;

  const CircleButton({super.key, required this.size, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        child: MaterialButton(
          padding: const EdgeInsets.all(8),
          shape: const CircleBorder(),
          color: Theme.of(context).colorScheme.primary,
          onPressed: onPressed,
          child: Icon(icon, size: size - 16),
        ),
      );
}
