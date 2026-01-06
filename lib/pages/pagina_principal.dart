import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/contactos.dart';
import '../providers/contactos_provider.dart';
import '../widgets/custom_scaffold.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  void _compartirContacto(Contacto c) {
    final texto = '''
${c.nombre} ${c.apellido1}${c.apellido2 != null ? ' ${c.apellido2}' : ''}
Tel: ${c.telefono}
${c.telefonoOpcional != null && c.telefonoOpcional!.isNotEmpty ? 'Tel opcional: ${c.telefonoOpcional}\n' : ''}
Email: ${c.email}
Categoría: ${c.categoria}
''';
    Share.share(texto.trim());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactosProvider>();

    return CustomScaffold(
      useLogo: true,
      title: 'Lista de contactos',
      actions: [
        Switch(
          value: provider.isDarkTheme,
          onChanged: provider.alternarTema,
          activeThumbColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/contacto/nuevo'),
        icon: const Icon(Icons.person_add),
        label: const Text('Crear contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
           const SizedBox(height: 12),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: provider.filtroCategoria,
              decoration: const InputDecoration(
                
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Todos', child: Text('Todas las categorías')),
                DropdownMenuItem(value: 'Favoritos', child: Text('Favoritos')),
                DropdownMenuItem(value: 'Trabajo', child: Text('Trabajo')),
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Otros', child: Text('Otros')),
              ],
              onChanged: (value) {
                if (value != null) provider.cambiarFiltroCategoria(value);
              },
            ),
            const SizedBox(height: 12),
             TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre o correo',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => provider.cambiarBusqueda(value),
            ),
            const SizedBox(height: 12),
            const Divider(height: 28),
            const Text(
              'Contactos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (provider.loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (provider.contactos.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contact_page,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No hay contactos, agrega tu primer contacto.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.contactosFiltrados.length,
                  itemBuilder: (context, index) {
                    final c = provider.contactosFiltrados[index];
                    
                    return Card(
                      child: ListTile(
                        onTap: () => context.push('/contacto/ficha', extra: c),
                        leading: CircleAvatar(
                          child: Icon(  
                            Icons.person,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          
                        ),
                        title: Text('${c.nombre} ${c.apellido1} - ${c.categoria}'),
                        subtitle: Text(c.email),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              tooltip: c.esFavorito ? 'Quitar de favoritos' : 'Marcar favorito',
                              icon: Icon(
                                c.esFavorito ? Icons.star : Icons.star_border,
                                color: c.esFavorito ? Theme.of(context).colorScheme.secondary : null,
                              ),
                              onPressed: () => provider.alternarFavorito(c),
                            ),
                            IconButton(
                              tooltip: 'Compartir',
                              icon: const Icon(Icons.share),
                              onPressed: () => _compartirContacto(c),
                            ),
                            IconButton(
                              tooltip: 'Editar',
                              icon: const Icon(Icons.edit),
                              onPressed: () => context.push('/contacto/editar', extra: c),
                            ),
                            IconButton(
                              tooltip: 'Eliminar',
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                if (c.id == null || c.id!.isEmpty) return;
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Eliminar contacto'),
                                    content: const Text('¿Seguro que quieres eliminar este contacto?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('No'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Sí'),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok == true) {
                                  await context.read<ContactosProvider>().deleteContacto(c.id!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
