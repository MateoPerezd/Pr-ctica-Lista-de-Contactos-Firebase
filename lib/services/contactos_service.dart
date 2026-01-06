import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contactos.dart';

class ContactosService {
  final _col = FirebaseFirestore.instance.collection('listacontactos');

  Future<List<Contacto>> getAll() async {
    final snap = await _col.get();
    return snap.docs.map((d) => Contacto.fromJson(d.data(), id: d.id)).toList();
  }

  Future<String> add(Contacto c) async {
    final doc = _col.doc();
    await doc.set(c.toJson());
    return doc.id;
  }

  Future<void> update(Contacto c) async {
    if (c.id == null || c.id!.isEmpty) {
      throw Exception('Contacto sin id (docId)');
    }
    await _col.doc(c.id).set(c.toJson());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
