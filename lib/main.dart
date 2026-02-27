import 'package:choco_planets/screens/choco_splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 2. Aseguramos que Flutter esté listo para hablar con el sistema nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 3. ¡Encendemos los motores de Firebase!
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueAccent),
      title: 'Choco Sistema Solar',
      home: const ChocoSplash(),
    );
  }
}
