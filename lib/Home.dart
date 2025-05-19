import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'Habito.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final primaryColor = const Color.fromARGB(255, 0, 79, 197);
  List<Habito> habitos = [];

  @override
  void initState() {
    super.initState();
    carregarHabitos();
  }

  Future<void> carregarHabitos() async {
    final db = DatabaseHelper();
    final maps = await db.getHabits();

    setState(() {
      habitos = maps.map((e) => Habito.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitosConcluidos = habitos.where((h) => h.concluido).toList();
    final habitosPendentes = habitos.where((h) => !h.concluido).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hábitos",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontFamily: "Roboto",
          ),
        ),
        backgroundColor: primaryColor,
        toolbarHeight: 100,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 79, 197)),
              child: Center(
                child: Text(
                  "Maicon",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Criar Hábito"),
              onTap: () {
                Navigator.pushNamed(context, '/FormHabit').then((_) => carregarHabitos());
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text("Progresso"),
              onTap: () {
                Navigator.pushNamed(context, '/Progress');
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: carregarHabitos,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Hábitos Pendentes:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...habitosPendentes.map((h) => ListTile(
                  title: Text('${h.emoji ?? ''} ${h.nome ?? ''}'),
                  trailing: const Icon(Icons.hourglass_bottom),
                )),
            const SizedBox(height: 20),
            const Text(
              "Hábitos Concluídos:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...habitosConcluidos.map((h) => ListTile(
                  title: Text('${h.emoji ?? ''} ${h.nome ?? ''}'),
                  trailing: const Icon(Icons.check),
                )),
          ],
        ),
      ),
    );
  }
}