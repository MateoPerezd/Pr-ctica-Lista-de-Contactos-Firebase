import 'package:flutter/material.dart';

import '../models/contactos.dart';

class TarjetaContactos extends StatelessWidget {
  final Contacto contacto;
  const TarjetaContactos({super.key, required this.contacto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _dato(String label, String valor, IconData icono) {
      return ListTile(
        leading: Icon(icono, color: theme.colorScheme.primary),
        title: Text(label, style: theme.textTheme.labelMedium),
        subtitle: Text(valor, style: theme.textTheme.bodyLarge),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${contacto.nombre} ${contacto.apellido1}${contacto.apellido2 != null && contacto.apellido2!.isNotEmpty ? ' ${contacto.apellido2}' : ''}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (contacto.esFavorito)
                      Icon(Icons.star, color: theme.colorScheme.secondary),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Categoría: ${contacto.categoria}',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ],
            ),
          ),
          _dato('Correo', contacto.email, Icons.email),
          _dato('Teléfono', contacto.telefono, Icons.phone),
          if (contacto.telefonoOpcional != null &&
              contacto.telefonoOpcional!.isNotEmpty)
            _dato('Teléfono opcional', contacto.telefonoOpcional!, Icons.phone_callback),
          _dato(
            'Apellidos',
            '${contacto.apellido1}${contacto.apellido2 != null && contacto.apellido2!.isNotEmpty ? ' ${contacto.apellido2}' : ''}',
            Icons.badge,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
