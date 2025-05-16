import 'package:exemplo_rotas/Habito.dart';
import 'package:flutter/material.dart';

class FormHabit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FormHabit();
  }
}

class _FormHabit extends State<FormHabit>{
  TextEditingController NameController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFAB(context),
    );
  }

  Widget buildScaffold(context){
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFAB(context),
    );
  }

  AppBar buildAppBar(){
    return AppBar(title: Text("NEW HABIT"),);
  }

  Widget buildBody(){
    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            controller: NameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
            validator: (text){
              if(text == null || text.isEmpty){
                return "Name of the Habit is mandatory!";
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget buildFAB(context){
    Habito habito = Habito();
    return FloatingActionButton(onPressed: () {
      if(key.currentState!.validate()){
        habito.nome = NameController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hábito Criado"))
        );
        Navigator.pop(context, habito);
      }
    }, child: Icon(Icons.check),);
  }

}