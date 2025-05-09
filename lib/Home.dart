import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hábitos")),
      body: Center(child: Text("Pag. Home"),),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Center(child: Text("Maicon"))),
            ListTile(
              leading: Icon(Icons.data_saver_on),
              title: Text("Hábitos"),
              onTap: (){
                Navigator.pushNamed(context, '/telaA');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Criar Hábito"),
              onTap: () {
                Navigator.pushNamed(context, '/telaB');
              },
            ),
             ListTile(
              leading: Icon(Icons.open_with),
              title: Text("Progresso"),
              onTap: () {
                Navigator.pushNamed(context, '/telaC');
              },
            )
          ],
        ),
      ),
    );
  }
}