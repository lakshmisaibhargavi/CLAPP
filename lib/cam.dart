import 'dart:io';

import 'package:CLAP/dashboard.dart';
import 'package:CLAP/filepage.dart';
import 'package:CLAP/music.dart';
import 'package:CLAP/trimmer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:path/path.dart' as p;

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key key, this.cameras}) : super(key: key);

  @override
  CameraScreenState createState() {
    return new CameraScreenState();
  }
}

class CameraScreenState extends State<CameraScreen> {
  var song;
  AudioPlayer audioPlayer = AudioPlayer();
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;
  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    setState(() {
      user = _user;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // 1
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: _onSwitchCamera,
          color: Colors.white,
          icon: Icon(
            _getCameraLensIcon(lensDirection),
            size: 40,
          ),
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  var recording = false;
  String pa;
  void _onCapturePressed(context) async {
    try {
      // 1
      pa = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.mp4',
      );
      await controller.startVideoRecording(pa);

      setState(() {
        recording = true;
      });
      // 3

    } catch (e) {
      print(e);
    }
  }

  void _onsavePressed(context) async {
    try {
      // 1

      // 2
      await controller.stopVideoRecording();
      setState(() {
        recording = false;
      });
      final info = await VideoCompress.compressVideo(
        pa,
        quality: VideoQuality.LowQuality,
        deleteOrigin: true,
      );
      print('done');
      setState(() {
        fileName = p.basename(info.path);
        file = info.file;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  play() async {
    int result = await audioPlayer.play(
        'https://firebasestorage.googleapis.com/v0/b/clap-2425e.appspot.com/o/songs%2FAbhi%20to%20party%20suru%20hui%20Hai%20-%20Badshah.mp3?alt=media&token=a5b089ef-f315-45e7-832d-26f18bd50fe0');
  }

  File file;
  String fileName;
  final Trimmer _trimmer = Trimmer();
  bool busy = false;
  Future filePicker(BuildContext context) async {
    try {
      setState(() {
        busy = true;
      });
      file = await ImagePicker.pickVideo(
          source: ImageSource.gallery, maxDuration: Duration(seconds: 40));
      if (file == null) {
        setState(() {
          busy = false;
        });
      }

      final info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
      );
      print('done');
      setState(() {
        fileName = p.basename(info.path);
        file = info.file;
      });
      await _trimmer.loadVideo(videoFile: File(file.path));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return TrimmerView(_trimmer, user);
      }));
      print(fileName);
      setState(() {
        busy = false;
        file = null;
      });
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(cameras: cameras)));
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    _on(recording) {
      if (recording) {
        return Icon(Icons.check_box);
      } else {
        return Icon(Icons.play_circle_outline);
      }
    }

    var pause = false;
    return !busy
        ? Scaffold(
            backgroundColor: Colors.black54,
            body: Stack(
              children: <Widget>[
                ClipRRect(
                  child: Container(
                    child: Transform.scale(
                      scale: controller.value.aspectRatio /
                          MediaQuery.of(context).size.aspectRatio,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(controller),
                        ),
                      ),
                    ),
                  ),
                ),
                _cameraTogglesRowWidget(),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.8,
                  left: MediaQuery.of(context).size.width * 0.35,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        color: Colors.red,
                        iconSize: 90,
                        icon: _on(recording),
                        onPressed: () async {
                          if (!recording) {
                            play();
                            _onCapturePressed(context);
                          } else {
                            _onsavePressed(context);
                            audioPlayer.pause();
                            await _trimmer.loadVideo(videoFile: File(pa));
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return TrimmerView(_trimmer, user);
                            }));
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: FloatingActionButton(
                          onPressed: () async {
                            filePicker(context);
                            await _trimmer.loadVideo(
                                videoFile: File(file.path));
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return TrimmerView(_trimmer, user);
                            }));
                          },
                          child: Icon(Icons.file_upload),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.38,
                  child: OutlineButton(
                    textColor: Colors.white,
                    borderSide: BorderSide(color: Colors.white),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Audio(
                                    camera: cameras,
                                  )));
                    },
                    child: Text(song == null ? 'Audio Clips' : song),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: Image.asset(
                'assets/logo.gif',
                height: 200,
                width: 200,
              ),
            ),
          );
  }
}
