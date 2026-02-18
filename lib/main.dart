import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.brown),
      home: Scaffold(body: ChocoHomeSliver()),
    );
  }
}

class ChocoHomeSliver extends StatefulWidget {
  const ChocoHomeSliver({super.key});

  @override
  State<ChocoHomeSliver> createState() => _ChocoHomeSliverState();
}

class _ChocoHomeSliverState extends State<ChocoHomeSliver> {
  final ScrollController _scrollController = ScrollController();

  final List<String> planets = [
    'Mercury',
    'Venus',
    'Earth',
    'Mars',
    'Jupiter',
    'Saturn',
    'Uranus',
    'Neptune',
    'Pluto',
  ];

  final List<String> newPlanets = [
    'Aiur',
    'Char',
    'Kaldir',
    'Korhal IV',
    'Mar Sara',
    'Moria',
    'Skygeirr',
    'Tarsonis',
    'Zerus',
  ];
  // Función maestra para el scroll automático
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });


    //Limpiar el controlador

    @override
    void dispose() {
      _scrollController.dispose(); // Siempre limpiar el controlador
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          // 1. EL FIX ESTÉTICO: El padding inferior evita que la lista llegue hasta abajo
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 120.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: Container(
              // 2. DISEÑO DE CONSOLA: Bordes y sombras para contener la lista
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                // // 3. RECORTE GALÁCTICO: Los planetas desaparecen al llegar al borde redondeado
                borderRadius: BorderRadius.circular(25.0),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverAppBar(
                      centerTitle: true,
                      title: Text('Choco Planets'),
                      backgroundColor: Colors.brown,
                      pinned:
                          true, // Esto hace que no desaparezca el título al bajar
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(15.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          //return Text(planets[index]);
                          return Card(
                            elevation: 0.8,
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.brown.shade100,
                                child: const Icon(
                                  Icons.rocket,
                                  color: Colors.brown,
                                  size: 20.0,
                                ),
                              ),
                              title: Text(
                                planets[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    planets.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_sweep,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          );
                        }, childCount: planets.length),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 30)),
                    SliverToBoxAdapter(
                      child: const SizedBox(
                        height: 100.0,
                      ), // espacio controlado
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'add_choco',
              //Este botón añade la frase hay un nuevo Choco-Planeta y continua el conteo
              onPressed: () {
                setState(() {
                  planets.add(
                    'Hay un nuevo Choco-Planeta ${planets.length + 1}',
                  );
                  _scrollToBottom();
                });
              },

              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 15.0),

            FloatingActionButton(
              //Este botón añade un nuevo planeta de la lista newPlanets
              //Usando una condición if para que no se repita ningún planeta
              //Y cuando ya no existan más planetas muestre un mensaje al usuario a través de un SnackBar
              heroTag: 'add_koprulu',
              backgroundColor: Colors.brown[300],
              onPressed: () {
                setState(() {
                  if (newPlanets.isNotEmpty) {
                    String planetaExtraido = newPlanets.removeAt(0);
                    planets.add(planetaExtraido);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No hay más planetas para añadir.'),
                      ),
                    );
                  }
                  _scrollToBottom();
                });
              },

              child: const Icon(Icons.rocket),
            ),
          ],
        ),
      ),
    );
  }
}
