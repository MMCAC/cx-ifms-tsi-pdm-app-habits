import 'package:exemplo_rotas/models/UserSettings.dart';
import 'package:flutter/material.dart';

class SettingsController extends InheritedWidget{
  final ValueNotifier<UserSettings> settings;


  //Não fiz essa parte do SettingsController, tentei remover o super e o mesmo não deixou
  SettingsController({
    required this.settings,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static SettingsController of(BuildContext context){
    final SettingsController? result = context.dependOnInheritedWidgetOfExactType<SettingsController>();
    assert(result != null, 'Nenhum SetingsController encontrado no contexto');
    return result!;
  }

  @override
  bool updateShouldNotify(SettingsController oldWidget){
    return settings != oldWidget.settings;
  }
}
