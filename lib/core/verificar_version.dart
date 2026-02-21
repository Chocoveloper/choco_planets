import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  // Reemplace 'SuUsuario' por su nombre real de GitHub
  static const String _urlJson =
      "https://raw.githubusercontent.com/Chocoveloper/choco_planets/refs/heads/master/version.json";

  static Future<Map<String, dynamic>?> checkUpdate() async {
    try {
      final response = await http.get(Uri.parse(_urlJson));
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Comparamos versión instalada vs versión en la nube
        if (data['latest_version'] != packageInfo.version) {
          return data; // Retornamos todo el mapa con la URL y notas
        }
      }
    } catch (e) {
      //print("Error en el radar de Choco_Planets: $e");
    }
    return null; // Si son iguales o hay error, no hay actualización
  }
}
