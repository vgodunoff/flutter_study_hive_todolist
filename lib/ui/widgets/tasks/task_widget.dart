import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_study_hive_todolist/ui/widgets/tasks/task_widget_model.dart';

class TaskWidgetConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;

  const TasksWidget({Key? key, required this.configuration}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TaskWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskWidgetModel(configuration: widget.configuration);
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

//так как метод didChangeDependencies() может вызываться несколько раз, если
//будут меняться зависимости
//поэтому делаем условие чтобы не было повторной инициализации модели
//мы делаем проверку: если наша модель отсутствует, то тогда мы достаем ключик и
//содаем модельку
  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     _model = TaskWidgetModel(groupKey: groupKey);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    // ignore: unnecessary_null_comparison
    if (model != null) {
      return TaskWidgetModelProvider(
          model: model, child: const _TasksWidgetBody());
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  void dispose() async {
    await _model.dispose();
    super.dispose();
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => model?.showForm(context)
          //GroupsWidgetModelProvider.read(context)?.model.showForm(context),
          ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TaskWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: groupsCount);
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListRowWidget({Key? key, required this.indexInList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//read(context)!.model ставим знак !  потому что мы уверенны что group не null
    final model = TaskWidgetModelProvider.read(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone ? Icons.done : Icons.check_box_outline_blank;
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          task.text,
          style: style,
        ),
        trailing: Icon(icon),
        onTap: () => model.doneToggle(indexInList),
      ),
    );
  }
}
