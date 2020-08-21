import 'dart:async';
import 'dart:io';

import 'package:CLAP/clipcam.dart';
import 'package:CLAP/filepage.dart';
import 'package:CLAP/player_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Aedit extends StatefulWidget {
  final camera;

  const Aedit({Key key, this.camera}) : super(key: key);
  @override
  _AeditState createState() => _AeditState(camera);
}

class _AeditState extends State<Aedit> {
  final camera;
  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  Duration start;
  Duration stop;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;

  _AeditState(this.camera);

  get _durationText => stop?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  File file;
  String fileName = '';
  String filea = '';

  void initState() {
    super.initState();

    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    file = await FilePicker.getFile(type: FileType.audio);

    setState(() {
      filea = file.path;
      fileName = p.basename(file.path);
    });
    print(file);

    setState(() {
      file = null;
      fileName = null;
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });
    print('done');

    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  Future<String> cutAudio(String path, double start, double end) async {
    setState(() {
      busy = true;
    });
    if (start < 0.0 || end < 0.0) {
      throw ArgumentError('Cannot pass negative values.');
    }

    if (start > end) {
      throw ArgumentError('Cannot have start time after end.');
    }

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    final Directory dir = await getTemporaryDirectory();
    final outPath = "${dir.path}/output.mp3";
    var cmd =
        "-y -i \"$path\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec libmp3lame $outPath";
    int rc = await _flutterFFmpeg.execute(cmd);

    if (rc != 0) {
      throw ("[FFmpeg] process exited with rc $rc");
    }
    print(outPath);
    setState(() {
      busy = false;
    });

    return outPath;
  }

  RangeValues re = RangeValues(0, 1);
  @override
  Widget build(BuildContext context) {
    _audioPlayer.onAudioPositionChanged.listen((event) {
      if (_durationText == _positionText) {
        _audioPlayer.stop();
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Crop the required audio'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.assignment_turned_in),
                  onPressed: () {
                    final aa = cutAudio(filea, start.inMilliseconds.toDouble(),
                        stop.inMilliseconds.toDouble());
                    _audioPlayer.play(aa.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClipCam(
                            cameras: camera,
                            song: filea,
                            name: 'From device',
                          ),
                        ));
                  })
            ],
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: Key('play_button'),
                      onPressed: () {
                        _audioPlayer.play(filea, position: start);
                      },
                      iconSize: 64.0,
                      icon: Icon(Icons.play_arrow),
                      color: Colors.cyan,
                    ),
                    IconButton(
                      key: Key('pause_button'),
                      onPressed: () => _audioPlayer.pause(),
                      iconSize: 64.0,
                      icon: Icon(Icons.pause),
                      color: Colors.cyan,
                    ),
                    IconButton(
                      key: Key('stop_button'),
                      onPressed: () async {
                        _audioPlayer.stop();
                      },
                      iconSize: 64.0,
                      icon: Icon(Icons.stop),
                      color: Colors.cyan,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Stack(
                        children: [
                          RangeSlider(
                              onChanged: (v) {
                                if (_positionText == _durationText) {
                                  _audioPlayer.stop();
                                }
                                setState(() {
                                  re = v;
                                  start = Duration(
                                      milliseconds:
                                          (v.start * _duration.inMilliseconds)
                                              .toInt());
                                  stop = Duration(
                                      milliseconds:
                                          (v.end * _duration.inMilliseconds)
                                              .toInt());
                                });
                              },
                              values: re),
                        ],
                      ),
                    ),
                    Text(
                      _position != null
                          ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                          : _duration != null ? _durationText : '',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
