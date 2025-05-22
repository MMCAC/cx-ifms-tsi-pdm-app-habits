// import "package:exemplo_rotas/controllers/SettingsController.dart";
// import "package:flutter/material.dart";
// import "package:provider/provider.dart";

// class HomePage extends StatefulWidget{
//   final VoidCallback toggleTheme;
  
//   const HomePage({required this.toggleTheme});

//   @override
//   State<HomePage> createState() {
//     return _HomePageState();
//   }
// }

// class _HomePageState extends State<HomePage>{
//   @override
//   Widget build(BuildContext context) {
//     final settings = context.watch<SettingsController>().settings;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HÁBITOS'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.brightness_6),
//             onPressed: widget.toggleTheme,
//           ),
//         ],
//       ),

//       drawer: Drawer(
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Color.fromARGB(255, 0, 79, 197)),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.person, size: 50, color: Colors.white),
//                     Text('Maicon', style: TextStyle(fontSize: 20, color: Colors.white)),
//                   ],
//                 ),
//               ),
//             ),

//             Expanded(
//               child: ListView(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.data_saver_on),
//                     title: Text("Criar Hábito"),
//                     onTap: () {
//                       Navigator.pushNamed(context, '/FormHabit');
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.list),
//                     title: Text("Progresso"),
//                     onTap: () {
//                       Navigator.pushNamed(context, '/Progress');
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             Divider(height: 1),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text("Configurações"),
//               onTap: () {
//                 Navigator.pushNamed(context, '/Settings');
//               },
//             ),
//           ],
//         ),
//       ),



//       body: Column(
//         children:[
//           // Pelo que vi, expande um filho para que ele caiba todo na tela
//           Expanded(
//             child: Container(
//               color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
//               child: Center(
//                 child: Text('Hábitos para Fazer', style: TextStyle(fontSize: 20),),
//               ),
//             ),
//           ),

//           Divider(height: 1),

//           Expanded(
//             child: Container(
//               color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.0),
//               child: Center(
//                 child: Text('Hábitos Feitos', style: TextStyle(fontSize: 20),)
//               ),
//             ),
//           ),

//         ],
//       )
//     );
//   }
// }

// Do chat
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/SettingsController.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>().settings;

    return Scaffold(
      appBar: AppBar(
        title: Text('HÁBITOS'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: settings.color),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(settings.icon, size: 50, color: Colors.white),
                    Text(settings.name, style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.data_saver_on),
                    title: Text("Criar Hábito"),
                    onTap: () {
                      Navigator.pushNamed(context, '/FormHabit');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list),
                    title: Text("Progresso"),
                    onTap: () {
                      Navigator.pushNamed(context, '/Progress');
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
              onTap: () {
                Navigator.pushNamed(context, '/Settings');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.0),
              child: Center(
                child: Text('Hábitos para Fazer', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.0),
              child: Center(
                child: Text('Hábitos Feitos', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
