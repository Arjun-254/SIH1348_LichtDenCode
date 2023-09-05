import 'package:flutter/material.dart';
import 'package:sih/constants.dart';
import 'package:sih/helpers/radialPainterIndicator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/AudioModel.dart';
import '../helpers/Utils.dart';
import '../helpers/liquidPainter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int maxDuration = 10;
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
  List<Color> gradientColors = const [
    Color(0xffFF0069),
    Color(0xffFED602),
    Color(0xff7639FB),
    Color(0xffD500C5),
    Color(0xffFF7A01),
    Color(0xffFF0069),
  ];
  late AnimationController _controller;
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  bool isRecorderReady = false, gotSomeTextYo = false, isPlaying = true;
  var lst = [];

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    String? path = await recorder.stopRecorder();
    File audioPath = await saveAudioPermanently(path!);
    if (kDebugMode) {
      print('Recorded audio: $path');
    }
    await player.startPlayer(fromURI: path, codec: Codec.aacADTS);
    lst = await sendAudio(audioPath);
    if (kDebugMode) {
      print(lst);
    }
    if (lst[1] == 200) {
      gotSomeTextYo = true;
      setState(() {
        maxDuration = maxDuration;
      });
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: maxDuration))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isPlaying = false;
        }
      });
    initRecorder();
    player.openPlayer().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    recorder.closeRecorder();
    player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(height);
    print(width);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Language translator',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.white54,
        ),
        backgroundColor: const Color(0xFF232424),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;
                  String twoDigits(int n) => n.toString().padLeft(2, '0');
                  final twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));
                  return Text(
                    "$twoDigitMinutes:$twoDigitSeconds s",
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  );
                }),
            SizedBox(
              height: 50 * (height/deviceHeight),
            ),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomPaint(
                            painter: LiquidPainter(
                              _controller.value * maxDuration,
                              maxDuration.toDouble(),
                            ),
                          ),
                        ),
                        CustomPaint(
                            painter: RadialProgressPainter(
                          value: _controller.value * maxDuration,
                          backgroundGradientColors: gradientColors,
                          minValue: 0,
                          maxValue: maxDuration.toDouble(),
                        )),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 50 * (height/deviceHeight),
            ),
            // Start and Stop Button
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white54,
                    width: 2,
                  ),
                  shape: BoxShape.circle),
              child: GestureDetector(
                onTap: () async {
                  if (recorder.isRecording) {
                    isPlaying = false;
                    await stop();
                    _controller.reset();
                  } else {
                    await record();
                    isPlaying = true;
                    _controller.reset();
                    _controller.forward();
                  }
                  setState(() {});
                },
                child: AnimatedContainer(
                  height: isPlaying ? 25 : 60,
                  width: isPlaying ? 25 : 60,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isPlaying ? 4 : 100),
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35 * (height/deviceHeight),
            ),
            if (gotSomeTextYo)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  lst[0],
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "productSansReg",
                      color: Colors.purple),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<List<Object?>> sendAudio(File? audioPath) async {
    if (kDebugMode) {
      print(audioPath!.path);
    }
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('https://6a83-34-133-155-148.ngrok-free.app/transcribe/'),
    );
    response.files.add(http.MultipartFile(
        'file', audioPath!.readAsBytes().asStream(), audioPath.lengthSync(),
        filename: basename(audioPath.path),
        contentType: MediaType('application', 'octet-stream')));
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(responseBody);
      print(res.statusCode);
    }
    if (res.statusCode != 200) {
      Utils.showSnackBar("Error occurred!.");
    }

    Map<String, dynamic> data = jsonDecode(responseBody);
    var stuff = Audio.fromJson(data);
    if (kDebugMode) {
      print(stuff.text);
    }
    return [stuff.text, res.statusCode];
  }

  Future<File> saveAudioPermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final audio = File('${directory.path}/$name');
    return File(path).copy(audio.path);
  }
}
