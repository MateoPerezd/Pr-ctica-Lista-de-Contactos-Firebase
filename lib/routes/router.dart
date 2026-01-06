import 'package:go_router/go_router.dart';
import '../pages/pagina_principal.dart';
import '../pages/pagina_datoscontacto.dart';
import '../models/contactos.dart'; 
import '../pages/pagina_editarcontacto.dart';
import '../pages/pagina_fichacontacto.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PaginaPrincipal(),
    ),
     GoRoute(
      path: '/contacto/nuevo',
      builder: (context, state) => const PaginaDatosContacto(),
    ),
     GoRoute(
      path: '/contacto/editar',
      builder: (context, state) {
        final contacto = state.extra as Contacto; // en editar siempre va el contacto ya creado
        return PaginaEditarContacto(contacto: contacto);
      },
    ),
    GoRoute(
      path: '/contacto/ficha',
      builder: (context, state) {
        final contacto = state.extra as Contacto;
        return PaginaFichaContacto(contacto: contacto);
      },
    ),
  ],
);
