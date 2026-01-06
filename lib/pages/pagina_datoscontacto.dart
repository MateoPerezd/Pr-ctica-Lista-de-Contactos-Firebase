import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/contactos.dart';
import '../providers/contactos_provider.dart';

class PaginaDatosContacto extends StatefulWidget {
  const PaginaDatosContacto({super.key});

  @override
  State<PaginaDatosContacto> createState() => _PaginaDatosContactoState();
}

class _PaginaDatosContactoState extends State<PaginaDatosContacto> {
  final _formKey = GlobalKey<FormState>();

  String _categoria = 'Otros';

  final _nombreCtrl = TextEditingController();
  final _ap1Ctrl = TextEditingController();
  final _ap2Ctrl = TextEditingController();
  final _tel1Ctrl = TextEditingController();
  final _tel2Ctrl = TextEditingController();
  final _correoCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _ap1Ctrl.dispose();
    _ap2Ctrl.dispose();
    _tel1Ctrl.dispose();
    _tel2Ctrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final nuevo = Contacto(
      categoria: _categoria,
      nombre: _nombreCtrl.text.trim(),
      apellido1: _ap1Ctrl.text.trim(),
      apellido2: _ap2Ctrl.text.trim().isEmpty ? null : _ap2Ctrl.text.trim(),
      telefono: _tel1Ctrl.text.trim(),
      telefonoOpcional: _tel2Ctrl.text.trim().isEmpty ? null : _tel2Ctrl.text.trim(),
      email: _correoCtrl.text.trim(),
    );

    await context.read<ContactosProvider>().addContacto(nuevo);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ContactosProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear contacto')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _categoria,
                items: prov.categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoria = v ?? 'Otros'),
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nombre obligatorio' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ap1Ctrl,
                decoration: const InputDecoration(
                  labelText: 'Primer apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Primer apellido' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ap2Ctrl,
                decoration: const InputDecoration(
                  labelText: 'Segundo apellido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _tel1Ctrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Teléfono obligatorio';
                  if (t.length != 9) return 'Debe tener 9 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _tel2Ctrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return null;
                  if (t.length != 9) return 'Debe tener 9 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _correoCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final e = (v ?? '').trim();
                  if (e.isEmpty) return 'Correo obligatorio';
                  if (!e.contains('@') || !e.contains('.')) return 'Correo no válido';
                  return null;
                },
              ),
              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar contacto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
