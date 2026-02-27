import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/planet_cloud_model.dart';
import '../theme/choco_colors.dart';

class ChocoPlanetDetail extends StatefulWidget {
  final PlanetModelCloud planet;

  const ChocoPlanetDetail({super.key, required this.planet});

  @override
  State<ChocoPlanetDetail> createState() => _ChocoPlanetDetailState();
}

class _ChocoPlanetDetailState extends State<ChocoPlanetDetail> {
  // Variable para saber si mostramos el 3D o la imagen normal
  bool _show3D = false;

  @override
  Widget build(BuildContext context) {
    final planetName = widget.planet.name.toLowerCase();
    final double zoomLevel = planetName.contains('saturn')
        ? 2.1
        : (planetName.contains('urano') || planetName.contains('uranus'))
        ? 1.6
        : 1.0;
    final double rotationZ = planetName.contains('saturn') ? -0.8 : 0.0;

    return Scaffold(
      backgroundColor: ChocoColor.spaceBlack,
      extendBodyBehindAppBar: true, // Para que la imagen suba hasta el borde
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. FONDO DE ESTRELLAS (Lottie)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0B0D17), // Negro azulado arriba
                    Color(0xFF1E1E2C), // Un poco más claro abajo
                  ],
                ),
              ),
            ),
          ),

          // 2. CONTENIDO PRINCIPAL
          Column(
            children: [
              const SizedBox(height: 80), // Espacio para el AppBar
              // --- ZONA VISUAL (Imagen o 3D) ---
              SizedBox(
                height: 350,
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 600,
                  ), // Duración de la transición
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: _show3D
                      ? Stack(
                          key: const ValueKey('view3D'),
                          children: [
                            // 1. Cargador circular en lugar del Astronauta Lottie
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors
                                    .amber, // Color visible en fondo oscuro
                              ),
                            ),
                            // 2. El Visor 3D: Escalado y rotación forzada
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.diagonal3Values(
                                zoomLevel,
                                zoomLevel,
                                zoomLevel,
                              )..rotateZ(rotationZ),
                              child: ModelViewer(
                                backgroundColor: Colors.transparent,
                                src: widget.planet.image3d,
                                alt: "Modelo 3D de ${widget.planet.name}",
                                ar: false, // Desactiva el botón de Realidad Aumentada (círculo con cubo)
                                autoRotate: true,
                                autoRotateDelay: 0,
                                cameraControls: true,
                                disableZoom: false,
                                // Estos atributos obligan al visor a acercarse lo máximo posible internamente
                                cameraOrbit: 'auto auto auto',
                                fieldOfView: 'auto',
                              ),
                            ),
                          ],
                        )
                      : Hero(
                          key: const ValueKey('view2D'),
                          tag: widget.planet.name,
                          // Reducimos el tamaño de la imagen 2D a petición del usuario
                          child: Transform.scale(
                            scale: 0.6, // Reducido de 0.85 a 0.6
                            child: Image.network(
                              widget
                                  .planet
                                  .image2d, // Usamos el link de la nube
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.red[400],
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    'assets/images/${widget.planet.name.toLowerCase()}.png',
                                  ),
                            ),
                          ),
                        ),
                ),
              ),

              // --- ZONA DE INFORMACIÓN ---
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.3,
                    ), // Fondo semitransparente
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // TÍTULO
                        Text(
                          widget.planet.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          widget.planet.name == 'Pluto'
                              ? 'Planeta Enano'
                              : 'Planeta del Sistema Solar', // Subtítulo (podemos agregarlo a Firebase luego)

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // BOTÓN DE ACCIÓN
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _show3D = !_show3D; // Alternar entre 2D y 3D
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ChocoColor.marsRed, // Rojo Marte
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              shadowColor: const Color(
                                0xFFD64444,
                              ).withValues(alpha: 0.5),
                            ),
                            child: Text(
                              _show3D ? "Volver a Imagen 2D" : "Explorar en 3D",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // FILA DE ESTADÍSTICAS (Estilo Kimi)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard(
                              icon: Icons.speed,
                              value: "${widget.planet.velocity} km/s",
                              label: "Velocidad",
                            ),
                            _buildStatCard(
                              icon: Icons.thermostat,
                              value: widget
                                  .planet
                                  .temperature, // Dato quemado (falta en Firebase)
                              label: "Temp.",
                            ),
                            _buildStatCard(
                              icon: Icons.rule,
                              value: "${widget.planet.distance} M",
                              label: "Distancia",
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // DESCRIPCIÓN
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Descripción",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.planet.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para las tarjetas (El secreto del diseño)
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C), // Color gris oscuro de las tarjetas
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}
