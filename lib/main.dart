import 'package:flutter/material.dart';
import 'package:flutter_study_hive_todolist/ui/widgets/app/my_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  const app = MyApp();
  runApp(app);
}

/*
во-первых обязательно нужно перед тем как обращаться к свойству:
- открывать бокс, он(хив) этого сам не умеет, 
- регистрировать адаптер конечно он(хив) сам этого не умеет
 - и после того как туда что-то добавляешь нужно делать сейв - save();
 */