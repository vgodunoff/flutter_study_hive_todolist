import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_hive_todolist/domain/data_provider/box_manager.dart';
import 'package:flutter_study_hive_todolist/domain/entity/task.dart';
import 'package:flutter_study_hive_todolist/ui/navigation/main_navigation.dart';
import 'package:flutter_study_hive_todolist/ui/widgets/tasks/task_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskWidgetModel extends ChangeNotifier {
  TaskWidgetConfiguration configuration;
  // late final Future<Box<Group>> _groupBox;
  // late final Future<Box<Task>> _taskBox;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();
  ValueListenable<Object>? _listenableBox;
  // Group? _group;
  // Group? get group => _group;

  TaskWidgetModel({required this.configuration}) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.tasksForm,
        arguments: configuration.groupKey);
  }

  Future<void> _readsTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);

    await _readsTasksFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readsTasksFromHive);
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readsTasksFromHive);
    BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
//  Future<void> doneToggle(int taskIndex) async {
//     final task = (await _box).getAt(taskIndex);
//     task?.isDone = !task.isDone;

//     final task = _group?.tasks?[groupIndex];
//     final currentState = task?.isDone ?? false;
// //берем нашу конкретную задачу
//     task?.isDone = !currentState;
//     await task?.save();
//     notifyListeners();
//   }
// void _loadGroup() async {
  //   //подождали поко бокс откроется до конца
  //   final box = await _groupBox;

  //   //из коробки по ключу вытаскиваем соответствующую группу
  //   _group = box.get(groupKey);
  //   notifyListeners();
  // }

  // void _readTasks() {
  //   try {
  //     _tasks = _group?.tasks ?? <Task>[];

  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // void _setupListenTasks() async {
  //   final box = await _groupBox;
  //   // await _taskBox;
  //   _readTasks();
  //   /*
  //   If [keys] filter is provided, only changes to entries with the specified keys notify the listeners.
  //   добавили слушателей не ко всему боксу групп, а только к конкретной группе
  //   и если произошли изменения выполняем функцию  _readTasks()
  //    */
  //   box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  // }

  // void _setup1() {
  // if (!Hive.isAdapterRegistered(1)) {
  //   Hive.registerAdapter(GroupAdapter());
  // }
  // _groupBox = Hive.openBox<Group>('groups-box');

//регистрируем адаптер для бокса задач
  // if (!Hive.isAdapterRegistered(2)) {
  //   Hive.registerAdapter(TaskAdapter());
  // }
  //_taskBox = Hive.openBox<Task>('tasks-box');
  // Hive.openBox<Task>('tasks-box');
  //   _loadGroup();
  //   _setupListenTasks();
  // }

}

class TaskWidgetModelProvider extends InheritedNotifier {
  final TaskWidgetModel model;
  const TaskWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(key: key, notifier: model, child: child);

  static TaskWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskWidgetModelProvider>();
  }

  static TaskWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskWidgetModelProvider>();
  }

  static TaskWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskWidgetModelProvider>()
        ?.widget;
    return widget is TaskWidgetModelProvider ? widget : null;
  }
}
