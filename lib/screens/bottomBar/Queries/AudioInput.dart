import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sih/maps/maps.dart';
import '../../../constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

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
  bool gotSomeTextYo = false, isPlaying = false, speechEnabled = false;
  final translator = GoogleTranslator();
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  String lastWords = '';
  DateTime? startTime;
  String _firstLanguage = 'Tamil', _secondLanguage = 'English';
  String STTLocaleID = "ta_IN", TTSLocaleID = 'en-IN';

  @override
  void initState() {
    super.initState();
    initTTS();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    isPlaying = true;
    startTime = DateTime.now();
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: STTLocaleID,
    );
    setState(() {});
  }

  void _stopListening() async {
    isPlaying = false;
    startTime = null;
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void initTTS() async {
    _flutterTts.getLanguages.then((value) {
      if (kDebugMode) {
        print("For TTS");
        print(value);
      }
    });
    await _flutterTts.setLanguage(TTSLocaleID);
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
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    AppLocalizations.of(context)!.speakMic,
                    style: TextStyle(
                        fontFamily: "productSansReg",
                        color: Colors.cyan[500],
                        fontWeight: FontWeight.w700,
                        fontSize: 23),
                  ),
                ),
                SizedBox(
                  height: 30 * (height / deviceHeight),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButtonFormField(
                            itemHeight: null,
                            isExpanded: true,
                            hint: Text(
                              _firstLanguage,
                              style: const TextStyle(
                                fontFamily: "productSansReg",
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (v) => setState(() {
                              _firstLanguage = Constants().STTDisplay[
                                  Constants().STTLocaleIDs.indexOf(v!)];
                              STTLocaleID = v;
                            }),
                            items: Constants().STTLocaleIDs.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: SizedBox(
                                  width: width * (75 / 340),
                                  child: Text(
                                    Constants().STTDisplay[
                                        Constants().STTLocaleIDs.indexOf(e)],
                                    style: const TextStyle(
                                      fontFamily: "productSansReg",
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: const TextStyle(
                                fontFamily: "productSansReg",
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(13),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.compare_arrows,
                            color: Colors.cyan[500],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButtonFormField(
                            itemHeight: null,
                            isExpanded: true,
                            hint: Text(
                              _secondLanguage,
                              style: const TextStyle(
                                fontFamily: "productSansReg",
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                            onChanged: (v) => setState(() {
                              _secondLanguage = Constants().TTSDisplay[
                                  Constants().TTSLocaleIDS.indexOf(v!)];
                              TTSLocaleID = v;
                            }),
                            items: Constants().TTSLocaleIDS.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: SizedBox(
                                  width: width * (75 / 340),
                                  child: Text(
                                    Constants().TTSDisplay[
                                        Constants().TTSLocaleIDS.indexOf(e)],
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: "productSansReg",
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                ),
                              );
                            }).toList(),
                            style: const TextStyle(
                                fontFamily: "productSansReg",
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(13),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30 * (height / deviceHeight),
                ),
                Text(
                  getElapsedTime(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan[500],
                    fontFamily: "productSansReg",
                  ),
                ),
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
                                  width: 1.5, color: const Color(0xFF009CFF)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  lastWords,
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
                      if (isPlaying) {
                        isPlaying = false;
                        _stopListening();
                        if (kDebugMode) {
                          print("Before translation:$lastWords");
                        }
                        Translation x = await translator.translate(lastWords,
                            from: STTLocaleID.substring(0, 2),
                            to: TTSLocaleID.substring(0, 2));
                        lastWords = x.text;
                        gotSomeTextYo = true;
                        if (kDebugMode) {
                          print("After translation:$lastWords");
                        }
                        _flutterTts.speak(lastWords);
                      } else {
                        isPlaying = true;
                        _startListening();
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

  String getElapsedTime() {
    if (startTime == null) {
      return "00:00 s";
    }

    Duration elapsedTime = DateTime.now().difference(startTime!);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(elapsedTime.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(elapsedTime.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds s";
  }
}
