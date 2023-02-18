// import 'package:flutter_study_hive_todolist/domain/entity/task.dart';
import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  //last used HiveField key is 1
  @HiveField(0)
  String name;

  // @HiveField(1)
  // HiveList<Task>? tasks;

  Group({required this.name});

  // void addTask(Box<Task> box, Task task) {
  //   tasks ??= HiveList(box);
  //   tasks?.add(task);
  //   save();
  // }
}
