import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NewsPage extends StatelessWidget {
  NewsPage({
    Key? key,
    required this.articles,
    required this.index,
  }) : super(key: key);

  final List<Articles> articles;
  final int index;
  var bottomValue = 20.0;

  @override
  Widget build(BuildContext context) {
    var currentArticle = articles[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(checkForEmpty(currentArticle.source.name)),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: colorBlack,
      body: Stack(children: [
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: currentArticle.urlToImage == "Empty"
                      ? imageFromAssets("./assets/images/image_not_found.png")
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            currentArticle.urlToImage,
                            // color: colorText,
                            height: 350,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return imageFromAssets(
                                  "./assets/images/image_loader.gif");
                            },
                            // width: window.physicalSize.width,
                            fit: BoxFit.fill,
                          )),
                ), //
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        checkForEmpty(currentArticle.title),
                        style: const TextStyle(
                          color: colorText,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ), //Title
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Published At : ",
                            style: TextStyle(
                                color: colorText, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            checkForEmpty(currentArticle.publishedAt),
                            style: const TextStyle(
                              color: colorText,
                            ),
                          ),
                        ],
                      ), //Date
                      Row(
                        children: [
                          const Text(
                            "Written By : ",
                            style: TextStyle(
                                color: colorText, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            checkForEmpty(currentArticle.author),
                            style: const TextStyle(color: colorText),
                          ),
                        ],
                      ), //author
                      Divider(
                        color: colorTeal,
                        indent: 2,
                      ),

                      Text(
                        checkForEmpty(currentArticle.description),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colorText,
                            fontSize: 16),
                      ), //Description
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        checkForEmpty(filter(currentArticle.content)),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: colorText,
                        ),
                      ), //Content
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: bottomValue,
          left: 165,
          child: Draggable(
            childWhenDragging: const Text(""),
            axis: Axis.vertical,
            // affinity: Axis.vertical,
            onDragEnd: (value) {
              // print(value);
              if (currentArticle.url != "Empty") {
                _launchURL(currentArticle.url);
              } else {
                // print("No url to go");
                // Add a toast or pop up type to show that could not go to url
              }
            },
            child: Icon(
              CupertinoIcons.arrow_up_to_line,
              color: colorBrown,
              size: 50,
            ),
            feedback: Icon(
              CupertinoIcons.arrow_up_to_line,
              color: colorTeal,
              size: 50,
            ),
          ),
        )
      ]),
    );
  }

  String checkForEmpty(String content) {
    if (content == "Empty") {
      return "No Data is Available for this news";
    }
    return content;
  }

  void _launchURL(url) async {
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $_url';
    try {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } catch (e) {
      // print(e);
    }
  }

  String filter(String content) {
    String afterContent = content;
    for (var i = content.length - 1; i >= 0; i--) {
      var ch = content[i];
      if (ch == '[') {
        afterContent = afterContent.substring(0, i);
        break;
      }
    }
    return afterContent;
  }

  Widget imageFromAssets(String source) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        source,
        fit: BoxFit.fill,
        height: 350,
      ),
    );
  }
}
