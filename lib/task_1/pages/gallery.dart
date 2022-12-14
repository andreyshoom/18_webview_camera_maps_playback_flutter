import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_camera_maps_playback_flutter/task_1/pages/camera.dart';

class MyGallery extends StatefulWidget {
  const MyGallery({super.key});

  @override
  State<MyGallery> createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: photos!.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(photos![index].path),
            height: 300,
            fit: BoxFit.fitWidth,
          );
        });
  }
}
