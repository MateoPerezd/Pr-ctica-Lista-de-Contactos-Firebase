class Contacto {
  String ? id;
  String categoria; // Trabajo/Personal/Otros
  String nombre;
  String apellido1;
  String? apellido2;
  String telefono;
  String? telefonoOpcional;
  String email;
  bool esFavorito;

  Contacto({
    this.id,
    required this.categoria,
    required this.nombre,
    required this.apellido1,
    this.apellido2,
    required this.telefono,
    this.telefonoOpcional,
    required this.email,
    this.esFavorito = false,
  });

  Map<String, dynamic> toJson() => {
        
        'categoria': categoria,
        'nombre': nombre,
        'primerApellido': apellido1,
        'segundoApellido': apellido2,
        'telefono': telefono,
        'telefono2': telefonoOpcional,
        'correo': email,
        'favorito': esFavorito,
      };

  factory Contacto.fromJson(Map<String, dynamic> json, {String? id}) {
    return Contacto(
      id: id,
      categoria: (json['categoria'] ?? 'Otros') as String,
      nombre: (json['nombre'] ?? '') as String,
      apellido1: (json['primerApellido'] ?? '') as String,
      apellido2: json['segundoApellido'] as String?,
      telefono: (json['telefono'] ?? '') as String,
      telefonoOpcional: json['telefono2'] as String?,
      email: (json['correo'] ?? '') as String,
      esFavorito: (json['favorito'] ?? false) as bool,
    );
  }
}
