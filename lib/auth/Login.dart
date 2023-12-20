import 'dart:convert';
import 'dart:io';
import 'package:sih/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/auth/SignUp/ForgotPassword.dart';
import 'package:sih/auth/Signup/SignUp.dart';
import 'package:http/http.dart' as http;
import 'package:sih/Models/LogInModel.dart';
import 'package:sih/helpers/Utils.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String url = Constants().biggerUrl;
  String email = "", password = "";
  bool hidden = true;
  File? image;
  String? name;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Form(
        key: formKey,
        child: SafeArea(
          bottom: false,
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
              body: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      width: width * (20 / 340),
                      height: height * (30.0 / 804),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 300.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_sharp),
                          color: Colors.cyan[500],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Text(
                          AppLocalizations.of(context)!.railwayBuddy,
                          style: TextStyle(
                              color: Colors.cyan[500],
                              fontSize: 50.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: "productSansReg"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.loginCatchphrase,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "productSansReg"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(60.0)),
                    Container(
                        padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(13),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: AppLocalizations.of(context)!.email,
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: "productSansReg"),
                                  errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "productSansReg"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide.none)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) {
                                if (email != null &&
                                    !EmailValidator.validate(email)) {
                                  return 'Please enter a Valid Email';
                                }
                                return null;
                              },
                              controller: _emailController,
                              onSaved: (value) {
                                email = value!;
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            TextFormField(
                              obscureText: hidden,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                fillColor: Colors.white,
                                filled: true,
                                hintText:
                                    AppLocalizations.of(context)!.password,
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: "productSansReg"),
                                errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "productSansReg"),
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      hidden = !hidden;
                                    });
                                  },
                                  child: Icon(
                                    !hidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide.none),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                } else if (value.length < 6) {
                                  return "Enter minimum six characters";
                                }
                                return null;
                              },
                              controller: _passwordController,
                              onSaved: (value) {
                                password = value!;
                              },
                            ),
                            SizedBox(
                              width: width * (20 / 340),
                              height: height * (30.0 / 804),
                            ),
                            SizedBox(
                                width: width * (135.0 / 340),
                                height: height * (40.0 / 804),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.cyan[500],
                                      ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ))),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      var path = await pickImage();
                                      var lst = await LoginGetTokens(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                          path);
                                      if (lst[3] == 200) {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setBool('isLoggedIn', true);
                                        await prefs.setString('token', lst[1]);
                                        Navigator.of(context).pop();
                                        Utils.showSnackBar1(lst[0]);
                                      }
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontFamily: "productSansReg"),
                                  ),
                                )),
                            SizedBox(
                              width: width * (20 / 340),
                              height: height * (30.0 / 804),
                            ),
                            GestureDetector(
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "productSansReg"),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassWord()));
                              },
                            ),
                            SizedBox(
                              width: width * (20 / 340),
                              height: height * (100.0 / 804),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: AppLocalizations.of(context)!.madeAnAcc,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "productSansReg"),
                                  children: [
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignUp()));
                                          },
                                        text:
                                            " ${AppLocalizations.of(context)!.forSignUp}.",
                                        style: TextStyle(
                                            fontFamily: "productSansReg",
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.cyan[500]!))
                                  ]),
                            ),
                          ],
                        )),
                  ]),
                ),
              ),
            ),
          ),
        ));
  }

  Future LoginGetTokens(
      String? email, String? password, File? imagePath) async {
    if (kDebugMode) {
      print(imagePath!.path);
    }
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$url/login/'),
    );
    response.files.add(http.MultipartFile(
        'img', imagePath!.readAsBytes().asStream(), imagePath.lengthSync(),
        filename: basename(imagePath.path),
        contentType: MediaType('application', 'octet-stream')));
    response.fields['username'] = email!;
    response.fields['password'] = password!;
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(responseBody);
      print(res.statusCode);
    }
    if (res.statusCode != 200) {
      Utils.showSnackBar("Error occurred! Unable to login.");
    }

    Map<String, dynamic> data = jsonDecode(responseBody);
    var stuff = LogInModel.fromJson(data);
    var list = [
      stuff.message,
      stuff.accessToken,
      stuff.tokenType,
      res.statusCode,
      stuff.name
    ];
    debugPrint(list[1].toString());
    return list;
  }

  Future pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (image == null) return;
      File imagePath = await saveImagePermanently(image.path);
      name = image.name;
      return imagePath;
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
