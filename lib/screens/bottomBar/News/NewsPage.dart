import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sih/screens/bottomBar/News/NewsCard.dart';
import 'package:sih/models/NewsModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlutterNews extends StatefulWidget {
  const FlutterNews({Key? key}) : super(key: key);

  @override
  State<FlutterNews> createState() => _FlutterNewsState();
}

class _FlutterNewsState extends State<FlutterNews> {
  Future<NewsModel> getNewsApi() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=indian%20railways%20trains%20rail&from=2023-11-20&to=2023-12-10&sortBy=popularity&apiKey=baea8a5de1a74cfc93627e7a4ca3a4d4'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return NewsModel.fromJson(data);
    } else {
      return NewsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: height,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 76.0, left: 40),
                child: Text(
                  AppLocalizations.of(context)!.headlines,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 4.8),
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
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: getNewsApi(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: snapshot.data!.articles!.length,
                                itemBuilder: (context, index) {
                                  return RefreshIndicator(
                                      color: Colors.white,
                                      backgroundColor: Colors.blue,
                                      strokeWidth: 4.0,
                                      triggerMode:
                                          RefreshIndicatorTriggerMode.anywhere,
                                      onRefresh: () async {
                                        await getNewsApi();
                                        setState(() {});
                                      },
                                      child: NewsCard(
                                          url: snapshot
                                              .data?.articles![index].url,
                                          imageUrl: snapshot.data
                                              ?.articles![index].urlToImage,
                                          index: index,
                                          name: snapshot.data?.articles![index]
                                              .source?.name,
                                          author: snapshot
                                              .data?.articles![index].author,
                                          title: snapshot
                                              .data?.articles![index].title));
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
