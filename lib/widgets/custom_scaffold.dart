import 'package:flutter/material.dart';

import 'logo.dart';

class CustomScaffold extends StatelessWidget {
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final String title;
  final bool useLogo;

  const CustomScaffold({
    super.key,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.title = 'Contactos',
    this.useLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: useLogo
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Logo(size: 36),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(title),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        actions: actions,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Container(
        height: 44,
        color: theme.colorScheme.primary.withOpacity(0.1),
        alignment: Alignment.center,
        child: Text(
          '© 2025 Lista de contactos - Mateo Perez',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
