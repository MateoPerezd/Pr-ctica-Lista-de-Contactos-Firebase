import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contactos.dart';
import '../services/contactos_service.dart';

class ContactosProvider extends ChangeNotifier {
  final _service = ContactosService();
  bool isDarkTheme = false;
  bool get getisDarkTheme => isDarkTheme; 

  final categorias = const ['Trabajo', 'Personal', 'Otros'];

  String _filtroCategoria = 'Todos';
  String get filtroCategoria => _filtroCategoria;

  String _busqueda = '';
  String get busqueda => _busqueda;

  List<Contacto> _contactos = [];
  List<Contacto> get contactos => _contactos;

  List<Contacto> get contactosFiltrados {
    final list = (_filtroCategoria == 'Todos')
        ? List<Contacto>.from(_contactos)
        : _filtroCategoria == 'Favoritos'
            ? _contactos.where((c) => c.esFavorito).toList()
            : _contactos.where((c) => c.categoria == _filtroCategoria).toList();
     
      if (_busqueda.isNotEmpty) {
      final q = _busqueda.toLowerCase();
      list.retainWhere((c) {  //  
        final nombreCompleto =   
            '${c.nombre} ${c.apellido1} ${c.apellido2 ?? ''}'.toLowerCase();  
        return nombreCompleto.contains(q) || c.email.toLowerCase().contains(q); 
      });
    }

    list.sort((a, b) {
      if (a.esFavorito == b.esFavorito) {
        return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()); // Orden alfabético
      }
      return a.esFavorito ? -1 : 1; // Favoritos primero
    });
    return list;
  }

  bool _loading = false;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _contactos = await _service.getAll();  

    _loading = false;
    notifyListeners();
  }

  Future<void> addContacto(Contacto contacto) async {
    final id = await _service.add(contacto);
    contacto.id = id;
    _contactos.add(contacto);
    notifyListeners();
  }

  Future<void> updateContacto(Contacto contacto) async {
    await _service.update(contacto);

    final i = _contactos.indexWhere((x) => x.id == contacto.id);
    if (i != -1) {
      _contactos[i] = contacto;
      notifyListeners();
    }
  }

  Future<void> alternarFavorito(Contacto contacto) async {  
    final actualizado = Contacto(
      id: contacto.id,
      categoria: contacto.categoria,
      nombre: contacto.nombre,
      apellido1: contacto.apellido1,
      apellido2: contacto.apellido2,
      telefono: contacto.telefono,
      telefonoOpcional: contacto.telefonoOpcional,
      email: contacto.email,
      esFavorito: !contacto.esFavorito,
    );
    await updateContacto(actualizado);
  }

  Future<void> deleteContacto(String id) async {
    await _service.delete(id);
    _contactos.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void cambiarFiltroCategoria(String categoria) {
    _filtroCategoria = categoria;
    notifyListeners();
  }

  void cambiarBusqueda(String texto) {
    _busqueda = texto;
    notifyListeners();
  }

  Future<void> cargarTema() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  Future<void> alternarTema(bool value) async {
    isDarkTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
    notifyListeners();
  }
}
