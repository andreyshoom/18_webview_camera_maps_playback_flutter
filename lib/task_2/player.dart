import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SecondTask extends StatefulWidget {
  const SecondTask({super.key});

  @override
  State<SecondTask> createState() => _SecondTaskState();
}

class _SecondTaskState extends State<SecondTask> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  Duration currentPosition = Duration.zero;
  bool _hide = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    );

    // _controller = VideoPlayerController.asset(
    //   'assets/6.1.mp4',
    // );

    _controller.addListener(() {
      setState(() {
        currentPosition = _controller.value.position;
      });
    });

    _controller.setLooping(true);
    _controller.initialize().then(
          (value) => setState(
            () {},
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> seekTo(double milliseconds) async {
    setState(() {
      currentPosition = Duration(milliseconds: milliseconds.toInt());
    });
    _controller.seekTo(Duration(milliseconds: (milliseconds).toInt()));
  }

  void _hideButtons() {
    setState(() {
      _hide = !_hide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => _hideButtons(),
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 1.78,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: _hide ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _hide == false
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: () {
                                _controller.seekTo(
                                  _controller.value.position -
                                      const Duration(seconds: 10),
                                );
                              },
                              icon: const Icon(Icons.replay_10, size: 40.0),
                            ),
                            IconButton(
                              color: Colors.white,
                              onPressed: () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              },
                              icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 40.0),
                            ),
                            IconButton(
                              color: Colors.white,
                              onPressed: () {
                                _controller.seekTo(
                                  _controller.value.position +
                                      const Duration(seconds: 10),
                                );
                              },
                              icon: const Icon(Icons.forward_10, size: 40.0),
                            ),
                          ],
                        ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                  opacity: _hide ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _hide == false
                      ? Container()
                      : Container(
                          height: 75,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Slider(
                                min: 0.0,
                                max: _controller.value.duration.inMilliseconds
                                    .toDouble(),
                                value:
                                    currentPosition.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  seekTo(value);
                                },
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 23),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _videoDuration(
                                          _controller.value.position),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      _videoDuration(
                                          _controller.value.duration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _videoDuration(Duration duration) {
  return '${duration.inMinutes.toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}
