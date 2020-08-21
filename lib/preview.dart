import 'dart:io';

import 'package:CLAP/filepage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Preview extends StatefulWidget {
  final link;

  const Preview({Key key, this.link}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState(link);
}

class _PreviewState extends State<Preview> {
  VideoPlayerController _controller;
  final link;

  _PreviewState(this.link);
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(link)
      ..initialize().then((_) {
        _controller.setVolume(100);
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? Scaffold(
            body: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : Container(
            color: Colors.white,
          );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
