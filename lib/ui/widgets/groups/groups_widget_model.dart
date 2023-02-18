import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_hive_todolist/domain/data_provider/box_manager.dart';
import 'package:flutter_study_hive_todolist/domain/entity/group.dart';
import 'package:flutter_study_hive_todolist/ui/navigation/main_navigation.dart';
import 'package:flutter_study_hive_todolist/ui/widgets/tasks/task_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;

  var _groups = <Group>[];
  List<Group> get groups => _groups;
  ValueListenable<Object>? _listenableBox;

  GroupsWidgetModel() {
    setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration =
          TaskWidgetConfiguration(group.key as int, group.name);
      // ignore: use_build_context_synchronously
      unawaited(Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.tasks, arguments: configuration));
    }
  }

// Future<void> showTasks(BuildContext context, int groupIndex) async {
//     final groupKey = (await _box).keyAt(groupIndex) as int;

//     // ignore: use_build_context_synchronously
//     unawaited(Navigator.of(context)
//         .pushNamed(MainNavigationRouteNames.tasks, arguments: groupKey));
//   }

  Future<void> _readsGroupFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readsGroupFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readsGroupFromHive);
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = (await _box);

    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);

    await box.deleteAt(groupIndex);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readsGroupFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(key: key, notifier: model, child: child);

  static GroupsWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
