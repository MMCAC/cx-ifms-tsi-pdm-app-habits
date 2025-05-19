// import 'package:flutter/material.dart';
// import 'DatabaseHelper.dart';
// import 'Habito.dart';

// class Progress extends StatefulWidget {
//   @override
//   State<Progress> createState() => _ProgressState();
// }

// class _ProgressState extends State<Progress> {
//   List<Habito> habitos = [];
//   final dbHelper = DatabaseHelper();

//   @override
//   void initState() {
//     super.initState();
//     _loadProgress();
//   }

//   void _loadProgress() async {
//     var data = await dbHelper.getHabitos();
//     setState(() {
//       habitos = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Progresso Total")),
//       body: ListView.builder(
//         itemCount: habitos.length,
//         itemBuilder: (context, index) {
//           final h = habitos[index];
//           return ListTile(
//             title: Text(h.nome ?? ''),
//             subtitle: LinearProgressIndicator(
//               value: h.concluido ? 1.0 : 0.0,
//               minHeight: 10,
//               backgroundColor: Colors.grey[300],
//               color: h.concluido ? Colors.green : Colors.red,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }