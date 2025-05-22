import 'package:provider/provider.dart';
import 'package:exemplo_rotas/Pages/SettingsPage.dart';
import 'package:exemplo_rotas/controllers/SettingsController.dart';
import 'package:exemplo_rotas/models/UserSettings.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Pages/FormHabit.dart';

void main() {

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState(){
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{

  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(){
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(toggleTheme: _toggleTheme),
        '/FormHabit': (context) => FormHabit(),
        '/Settings': (context) => SettingsPage(),
      },
    );
  }
}















// class MyApp extends StatelessWidget {
  

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hábitos',
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: _themeMode, //ThemeData(primarySwatch: Colors.blue)
//       initialRoute: '/',
//       routes: {
//         '/': (context) => HomePage(),
//         '/FormHabit': (context) => FormHabit(),
//       },
//     );
//   }

//   ThemeData myTheme(){
//     return ThemeData(

//     );
//   }
// }