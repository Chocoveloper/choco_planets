import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:choco_planets/models/planet_model.dart';

class ChocoPlanetDetail extends StatefulWidget {
  final PlanetModelLocal planet;
  const ChocoPlanetDetail({super.key, required this.planet});

  @override
  State<ChocoPlanetDetail> createState() => _ChocoPlanetDetailState();
}

class _ChocoPlanetDetailState extends State<ChocoPlanetDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0D17),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.brown[900],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.planet.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                  fontFamily: 'Times New Roman',
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withValues(alpha: 0.2),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: 'planet-${widget.planet.name}',
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        // Calculamos un factor de escala basado en el giro
                        // Esto hace que se agrande un 10% cuando está de frente
                        double rotationValue =
                            _rotationController.value * 2 * 3.141592;
                        double scale =
                            1.0 + (Math.sin(rotationValue).abs() * 0.1);

                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // Perspectiva
                            ..rotateY(rotationValue) // Giro horizontal
                            ..scale(scale), // ¡El truco de la escala!
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Image.asset(
                          'assets/images/${widget.planet.name}.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Sección de contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Información Galáctica',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      widget.planet.description,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 30),

                    //Una fila para los datos técnicos (RA y DEC)
                    Wrap(
                      spacing: 30.0,
                      //runSpacing: 30.0,
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        _buildDataCard('RA', widget.planet.ra.toString()),
                        _buildDataCard('DEC', widget.planet.dec.toString()),
                      ],
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pequeño Widget de ayuda para mostrar los datos técnicos
  Widget _buildDataCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.brown[200], fontSize: 12)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
