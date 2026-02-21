import 'dart:math';
import 'package:flutter/material.dart';

class PlanetGridColumn extends StatefulWidget {
  final String name;
  final VoidCallback? onTap;
  const PlanetGridColumn({super.key, required this.name, this.onTap});

  @override
  State<PlanetGridColumn> createState() => _PlanetGridColumnState();
}

class _PlanetGridColumnState extends State<PlanetGridColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Generamos un número aleatorio entre 0 y 1
    final random = Random(); // Creamos un generador de números aleatorios

    final int randomDuration =
        2500 +
        random.nextInt(
          2000,
        ); // Genera un número entre 2500 y 4500 milisegundos Así, unos planetas flotarán más lento que otros.

    // 3. Inicializamos el controlador (el cerebro del movimiento)
    _controller = AnimationController(
      vsync: this, // Aquí usamos el Mixin para sincronizar con la pantalla
      duration: Duration(
        milliseconds: randomDuration,
      ), // Tiempo que tarda en subir y bajar
    )..repeat(reverse: true);

    _floatAnimation =
        Tween<double>(
          begin: -05.0, // Sube 10 píxeles
          end: 5.0, // Baja 10 píxeles
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut, // La curva de la elegancia galáctica
          ),
        );
    // ¡Que se repita infinitamente y de ida y vuelta!
  }

  @override
  void dispose() {
    _controller.dispose(); // ¡Limpiamos la memoria cuando ya no se usa!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Detectamos si es Saturno para darle un "boost" de tamaño
    final bool isSaturn = widget.name == 'Saturn';

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          // Usamos Expanded para que el círculo ocupe el espacio disponible
          // sin salirse de su columna de la cuadrícula
          Expanded(
            child: AspectRatio(
              aspectRatio:
                  1.0, // Esto garantiza que siempre sea un círculo perfecto
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: Transform.scale(
                      // 2. Si es Saturno, lo agrandamos un 20% (1.2)
                      scale: isSaturn ? 1.2 : 1.0,
                      child: Hero(
                        tag: 'planet-${widget.name}',
                        child: Container(
                          decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                            color: Colors.transparent,
                            boxShadow: const [],
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/${widget.name}.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,

              overflow: TextOverflow.ellipsis,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
