import 'package:choco_planets/core/verificar_version.dart';
import 'package:choco_planets/models/planet_model.dart';
import 'package:choco_planets/screens/choco_planet_detail.dart';
import 'package:choco_planets/services/planet_local_service.dart';
import 'package:choco_planets/widgets/planet_grild.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChocoHome extends StatefulWidget {
  const ChocoHome({super.key});

  @override
  State<ChocoHome> createState() => _ChocoHomeState();
}

class _ChocoHomeState extends State<ChocoHome> {
  final PlanetService _planetService = PlanetService();
  late Future<List<PlanetModelLocal>> _planetsFuture;

  @override
  void initState() {
    super.initState();
    // Ejecutamos el chequeo después de que el primer frame se dibuje
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyUpdate();
    });
    _planetsFuture = _planetService.loadPlanets();
  }

  // Método para consultar al servicio de versión
  void _verifyUpdate() async {
    final updateAvailable = await VersionService.checkUpdate();

    if (updateAvailable != null && mounted) {
      _showUpdateDialog(
        url: updateAvailable['url_download'],
        version: updateAvailable['latest_version'],
      );
    }
  }

  // El diálogo que verá el usuario
  void _showUpdateDialog({required String url, required String version}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ), // Un poco más estrecho para 480px
          child: SingleChildScrollView(
            // <--- ¡EL SALVAVIDAS!
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Que use el mínimo espacio posible
                children: [
                  // Reducimos el tamaño del contenedor del cohete
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🚀', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    '¡Actualización!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Versión $version',
                    style: TextStyle(fontSize: 13, color: Colors.brown[400]),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Nueva versión disponible',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // Botones un poco más compactos
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final Uri downloadUri = Uri.parse(url);
                        if (!await launchUrl(
                          downloadUri,
                          mode: LaunchMode.externalApplication,
                        )) {
                          debugPrint("Error de enlace");
                        }
                      },
                      child: const Text(
                        'Actualizar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Luego',
                      style: TextStyle(color: Colors.brown[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int columns = width > 600 ? 5 : 3;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      body: FutureBuilder<List<PlanetModelLocal>>(
        future: _planetsFuture,
        builder: (context, snapshot) {
          // 1. Si está cargando (ni ha empezado ni ha fallado)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Si hubo un error (no encontró el archivo, etc.)
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar planetas',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // 3. Si todo salió bien, ¡mostramos la parrilla!
          // snapshot.data es la lista de planetas que devolvió el servicio
          final planets = snapshot.data!;

          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: EdgeInsetsGeometry.all(15.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // Usamos el nombre del planeta del JSON
                    return PlanetGridColumn(
                      name: planets[index].name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChocoPlanetDetail(planet: planets[index]),
                          ),
                        );
                      },
                    );
                  }, childCount: planets.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'Choco Universe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            color: Color.fromARGB(255, 52, 3, 60),
          ),
        ),
        background: Container(color: Colors.brown[600]),
      ),
    );
  }
}
