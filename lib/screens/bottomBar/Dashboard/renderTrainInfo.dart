import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../../../constants.dart';
import '../../../helpers/Utils.dart';

class RenderTrainInfo extends StatefulWidget {
  const RenderTrainInfo(
      {super.key,
      required this.localeID,
      required this.trainName,
      required this.platformName,
      required this.pnrNo,
      required this.arrival,
      required this.departure});
  final String trainName, platformName, pnrNo, arrival, departure, localeID;

  @override
  State<RenderTrainInfo> createState() => _RenderTrainInfoState();
}

class _RenderTrainInfoState extends State<RenderTrainInfo> {
  bool speechEnabled = false;
  final FlutterTts _flutterTts = FlutterTts();
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() async {
    _flutterTts.getLanguages.then((value) {
      if (kDebugMode) {
        print(value);
      }
    });
    await _flutterTts.setLanguage(widget.localeID);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 3,
      shadowColor: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 4.0, left: 41.0, right: 8.0),
              child: Text(
                "Train No. - ${widget.pnrNo}",
                style: const TextStyle(
                    fontFamily: "productSansReg",
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: width * (220 / 804),
                      child: Text(
                        widget.trainName,
                        style: const TextStyle(
                            fontFamily: "productSansReg",
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Timings: ${widget.arrival} - ${widget.departure}",
                      style: const TextStyle(
                          fontFamily: "productSansReg",
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueGrey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ))),
                      onPressed: () async {
                        String msg =
                            'Welcome to Railway Mitron! We kindly inform you that the ${widget.trainName} - ${widget.pnrNo} train will be departing from Platform ${widget.platformName} at ${widget.departure}. Thank you!';
                        Translation x = await translator.translate(msg,
                            from: 'en', to: widget.localeID.substring(0, 2));
                        msg = x.text;
                        if (kDebugMode) {
                          print("After translation:$msg");
                        }
                        _flutterTts.speak(msg);
                      },
                      child: const Text(
                        "Announce",
                        style: TextStyle(
                            fontFamily: "productSansReg",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueGrey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ))),
                      onPressed: () async {
                        await makeCallOrText(widget.departure, widget.trainName,
                            widget.pnrNo, widget.platformName, true);
                      },
                      child: const Text(
                        "Call",
                        style: TextStyle(
                            fontFamily: "productSansReg",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 8.0, left: 8.0, right: 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueGrey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ))),
                      onPressed: () async {
                        await makeCallOrText(widget.departure, widget.trainName,
                            widget.pnrNo, widget.platformName, false);
                      },
                      child: const Text(
                        "SMS",
                        style: TextStyle(
                            fontFamily: "productSansReg",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      )))
            ],
          )
        ],
      ),
    );
  }

  Future makeCallOrText(String departure_time, String train_name,
      String train_no, String platform_number, bool isCall) async {
    String attach = isCall ? "make_call" : "make_SMS";
    final response = await http.post(Uri.parse("${Constants().url}/$attach"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "train_name": train_name,
          "platform_number": platform_number,
          "departure_time": departure_time,
          "train_no": train_no
        }));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(data);
        Utils.showSnackBar2("Process initiated");
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
      Utils.showSnackBar("Error occurred");
    }
  }
}
