import 'package:flutter/material.dart';

import '../models/contactos.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/tarjeta_contactos.dart';

class PaginaFichaContacto extends StatelessWidget {
  final Contacto contacto;
  const PaginaFichaContacto({super.key, required this.contacto});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Ficha de contacto',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: TarjetaContactos(contacto: contacto),
      ),
    );
  }
}
