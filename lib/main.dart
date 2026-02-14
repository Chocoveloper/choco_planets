import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choco Planets',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Choco Planets')),
        body: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            children: [
              Text('Mercury'),
              Text('Venus'),
              Text('Earth'),
              Text('Mars'),
              Text('Jupiter'),
              Text('Saturn'),
              Text('Uranus'),
              Text('Neptune'),
              Text('Pluto'),
            ],
          ),
        ),
      ),
    );
  }
}
