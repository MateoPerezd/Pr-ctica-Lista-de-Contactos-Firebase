import 'package:flutter/material.dart';

/// Placeholder logo for the contactos app while no asset is provided.
class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: size,
      width: size,
      
      child: Center(
        child: Icon(
          Icons.contacts,
          color: theme.colorScheme.onPrimary,
          size: size * 0.65,
        ),
      ),
    );
  }
}
