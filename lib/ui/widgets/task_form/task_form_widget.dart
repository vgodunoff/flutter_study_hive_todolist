import 'package:flutter/material.dart';
import 'package:flutter_study_hive_todolist/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({Key? key, required this.groupKey}) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     _model = TaskFormWidgetModel(groupKey: groupKey);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TextFormWidgetBody(),
    );
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.watch(context)?.model;
    final actionButton = FloatingActionButton(
      onPressed: () => model?.saveTasks(context),
      child: const Icon(Icons.done),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _TaskTextWidget(),
        ),
      ),
      floatingActionButton: model?.isValid == true ? actionButton : null,
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      maxLines: null,
      minLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Текст задачи',
      ),
//onChanged: (value) => model?.taskTextTest = value,
      onChanged: (value) => model?.taskTextTest = value,
//по нажатию кнопки клавиатуры "Done"
      onEditingComplete: () => model?.saveTasks(context),
    );
  }
}
