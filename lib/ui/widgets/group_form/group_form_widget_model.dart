import 'package:flutter/material.dart';
import 'package:flutter_study_hive_todolist/domain/data_provider/box_manager.dart';
import 'package:flutter_study_hive_todolist/domain/entity/group.dart';

/*
в форме добавления новой группы задач если текстовое поле пустое то кнопка не
реагирует. это правильно, но пользователь может быть в замешательстве (куда, что тыкать,
ничего не понятно)
поэтому добавим подсказку текст-ерор 
*/
class GroupFormWidgetModel extends ChangeNotifier {
  var _groupName = '';
  String? errorText; //опциональна - мб нулом может и нет
/*
1
по нажатию кнопки добавить группу, если она пустая то выйдет сообщение
errorText = 'Введите название группы задач';
чтобы на странице вышло такое сообщение нашу модель нужно сделать ChangeNotifier
class GroupFormWidgetModel extends ChangeNotifier
а провайдер сделать InheritedNotifier
class GroupFormWidgetModelProvider extends InheritedNotifier
и тогда можно уведомлять листенера добавив в метод notifyListeners();

в виджете, на странице в текстФилд добавим еррорТекст: model?.errorText
read нужно поменять на watch
final model = GroupFormWidgetModelProvider.read(context)?.model;
final model = GroupFormWidgetModelProvider.WATCH(context)?.model;
чтобы мы следили за изменениями в модели

2
 чтобы не создавались пустые группы (если в строке ввода натыканы пробелы) используем метод trim(), который удаляет всякие
 пробелы
 if (groupName.trim().isEmpty) 
 или 
 final groupName = this.groupName.trim();


3
когда начинаем вводить нужно чтобы красная подсказка-ошибка пропала
нужно как-то отслеживать изменения в 
 var groupName = '';
 добавим сеттер

 */
  set groupName(String value) {
    //если ошибка есть и мы что-то вводим
    if (errorText != null && value.trim().isNotEmpty) {
      //уберем ощибку и сделаем уведемление
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  void saveGroup(BuildContext context) async {
    final groupName = _groupName.trim();
    if (groupName.isEmpty) {
      errorText = 'Введите название группы задач';
      notifyListeners();
      return;
    }

    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
  // void saveGroup(BuildContext context) async {
  //   if (groupName.isEmpty) return;

  //   final box = await BoxManager.instance.openGroupBox();
  //   final group = Group(name: groupName);
  //   await box.add(group);
  //   await BoxManager.instance.closeBox(box);
  //   Navigator.of(context).pop();
  // }
}

class GroupFormWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(key: key, notifier: model, child: child);

  static GroupFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.widget;
    return widget is GroupFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}









// import 'package:flutter/material.dart';
// import 'package:flutter_study_hive_todolist/domain/entity/group.dart';
// import 'package:hive/hive.dart';

// class GroupFormWidgetModel {
//   var groupName = '';
//   void saveGroup(BuildContext context) async {
//     if (groupName.isEmpty) return;
//     if (!Hive.isAdapterRegistered(1)) {
//       Hive.registerAdapter(GroupAdapter());
//     }
//     final box = await Hive.openBox<Group>('groups-box');
//     final group = Group(name: groupName);
//     await box.add(group);
//     Navigator.of(context).pop();
//   }
// }

// class GroupFormWidgetModelProvider extends InheritedWidget {
//   final GroupFormWidgetModel model;

//   const GroupFormWidgetModelProvider(
//       {Key? key, required this.model, required Widget child})
//       : super(key: key, child: child);

//   static GroupFormWidgetModelProvider? of(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
//   }

//   static GroupFormWidgetModelProvider? watch(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
//   }

//   static GroupFormWidgetModelProvider? read(BuildContext context) {
//     final widget = context
//         .getElementForInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
//         ?.widget;
//     return widget is GroupFormWidgetModelProvider ? widget : null;
//   }

//   @override
//   bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
//     return false;
//   }
// }
