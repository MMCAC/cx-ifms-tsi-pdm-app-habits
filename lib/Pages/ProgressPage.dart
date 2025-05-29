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


// Do chat

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DataBase/DatabaseHelper.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> todosHabitos = [];

  @override
  void initState() {
    super.initState();
    carregarHabitos();
  }

  Future<void> carregarHabitos() async {
    final habitos = await dbHelper.getHabits();
    setState(() {
      todosHabitos = habitos;
    });
  }

  List<DateTime> gerarDiasDoMesAtual() {
  final hoje = DateTime.now();
  final primeiroDia = DateTime(hoje.year, hoje.month, 1);
  final proximoMes = (hoje.month < 12)
      ? DateTime(hoje.year, hoje.month + 1, 1)
      : DateTime(hoje.year + 1, 1, 1);
  final ultimoDia = proximoMes.subtract(const Duration(days: 1));
  final totalDias = ultimoDia.day;

  return List.generate(totalDias, (i) => DateTime(hoje.year, hoje.month, i + 1));
}

  List<Map<String, dynamic>> filtrarHabitosPorData(String data) {
    return todosHabitos.where((habito) => habito['dataCriacao'] == data).toList();
  }

  int contarConcluidos(List<Map<String, dynamic>> lista) {
    return lista.where((h) => h['concluido'] == 1).length;
  }

  @override
  Widget build(BuildContext context) {
    final dias = gerarDiasDoMesAtual();

    return Scaffold(
      appBar: AppBar(
        title: Text('Progresso Diário'),
      ),
      body: ListView.builder(
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final data = DateFormat('yyyy-MM-dd').format(dias[index]);
          final habitosDoDia = filtrarHabitosPorData(data);
          final total = habitosDoDia.length;
          final concluidos = contarConcluidos(habitosDoDia);
          final progresso = total == 0 ? 0.0 : concluidos / total;

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(DateFormat('dd/MM/yyyy').format(dias[index])),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  LinearProgressIndicator(value: progresso),
                  SizedBox(height: 5),
                  Text('$concluidos de $total hábitos concluídos'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
