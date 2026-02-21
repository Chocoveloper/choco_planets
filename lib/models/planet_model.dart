class PlanetModelLocal {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final double ra; // Right Ascension
  final double dec; // Declination

  // El Constructor: Define cómo se crea un objeto de este tipo
  PlanetModelLocal({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.ra,
    required this.dec,
  });

  // El Factory Constructor: El motor que convierte el JSON en un objeto Dart
  factory PlanetModelLocal.fromJson(Map<String, dynamic> json) {
    return PlanetModelLocal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['image_path'], // Mapping del nombre en el JSON al código
      ra: json['ra'],
      dec: json['dec'],
    );
  }
}
