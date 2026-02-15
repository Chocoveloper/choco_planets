import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  static final List<String> planets = [
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

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choco Planets',
      home: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Choco Planets')),
        body: Center(
          child: ListView.builder(
            itemCount: planets.length,
            itemBuilder: (context, index){
              return Text(planets[index]);
            },
          ),
        ),
      ),
    );
  }
}
