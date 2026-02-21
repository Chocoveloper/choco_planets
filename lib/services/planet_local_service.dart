import 'dart:convert'; // Para convertir el texto en JSON
import 'package:flutter/services.dart'; // Para acceder al rootBundle
import '../models/planet_model.dart'; // Importamos su molde del Paso 3

class PlanetService {
  // Función asíncrona: No bloquea la app mientras lee el archivo
  Future<List<PlanetModelLocal>> loadPlanets() async {
    // 1. Cargamos el archivo como una cadena de texto (String)
    final String response = await rootBundle.loadString(
      'assets/data/planets.json',
    );

    // 2. Decodificamos el texto a una lista de objetos genéricos
    final List<dynamic> data = json.decode(response);

    // 3. Mapping: Convertimos cada elemento genérico en un objeto tipo Planet
    return data
        .map((jsonElement) => PlanetModelLocal.fromJson(jsonElement))
        .toList();
  }
}
