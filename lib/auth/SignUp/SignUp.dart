import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sih/models/SignUpModel.dart';
import 'package:sih/helpers/Utils.dart';
import 'package:sih/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String email1 = "", password1 = "", password2 = "";
  final String url = Constants().url;

  bool hidden1 = true;
  bool hidden2 = true;
  File? image;
  String? name, gender;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Form(
        key: _formKey,
        child: SafeArea(
          child: Center(
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
                          child: Center(
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
                          const Padding(padding: EdgeInsets.all(20.0)),
                          Container(
                            padding: const EdgeInsets.only(top: 80),
                            child: Text(
                              AppLocalizations.of(context)!.forSignUp,
                              style: TextStyle(
                                  color: Colors.cyan[500],
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "productSansReg"),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(20.0)),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 35.0, right: 35.0),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(13),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .firstName,
                                            hintStyle: const TextStyle(
                                                fontFamily: "productSansReg",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                            errorStyle: const TextStyle(
                                                fontFamily: "productSansReg",
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                borderSide: BorderSide.none)),
                                        controller: firstNameController,
                                        validator: (name) {
                                          if (name == null) {
                                            return 'Enter your first name';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {},
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(5.0)),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(13),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .lastName,
                                            hintStyle: const TextStyle(
                                                fontFamily: "productSansReg",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                            errorStyle: const TextStyle(
                                                fontFamily: "productSansReg",
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                borderSide: BorderSide.none)),
                                        controller: lastNameController,
                                        validator: (name) {
                                          if (name == null) {
                                            return 'Enter your last name';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {},
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(10.0)),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(13),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText:
                                          AppLocalizations.of(context)!.email,
                                      hintStyle: const TextStyle(
                                          fontFamily: "productSansReg",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      errorStyle: const TextStyle(
                                          fontFamily: "productSansReg",
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          borderSide: BorderSide.none)),
                                  controller: emailController,
                                  validator: (email) {
                                    if (email != null &&
                                        !EmailValidator.validate(email)) {
                                      return 'Please enter a Valid Email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    email1 = value!;
                                  },
                                ),
                                const Padding(padding: EdgeInsets.all(10.0)),
                                TextFormField(
                                  obscureText: hidden1,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText:
                                        AppLocalizations.of(context)!.password,
                                    hintStyle: const TextStyle(
                                        fontFamily: "productSansReg",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    errorStyle: const TextStyle(
                                        fontFamily: "productSansReg",
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                    suffix: InkWell(
                                        onTap: () {
                                          setState(() {
                                            hidden1 = !hidden1;
                                          });
                                        },
                                        child: Icon(
                                          !hidden1
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 20,
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide.none),
                                  ),
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Password';
                                    } else if (value.length < 6) {
                                      return "Enter minimum six characters";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    password1 = value!;
                                  },
                                ),
                                const Padding(padding: EdgeInsets.all(10.0)),
                                TextFormField(
                                  obscureText: hidden2,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: AppLocalizations.of(context)!
                                        .confirmPassword,
                                    hintStyle: const TextStyle(
                                        fontFamily: "productSansReg",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    errorStyle: const TextStyle(
                                        fontFamily: "productSansReg",
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                    suffix: InkWell(
                                        onTap: () {
                                          setState(() {
                                            hidden2 = !hidden2;
                                          });
                                        },
                                        child: Icon(
                                          !hidden2
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 20,
                                        )),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        borderSide: BorderSide.none),
                                  ),
                                  onSaved: (value) {
                                    password2 = value!;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm password';
                                    }
                                    if (password1 != password2) {
                                      return "Password doesn't match Confirm Password";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  width: width * (20 / 340),
                                  height: height * (50.0 / 804),
                                ),
                                SizedBox(
                                    width: width * (135 / 340),
                                    height: height * (40 / 804),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.cyan[500]),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ))),
                                      onPressed: () async {
                                        _formKey.currentState!.save();
                                        if (_formKey.currentState!.validate()) {
                                          var path = await pickImage();
                                          if (password1 == password2) {
                                            var lst = await SignUp(
                                                emailController.text.trim(),
                                                passwordController.text.trim(),
                                                firstNameController.text.trim(),
                                                lastNameController.text.trim(),
                                                path);
                                            Utils.showSnackBar1(lst[0]);
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.forSignUp,
                                        style: const TextStyle(
                                          fontFamily: "productSansReg",
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ]))
                        ]),
                      )))),
            ),
          ),
        ));
  }

  Future SignUp(String? email, String? password, String? firstname,
      String? lastname, File? imagePath) async {
    print(imagePath!.path);
    print(url);
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$url/signup/'),
    );
    response.files.add(http.MultipartFile(
        'img', imagePath.readAsBytes().asStream(), imagePath.lengthSync(),
        filename: basename(imagePath.path),
        contentType: MediaType('multipart', 'form-data')));
    response.fields['first_name'] = firstname!;
    response.fields['last_name'] = lastname!;
    response.fields['email'] = email!;
    response.fields['password'] = password!;
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(res.statusCode);
    }
    Map<String, dynamic> data = jsonDecode(responseBody);
    String message = SignUpModel.fromJson(data).message;
    var list = [message, res.statusCode];
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
