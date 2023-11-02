import 'package:flutter/material.dart';
import 'package:todo_list2/models/todomodel.dart';

class ToDoWidget extends StatefulWidget {
  final double toDoWidth, toDoheight;
  const ToDoWidget(
      {required this.toDoWidth, required this.toDoheight, super.key});

  @override
  State<ToDoWidget> createState() => _ToDoWidgetState();
}

class _ToDoWidgetState extends State<ToDoWidget> {
  @override
  Widget build(BuildContext context) {
    List<ToDoModel> dataToDo = <ToDoModel>[];
    return ListView(
      children: List.generate(dataToDo.length, (index) {
        ToDoModel todoloop = dataToDo[index];
        return const Column();
      }),
    );
  }
}
