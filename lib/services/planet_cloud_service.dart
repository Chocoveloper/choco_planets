import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planet_cloud_model.dart';

class PlanetCloudService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PlanetModelCloud>> getPlanets() {
    // Quitamos el .orderBy temporalmente para probar
    return _db.collection('planets').snapshots().map((snapshot) {
      // DEBU
      return snapshot.docs.map((doc) {
        return PlanetModelCloud.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
