import 'package:flutter/material.dart';
import 'package:webview_camera_maps_playback_flutter/task_1/pages/camera.dart';
import 'package:webview_camera_maps_playback_flutter/task_1/pages/gallery.dart';

class FirstTask extends StatefulWidget {
  const FirstTask({super.key});

  @override
  State<FirstTask> createState() => _FirstTaskState();
}

class _FirstTaskState extends State<FirstTask> {
  String _title = 'Camera preview';
  int _selectedIndex = 0;

  static const List<Widget> _listWidget = [
    MyCamera(),
    MyGallery(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = 'Camera preview';
          break;
        case 1:
          _title = 'Images Gallery';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
      ),
      body: _listWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_size_select_actual_outlined),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
