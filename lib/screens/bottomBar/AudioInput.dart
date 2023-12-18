import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/maps/maps.dart';
import '../../models/AudioModel.dart';
import '../../helpers/Utils.dart';
import '../../constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var lst = [];

class AudioInput extends StatefulWidget {
  const AudioInput({super.key});

  @override
  State<AudioInput> createState() => _AudioInputState();
}

class _AudioInputState extends State<AudioInput>
    with SingleTickerProviderStateMixin {
  int maxDuration = 10;
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
  late AnimationController _controller;
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  bool isRecorderReady = false, gotSomeTextYo = false, isPlaying = false;
  String ngrokurl = Constants().url;

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

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[900]!,
                Colors.black,
                Colors.grey[900]!,
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.speakMic,
                    style: TextStyle(
                        fontFamily: "productSansReg",
                        color: Colors.cyan[500],
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 80 * (height / deviceHeight),
                ),
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
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan[500],
                          fontFamily: "productSansReg",
                        ),
                      );
                    }),
                SizedBox(
                  height: 40 * (height / deviceHeight),
                ),
                if (isPlaying)
                  Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.cyan[500]!,
                    size: 50 * (height / deviceHeight),
                  )),
                if (!isPlaying)
                  SizedBox(
                    height: 160 * (height / deviceHeight),
                    child: gotSomeTextYo
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5, color: const Color(0xFF009CFF)
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  lst[0],
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "productSansReg",
                                      color: Color(0xFF009CFF)),
                                ),
                              ),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                  ),
                if (!isPlaying)
                  SizedBox(
                    height: 50 * (height / deviceHeight),
                  ),
                if (isPlaying)
                  SizedBox(
                    height: 150 * (height / deviceHeight),
                  ),
                Container(
                  alignment: Alignment.center,
                  height: 60 * (height / deviceHeight),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
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
                        isPlaying = true;
                        await record();
                        _controller.reset();
                        _controller.forward();
                      }
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      height: isPlaying
                          ? 25 * (height / deviceHeight)
                          : 50 * (height / deviceHeight),
                      width: isPlaying
                          ? 25 * (height / deviceHeight)
                          : 50 * (height / deviceHeight),
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isPlaying ? 6 : 100),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70 * (height / deviceHeight),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const maps()));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60))),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue[700]!, Colors.blue[500]!]),
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        width: 165 * (height / deviceHeight),
                        height: 60 * (height / deviceHeight),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!.chooseMap,
                          style: const TextStyle(
                              fontFamily: "productSansReg",
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Object?>> sendAudio(File? audioPath) async {
    List<Object?> lst = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {'token': '$token'};
    if (kDebugMode) {
      print(token);
      print(audioPath!.path);
    }
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$ngrokurl/transcribe/'),
    );
    response.headers.addAll(header);
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
      Utils.showSnackBar("Error occurred!");
    }

    Map<String, dynamic> data = jsonDecode(responseBody);
    var stuff = Audio.fromJson(data);
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(stuff.text);
      }
      lst = await getRewritten(stuff.text!);
      if (kDebugMode) {
        print(stuff.text);
      }
    }

    return lst;
  }

  Future<List<Object?>> getRewritten(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var res = await http.post(
      Uri.parse('$ngrokurl/chat/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token': '$token'
      },
      body: jsonEncode(<String, String>{
        "text":
            "Fix it and answer such that grammatical and spelling errors are corrected: $text",
        "emotion": "Professional & Cheerful"
      }),
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    var stuff = Audio.fromJson(data);
    if (kDebugMode) {
      print(res.statusCode);
      print(res.body);
      await getAudio(stuff.text!);
    }
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.body);
      }
    }
    return [stuff.text, res.statusCode];
  }

  Future<List<Object?>> getGrammar(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var res = await http.post(
      Uri.parse('$ngrokurl/grammar/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token': '$token'
      },
      body: jsonEncode(
          <String, String>{"text": text, "emotion": "Professional & Cheerful"}),
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    var stuff = Audio.fromJson(data);
    if (kDebugMode) {
      print(res.statusCode);
      print(res.body);
      await getAudio(stuff.text!);
    }
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.body);
      }
    }
    return [stuff.text, res.statusCode];
  }

  Future getAudio(String text) async {
    var res = await http.post(
      Uri.parse('$ngrokurl/labs-tts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"text": text, 'emotion': "Cheerful & Professional"}),
    );
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.bodyBytes);
      }
      await player.startPlayer(fromDataBuffer: res.bodyBytes);
    }
  }

  Future<File> saveAudioPermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final audio = File('${directory.path}/$name');
    return File(path).copy(audio.path);
  }
}
