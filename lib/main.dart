import 'package:exemplo_rotas/Home.dart';
import 'package:exemplo_rotas/Progress.dart';
import 'package:exemplo_rotas/FormHabit.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  final primaryColor = Color(0xFF151026);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) { 
          return Home();
        },
        '/FormHabit': (context) => FormHabit(),
        '/Progress': (context) => Progress(),
      }
    );
  }
}