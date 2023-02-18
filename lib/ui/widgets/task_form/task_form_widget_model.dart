import 'package:flutter/material.dart';
import 'package:flutter_study_hive_todolist/domain/data_provider/box_manager.dart';
import 'package:flutter_study_hive_todolist/domain/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier {
  var _taskText = '';
  int groupKey;
  bool get isValid => _taskText.trim().isNotEmpty;

  set taskText(String value) {
    final isTaskTextEmpty = _taskText.trim().isEmpty;
    _taskText = value;

    //проверка изменилось ли состояние
    /*
  условие срабатывает только раз, два
  когда текстовое поле пустое и мы начинаем вводить value is Empty (false - мы уже вводим текст)
  не равно  isTaskTextEmpty = _taskText.trim().isEmpty; (true) - здесь у нас еще старое состояние
  текст еще был пустой
  то есть отслеживается момент изменения состояния, было пустое - стало не пустое
когда мы пишем пишем состояние не меняется: и value не пустое и _taskText не пустой

  и когда мы стираем текст 
  тоже изменяется состояние: у нас последняя буква есть _taskText не пустой, 
  удаляем ее value становится пустым, но сравнение происходим по состоянию на момент когда еще была
  буква в _taskText 
final isTaskTextEmpty у нас вспомогательная переменная, она хранит промежуточные данные
  */
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  set taskTextTest(String value) {
    // final isTaskTextEmpty = _taskText.trim().isEmpty;
    print(
        'value - $value, value.trim().isEmpty ${value.trim().isEmpty} \n _taskText - $_taskText _taskText.trim().isEmpty - ${_taskText.trim().isEmpty}');
    if (value.trim().isEmpty != _taskText.trim().isEmpty) {
      print('notify Listeners');
      notifyListeners();
    }
    _taskText = value;
    print(_taskText);
  }

  TaskFormWidgetModel({required this.groupKey});

  void saveTasks(BuildContext context) async {
    final taskText = _taskText.trim();
    if (_taskText.isEmpty) return;
    final task = Task(isDone: false, text: taskText);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(key: key, notifier: model, child: child);

  static TaskFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_study_hive_todolist/domain/entity/group.dart';
// import 'package:flutter_study_hive_todolist/domain/entity/task.dart';
// import 'package:hive/hive.dart';

// class TaskFormWidgetModel {
//   var taskText = '';
//   int groupKey;

//   TaskFormWidgetModel({required this.groupKey});

//   void saveTasks(BuildContext context) async {
//     if (taskText.isEmpty) return;
//     if (!Hive.isAdapterRegistered(1)) {
//       Hive.registerAdapter(GroupAdapter());
//     }
//     if (!Hive.isAdapterRegistered(2)) {
//       Hive.registerAdapter(TaskAdapter());
//     }

//     final taskBox = await Hive.openBox<Task>('tasks-box');
//     final task = Task(isDone: false, text: taskText);
//     await taskBox.add(task);

//     final groupBox = await Hive.openBox<Group>('groups-box');
//     final group = groupBox.get(groupKey);
//     group?.addTask(taskBox, task);
//     Navigator.of(context).pop();
//   }
// }

// class TaskFormWidgetModelProvider extends InheritedWidget {
//   final TaskFormWidgetModel model;
//   const TaskFormWidgetModelProvider(
//       {Key? key, required this.model, required Widget child})
//       : super(key: key, child: child);

//   static TaskFormWidgetModelProvider? of(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
//   }

//   @override
//   bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
//     return false;
//   }

//   static TaskFormWidgetModelProvider? watch(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
//   }

//   static TaskFormWidgetModelProvider? read(BuildContext context) {
//     final widget = context
//         .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
//         ?.widget;
//     return widget is TaskFormWidgetModelProvider ? widget : null;
//   }
// }
