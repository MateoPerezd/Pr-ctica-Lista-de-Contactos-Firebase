import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/contactos_provider.dart';
import 'routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // asegurarse de que todo esté listo para inicializar Firebase
  await dotenv.load(fileName: ".env");   
  await Firebase.initializeApp(    // inicializar Firebase
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
    ),
  );

   runApp(
  ChangeNotifierProvider(
    create: (_) => ContactosProvider()
      ..load()
      ..cargarTema(),
    child: const MyApp(),
  ),
);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ContactosProvider>(context);
  
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Proyecto - Lista de contactos',
      theme: ThemeData(
        primaryColor: const Color(0xFF84DE71),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF84DE71),
          secondary: Color(0xFF3FAB35),
          surface: Color(0xFFFFFFFF),
          onPrimary: Color(0xFF2D3748),
          onSecondary: Color(0xFFF5F7FA),
          onSurface: Color(0xFF2D3748),
          error: Color(0xFFE53E3E),
        ),
        ),
 
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF3FAB35),
        scaffoldBackgroundColor: const Color(0xFF1A202C),
        colorScheme: const ColorScheme.dark(
          primary: const Color(0xFF3FAB35),
          secondary: Color(0xFF84DE71),
          surface: Color(0xFF2D3748),
          onPrimary: Color(0xFFF5F7FA),
          onSecondary: Color(0xFF1A202C),
          onSurface: Color(0xFFF5F7FA),
          error: Color(0xFFE53E3E),
        ),
      ),
      themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      
      routerConfig: router,
    );
  }
}
