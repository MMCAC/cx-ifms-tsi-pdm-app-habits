import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/SettingsController.dart';
import '../DataBase/DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<int> _habitosEmEdicao = {};

  // Estados de edição separados por hábito
  Map<int, String> _emojiEmEdicao = {};
  Map<int, Set<String>> _diasEmEdicao = {};
  List<Map<String, dynamic>> _habitosParaFazer = [];
  List<Map<String, dynamic>> _habitosFeitos = [];

  final GlobalKey<AnimatedListState> _keyParaFazer = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _keyFeitos = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await DatabaseHelper().getHabits();

    setState(() {
      _habitosParaFazer = habits.where((h) => h['concluido'] == 0).toList();
      _habitosFeitos = habits.where((h) => h['concluido'] == 1).toList();
    });
  }

  void _deleteHabit(int id) async {
    await DatabaseHelper().deleteHabit(id);
    _loadHabits();
  }

  void _editHabit(int id) {
  setState(() {
    if (_habitosEmEdicao.contains(id)) {
      _habitosEmEdicao.remove(id); // cancela edição
    } else {
      _habitosEmEdicao.add(id); // ativa edição
    }
  });
}

  void _toggleConcluido(Map<String, dynamic> habit) async {
    final novoStatus = habit['concluido'] == 0 ? 1 : 0;
    final habitAtualizado = {...habit, 'concluido': novoStatus};

    await DatabaseHelper().updateHabit(habitAtualizado);
    _loadHabits();
  }

  Widget _buildHabitCard(Map<String, dynamic> habit) {
  bool concluido = habit['concluido'] == 1;
  bool emEdicao = _habitosEmEdicao.contains(habit['id']);

  // Controladores para edição
  final TextEditingController nomeController = TextEditingController(text: habit['nome']);
  // Emoji e dias serão controlados por variáveis locais
  String emojiSelecionado = habit['emoji'] ?? '😀';

  // Para os dias, suponho que seja uma string separada por vírgulas, ex: "Seg,Ter,Qua"
  List<String> diasSemana = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  Set<String> diasSelecionados = habit['dias'] != null
      ? habit['dias'].toString().split(',').map((e) => e.trim()).toSet()
      : <String>{};

  return Card(
    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: emEdicao
          ? StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown de Emoji
                    DropdownButtonFormField<String>(
                      value: emojiSelecionado,
                      decoration: InputDecoration(labelText: 'Emoji'),
                      items: ['😀', '📚', '💪', '🧘‍♂️', '🚴‍♂️', '🍎'].map((emoji) {
                        return DropdownMenuItem(
                          value: emoji,
                          child: Text(emoji, style: TextStyle(fontSize: 24)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => emojiSelecionado = value);
                        }
                      },
                    ),

                    // Campo nome
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),

                    SizedBox(height: 12),

                    Text('Dias', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: diasSemana.map((dia) {
                        final selecionado = diasSelecionados.contains(dia);
                        return FilterChip(
                          label: Text(dia),
                          selected: selecionado,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                diasSelecionados.add(dia);
                              } else {
                                diasSelecionados.remove(dia);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () => _editHabit(habit['id']),
                        ),
                        ElevatedButton(
                          child: Text('Salvar'),
                          onPressed: () async {
                            final atualizado = {
                              'id': habit['id'],
                              'nome': nomeController.text,
                              'emoji': emojiSelecionado,
                              'dias': diasSelecionados.join(','),
                              'concluido': habit['concluido'],
                            };
                            await DatabaseHelper().updateHabit(atualizado);
                            _editHabit(habit['id']);
                            _loadHabits();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
          : ListTile(
              leading: Checkbox(
                value: concluido,
                onChanged: (_) => _toggleConcluido(habit),
              ),
              title: Text(
                "${habit['emoji'] ?? ''} ${habit['nome']}",
                style: TextStyle(
                  decoration: concluido ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text("Dias: ${habit['dias']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editHabit(habit['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteHabit(habit['id']),
                  ),
                ],
              ),
            ),
    ),
  );
}


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
                      Navigator.pushNamed(context, '/FormHabit').then((_) => _loadHabits());
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
          // Hábitos para fazer
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Hábitos para Fazer', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _habitosParaFazer.length,
                      itemBuilder: (context, index) {
                        return _buildHabitCard(_habitosParaFazer[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 1),

          // Hábitos feitos
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Hábitos Feitos', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _habitosFeitos.length,
                      itemBuilder: (context, index) {
                        return _buildHabitCard(_habitosFeitos[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}