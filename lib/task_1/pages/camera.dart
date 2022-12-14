import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';

List<XFile>? photos = [];

class MyCamera extends StatefulWidget {
  const MyCamera({super.key});

  @override
  State<MyCamera> createState() => _MyCameraState();
}

class _MyCameraState extends State<MyCamera> with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  CameraController? controller;
  XFile? lastImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unawaited(initCamera());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onNewCameraSelected(cameraController.description);
    }
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller?.value.isInitialized == true
            ? SizedBox(
                width: 400,
                child: CameraPreview(controller!),
              )
            : const SizedBox(),
        Align(
          heightFactor: 10.5,
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            child: const Icon(Icons.camera),
            onPressed: () async {
              lastImage = await controller?.takePicture();
              photos?.add(lastImage!);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }
}
