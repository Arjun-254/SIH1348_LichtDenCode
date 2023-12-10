import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/AudioModel.dart';
import '../../helpers/Utils.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OCRInput extends StatefulWidget {
  const OCRInput({Key? key}) : super(key: key);

  @override
  State<OCRInput> createState() => _OCRInputState();
}

class _OCRInputState extends State<OCRInput> {
  File? image;
  String? name;
  final String url = Constants().url;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: image == null
                ? Image(
                    image: const AssetImage(
                      "assets/images/download.jpg",
                    ),
                    width: width * (250 / 340),
                    height: height * (250 / 804),
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    image!,
                    width: width * (250 / 340),
                    height: height * (250 / 804),
                    fit: BoxFit.cover,
                  )),
        Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
            child: ListTile(
              onTap: () async {
                var path = await pickImage();
                if (image != null) {
                  getOCR(path);
                }
              },
              leading: Icon(
                Icons.camera_alt_outlined,
                size: 25,
                color: Colors.grey[900],
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  AppLocalizations.of(context)!.useCamera,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    fontSize: 25,
                  ),
                ),
              ),
              tileColor: Colors.cyan[500],
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(10)),
            )),
        Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
            child: ListTile(
              onTap: () async {
                var file = await pickFile();
                if (file != null) {
                  await getRewrittenPDF(file);
                }
              },
              leading: Icon(
                Icons.upload_file_outlined,
                size: 25,
                color: Colors.grey[900],
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  AppLocalizations.of(context)!.uploadFile,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    fontSize: 25,
                  ),
                ),
              ),
              tileColor: Colors.cyan[500],
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(10)),
            )),
      ],
    );
  }

  Future getOCR(File? imagePath) async {
    List lst = [];
    if (kDebugMode) {
      print(imagePath!.path);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {'token': '$token'};
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$url/ocr/'),
    );
    response.headers.addAll(header);
    response.files.add(http.MultipartFile(
        'file', imagePath!.readAsBytes().asStream(), imagePath.lengthSync(),
        filename: basename(imagePath.path),
        contentType: MediaType('application', 'octet-stream')));
    response.fields["lang"] = "en";
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
      Uri.parse('$url/rewriter/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token': '$token'
      },
      body: jsonEncode(<String, String>{
        "text":
            "Fix it such that grammatical and spelling errors are corrected: $text",
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

  Future<List<Object?>> getRewrittenPDF(File? text) async {
    List lst = [];
    if (kDebugMode) {
      print(text!.path);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {'token': '$token'};
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$url/ocr/'),
    );
    response.headers.addAll(header);
    response.files.add(http.MultipartFile(
        'file', text!.readAsBytes().asStream(), text.lengthSync(),
        filename: basename(text.path),
        contentType: MediaType('application', 'octet-stream')));
    response.fields["lang"] = "en";
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

  Future<List<Object?>> getGrammar(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var res = await http.post(
      Uri.parse('$url/grammar/'),
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

  Future pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        return file;
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to pick file: $e');
      }
    }
  }

  Future pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (image == null) return;
      File imagePath = await saveImagePermanently(image.path);
      name = image.name;
      setState(() {
        this.image = imagePath;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${directory.path}/$name');
    return File(path).copy(image.path);
  }
}
