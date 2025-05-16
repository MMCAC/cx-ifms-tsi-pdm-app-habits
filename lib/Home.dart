import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  final primaryColor = Color.fromARGB(255, 0, 79, 197);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hábitos", style: TextStyle(fontSize: 30.0, color: const Color.fromARGB(255, 0, 79, 197), fontWeight: FontWeight.w900, fontFamily: "Reboto")), backgroundColor: primaryColor, toolbarHeight: 100 ,),
      body: Center(child: Text("Pag. Home"),),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Center(child: Text("Maicon"))),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Criar Hábito"),
              onTap: () {
                Navigator.pushNamed(context, '/FormHabit');
              },
            ),
             ListTile(
              leading: Icon(Icons.open_with),
              title: Text("Progresso"),
              onTap: () {
                Navigator.pushNamed(context, '/Progress');
              },
            )
          ],
        ),
      ),
    );
  }
}