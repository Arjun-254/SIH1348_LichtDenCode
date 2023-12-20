import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sih/constants.dart';
import 'package:sih/helpers/Utils.dart';
import 'package:sih/models/HetanshApi.dart';
import 'package:sih/screens/bottomBar/Dashboard/renderTrainInfo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

HetanshApi? x;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String departureStation = "Departing From",
      arrivalStation = 'Arriving At',
      lang = 'Tamil',
      TTSlocaleID = 'ta-IN';
  final formkey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = Constants().deviceHeight,
        deviceWidth = Constants().deviceWidth;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.grey[900]!,
            Colors.black,
            Colors.grey[900]!,
          ])),
        ),
        Padding(
          padding: EdgeInsets.only(top: height / 4.5),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueGrey[400]!,
                    Colors.white,
                  ]),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 4, right: 4, bottom: 4),
              child: SingleChildScrollView(
                clipBehavior: Clip.antiAlias,
                physics: const ScrollPhysics(),
                child: Form(
                  key: formkey1,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField(
                            hint: Text(
                              departureStation,
                              style: const TextStyle(
                                fontFamily: "productSansReg",
                                color: Colors.black,
                              ),
                            ),
                            onSaved: (v) => setState(() {
                              departureStation = v!;
                            }),
                            items: Constants().stationList.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: "productSansReg",
                                    color: Colors.black,
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
                            onChanged: (String? value) {},
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField(
                            hint: Text(
                              arrivalStation,
                              style: const TextStyle(
                                fontFamily: "productSansReg",
                                color: Colors.black,
                              ),
                            ),
                            onSaved: (v) => setState(() {
                              arrivalStation = v!;
                            }),
                            items: Constants().stationList.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: "productSansReg",
                                    color: Colors.black,
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
                            onChanged: (String? value) {},
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField(
                            hint: Text(
                              lang,
                              style: const TextStyle(
                                fontFamily: "productSansReg",
                                color: Colors.black,
                              ),
                            ),
                            onSaved: (v) => setState(() {
                              TTSlocaleID = v!;
                              lang = Constants().TTSDisplay[
                                  Constants().TTSLocaleIDS.indexOf(v)];
                            }),
                            items: Constants().TTSLocaleIDS.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(
                                  Constants().TTSDisplay[
                                      Constants().TTSLocaleIDS.indexOf(e)],
                                  style: const TextStyle(
                                    fontFamily: "productSansReg",
                                    color: Colors.black,
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
                            onChanged: (String? value) {},
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            formkey1.currentState!.save();
                            if (formkey1.currentState!.validate()) {
                              setState(() {});
                              await getTrainData(
                                  departureStation, arrivalStation);
                              setState(() {});
                              if (kDebugMode) {
                                print("Train data is : $x");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.blue[700]!,
                                  Colors.blue[500]!
                                ]),
                                borderRadius: BorderRadius.circular(25)),
                            child: Container(
                              width: 105 * (height / deviceHeight),
                              height: 40 * (height / deviceHeight),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.enter,
                                style: const TextStyle(
                                    fontFamily: "productSansReg",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      if (x != null)
                        for (int i = 0;
                            i < x!.trainData1!.trainName!.length;
                            i++)
                          RenderTrainInfo(
                            trainName: x!.trainData1!.trainName![i]!,
                            platformName: x!.trainData2!.PFfrom![i]!,
                            pnrNo: x!.trainData1!.trainNo![i]!,
                            arrival: x!.trainData2!.Arr![i]!,
                            departure: x!.trainData2!.Dep![i]!,
                            localeID: TTSlocaleID,
                          ),
                      SizedBox(
                        height: height * (260 / 840),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: height * (75 / 840),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Train lookup",
                  style: TextStyle(
                      fontFamily: "productSansReg",
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future getTrainData(String departure, String arrival) async {
    if (kDebugMode) {
      print(departure + arrival);
    }
    final response = await http.post(
        Uri.parse("${Constants().url}/get_train_data"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"station_1": departure, "station_2": arrival}));
    var data = jsonDecode(response.body);
    var res = HetanshApi.fromJson(data);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(res.trainData1!.trainName![0]);
        x = res;
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
      Utils.showSnackBar("Error occurred");
    }
  }
}
