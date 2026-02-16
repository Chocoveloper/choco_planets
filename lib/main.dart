import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: ChocoHome(),
      ),
    );
  }
}

class ChocoHome extends StatefulWidget {
  const ChocoHome({super.key});

  @override
  State<ChocoHome> createState() => _ChocoHomeState();
}

class _ChocoHomeState extends State<ChocoHome> {
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
        appBar: AppBar(centerTitle: true, title: const Text('Choco Planets')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: size * 0.1,
                vertical: 25.0,
              ),
              itemCount: planets.length,
              itemBuilder: (context, index) {
                return Text(planets[index]);
              },
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
                  planets.add(
                    'Hay un nuevo Choco-Planeta ${planets.length + 1}',
                  );
                });
              },
              heroTag: 'ChocoPlanets',
              child: Icon(Icons.add),
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
                        content: Text('No hay más planetas para añadir'),
                      ),
                    );
                  }
                });
              },
              heroTag: 'Sector Kropulu',
              child: Icon(Icons.abc),
            ),
          ],
        ),
      );
  }
}
