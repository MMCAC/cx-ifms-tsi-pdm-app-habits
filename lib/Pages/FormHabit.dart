import 'package:flutter/material.dart';
import '../DataBase/DatabaseHelper.dart';

class FormHabit extends StatefulWidget {
  @override
  _FormHabitState createState() => _FormHabitState();
}

class _FormHabitState extends State<FormHabit> {
  final TextEditingController _habitNameController = TextEditingController();
  final Map<String, bool> _daysSelected = {
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
      'ultimaAtualizacao': null, // armazena como string separada por vírgula
    };

    print('Inserindo hábito: $newHabit');

    int id = await DatabaseHelper().insertHabit(newHabit);
    print('Hábito inserido com id $id');

    Navigator.pop(context, null);
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
                      _daysSelected[day] = selected;
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