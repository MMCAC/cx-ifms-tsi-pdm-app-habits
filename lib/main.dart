import 'package:exemplo_rotas/Home.dart';
import 'package:exemplo_rotas/TelaA.dart';
import 'package:exemplo_rotas/TelaB.dart';
import 'package:exemplo_rotas/TelaC.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) { 
          return Home();
        },
        '/telaA': (context) => TelaA(),
        '/telaB': (context) => TelaB(),
      }
    );
  }
}