import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
class MyApp extends StatefulWidget {

  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

  final size = MediaQuery.of(context).size.width;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choco Planets',
      home: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Choco Planets')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: size * 0.1, vertical: 25.0),
              itemCount: planets.length,
              itemBuilder: (context, index) {
                return Text(planets[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
