import 'package:flutter/material.dart';
import 'package:webview_camera_maps_playback_flutter/task_2/player.dart';
import 'package:webview_camera_maps_playback_flutter/task_3/google_maps.dart';
import 'package:webview_camera_maps_playback_flutter/task_4/web_task.dart';

import 'task_1/main_camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const TaskView(),
    );
  }
}

List<String> _list = [
  'Task 1',
  'Task 2',
  'Task 3',
  'Task 4',
];

List<Widget> _pages = [
  const FirstTask(),
  const SecondTask(),
  const ThirdTask(),
  const FourthTask(),
];

class TaskView extends StatelessWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the task'),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.task_alt),
            title: Text(_list[index]),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => _pages[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
