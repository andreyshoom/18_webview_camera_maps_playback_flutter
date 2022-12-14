import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class ThirdTask extends StatefulWidget {
  const ThirdTask({super.key});

  @override
  State<ThirdTask> createState() => _ThirdTaskState();
}

class _ThirdTaskState extends State<ThirdTask> {
  GoogleMapController? _controller;
  double sliverValue = 3.0;

  static const CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(53.90289517747921, 27.55686489120072), zoom: 14.5);

  Future<void> _goToHomePoint() async {
    double lat = 53.90289517747921, lon = 27.55686489120072;
    await _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lon), 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GoogleMapsFlutterPlatform mapsFlutterPlatform =
        GoogleMapsFlutterPlatform.instance;
    if (mapsFlutterPlatform is GoogleMapsFlutterAndroid) {
      mapsFlutterPlatform.useAndroidViewSurface = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            mapType: MapType.hybrid,
            onMapCreated: (controller) {
              _controller = controller;
              _controller!.getZoomLevel().then((value) {
                setState(() {
                  sliverValue = value;
                });
              });
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: IconButton(
                  onPressed: () {
                    _goToHomePoint();
                  },
                  icon: const Icon(Icons.home),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _controller?.animateCamera(
                          CameraUpdate.zoomIn(),
                        );
                      },
                      icon: const Text(
                        '+',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller?.animateCamera(
                          CameraUpdate.zoomOut(),
                        );
                      },
                      icon: const Text(
                        '-',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  width: 220.0,
                  height: 30.0,
                  color: Colors.white.withOpacity(0.6),
                  child: Slider(
                    min: 3.0,
                    max: 21.0,
                    divisions: 21,
                    value: sliverValue,
                    onChanged: (value) {
                      print(sliverValue);
                      setState(() {
                        sliverValue = value;
                      });
                      _controller?.animateCamera(CameraUpdate.zoomTo(value));
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white.withOpacity(0.6),
                ),
                width: 145,
                height: 100,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        _controller!.moveCamera(
                          CameraUpdate.scrollBy(-10, 0),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: 30,
                          onPressed: () {
                            _controller!.moveCamera(
                              CameraUpdate.scrollBy(0, -10),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_upward,
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          onPressed: () {
                            _controller!.moveCamera(
                              CameraUpdate.scrollBy(0, 10),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_downward,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        _controller!.moveCamera(
                          CameraUpdate.scrollBy(10, 0),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
