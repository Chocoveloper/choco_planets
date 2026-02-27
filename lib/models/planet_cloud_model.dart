class PlanetModelCloud {
  final String id;
  final String name;
  final String description;
  final String image2d; // URL 2D de Cloudinary
  final String image3d; // URL 3D de Cloudinary
  final double velocity;
  final double distance; // Guardado como número puro
  final double ra;
  final double dec;
  final String temperature;

  PlanetModelCloud({
    required this.id,
    required this.name,
    required this.description,
    required this.image2d,
    required this.image3d,
    required this.velocity,
    required this.distance,
    required this.ra,
    required this.dec,
    required this.temperature,
  });

  // El motor que traduce de Firebase a Dart
  factory PlanetModelCloud.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return PlanetModelCloud(
      id: docId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image2d: json['image2d'] ?? '',
      image3d: json['image3d'] ?? '',
      velocity: (json['velocity'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      ra: (json['ra'] as num?)?.toDouble() ?? 0.0,
      dec: (json['dec'] as num?)?.toDouble() ?? 0.0,
      temperature:
          json['temperature'] ?? 'N/A', // Si no hay temperatura, se pone N/A
    );
  }
}
