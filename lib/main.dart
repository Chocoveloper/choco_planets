import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                centerTitle: true,
                title: Text('Choco Planets'),
                backgroundColor: Colors.brown,
                pinned: true, // Esto hace que no desaparezca el título al bajar
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.fromLTRB(
                  size * 0.05,
                  20.0,
                  size * 0.05,
                  120.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    //return Text(planets[index]);
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              planets.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                        ),
                      ),
                    );
                  }, childCount: planets.length),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //Este botón añade la frase hay un nuevo Choco-Planeta y continua el conteo
            onPressed: () {
              setState(() {
                planets.add('Hay un nuevo Choco-Planeta ${planets.length + 1}');
              });
            },
            heroTag: 'ChocoPlanets',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            //Este botón añade un nuevo planeta de la lista newPlanets
            //Usando una condición if para que no se repita ningún planeta
            //Y cuando ya no existan más planetas muestre un mensaje al usuario a través de un SnackBar
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
              });
            },
            heroTag: 'Sector Kropulu',
            child: const Icon(Icons.abc),
          ),
        ],
      ),
    );
  }
}
