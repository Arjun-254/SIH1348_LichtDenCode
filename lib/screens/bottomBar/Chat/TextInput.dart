import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/AudioModel.dart';
import '../../../constants.dart';
import 'ChatBubble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextInput extends StatefulWidget {
  const TextInput({Key? key}) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
  final _controller = TextEditingController();
  String ngrokurl = Constants().url;
  final _formKey = GlobalKey<FormState>();
  List<String> lst = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: height * (40 / deviceHeight),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                    child: TextFormField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintText: AppLocalizations.of(context)!.enterText,
                      hintStyle: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.cyan[500],
                          fontFamily: "productSansReg"),
                      fillColor: Colors.white),
                )),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: width * (135.0 / deviceWidth),
                    height: height * (40.0 / deviceHeight),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.cyan[500]!)),
                      child: Text(
                        AppLocalizations.of(context)!.enter,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        String text = _controller.text.trim();
                        lst.add(text);
                        setState(() {});
                        _controller.clear();
                        var res = await getRewritten(text);
                        lst.add(res[0].toString());
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              if (lst.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lst.length,
                    itemBuilder: (context, index) {
                      return index % 2 == 0
                          ? ChatBubble(text: lst[index], isCurrentUser: true)
                          : ChatBubble(text: lst[index], isCurrentUser: false);
                    },
                  ),
                )
            ]));
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
    }
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(res.body);
      }
    }
    return [stuff.text, res.statusCode];
  }
}
