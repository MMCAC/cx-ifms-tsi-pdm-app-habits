import 'package:flutter/material.dart';
import '../DataBase/DatabaseHelper.dart';

class FormHabit extends StatefulWidget {
  @override
  _FormHabitState createState() => _FormHabitState();
}

class _FormHabitState extends State<FormHabit> {
  final TextEditingController _habitNameController = TextEditingController();
  final Map<String, bool> _daysSelected = {
    'Todos os dias': false,
    'Dom': false,
    'Seg': false,
    'Ter': false,
    'Qua': false,
    'Qui': false,
    'Sex': false,
    'Sáb': false,
  };

  String? _selectedEmoji;

  void _selectEmoji() {
    final List<String> emojis = ['🍎', '💪', '📚', '🛌', '🚰', '🧘‍♀️', '🥗', '🚶‍♂️'];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: EdgeInsets.all(16),
          itemCount: emojis.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedEmoji = emojis[index];
                });
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  emojis[index],
                  style: TextStyle(fontSize: 30),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveHabit() async {
  String habitName = _habitNameController.text;
  List<String> selectedDays = _daysSelected.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  if (habitName.isEmpty || selectedDays.isEmpty || _selectedEmoji == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha o nome, selecione um emoji e pelo menos um dia.')),
    );
    return;
  }

  Map<String, dynamic> newHabit = {
    'nome': habitName,
    'emoji': _selectedEmoji,
    'dias': selectedDays.join(','),
    'concluido': 0,
    'ultimaAtualizacao': null,
  };

  try {
    int id = await DatabaseHelper().insertHabit(newHabit);
    print('Hábito inserido com id $id');

    // Mostra o SnackBar de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hábito salvo com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Aguarda 2 segundos para que o usuário veja o SnackBar
    await Future.delayed(Duration(seconds: 2));

    // Volta para a tela anterior
    Navigator.pop(context, null);
  } catch (e) {
    print('Erro ao salvar hábito: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao salvar hábito.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Hábito'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _habitNameController,
              decoration: InputDecoration(
                labelText: 'Nome do Hábito',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Emoji:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _selectEmoji,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedEmoji ?? 'Escolher emoji',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Dias da Semana:', style: TextStyle(fontSize: 16)),
            Wrap(
  spacing: 8,
  children: _daysSelected.keys.map((day) {
    return FilterChip(
      label: Text(day),
      selected: _daysSelected[day]!,
      onSelected: (selected) {
        setState(() {
          if (day == 'Todos os dias') {
            // Seleciona ou desseleciona todos os dias
            _daysSelected.updateAll((key, value) => selected);
          } else {
            // Atualiza apenas o dia selecionado
            _daysSelected[day] = selected;

            // Se algum dia for desmarcado, desmarca 'Todos os dias'
            if (!selected) {
              _daysSelected['Todos os dias'] = false;
            } else {
              // Se todos os dias da semana estiverem selecionados, marca 'Todos os dias'
              bool allDaysSelected = _daysSelected.entries
                  .where((entry) => entry.key != 'Todos os dias')
                  .every((entry) => entry.value);
              _daysSelected['Todos os dias'] = allDaysSelected;
            }
          }
        });
      },
    );
  }).toList(),
),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Salvar Hábito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}