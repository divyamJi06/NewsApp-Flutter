import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/utils/constants.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({
    Key? key,
    required this.articles,
    required this.index,
  }) : super(key: key);

  final List<Articles> articles;
  final int index;

  @override
  Widget build(BuildContext context) {
    var currentArticle = articles[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(currentArticle.source.name),
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
                        currentArticle.title,
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
                            currentArticle.publishedAt,
                            style: const TextStyle(
                              color: colorText,
                            ),
                          ),
                        ],
                      ), //Date
                      Row(
                        children: [
                          const Text(
                            "Source : ",
                            style: TextStyle(
                                color: colorText, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "By " + currentArticle.author!,
                            style: const TextStyle(color: colorText),
                          ),
                        ],
                      ), //author
                      Divider(
                        color: colorTeal,
                        indent: 2,
                      ),

                      Text(
                        currentArticle.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colorText,
                            fontSize: 16),
                      ), //Description
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        filter(currentArticle.content!),
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
          bottom: 20,
          left: 165,
          child: GestureDetector(
            onTap: () {
              // print("Tapped");
            },
            child: Icon(
              CupertinoIcons.arrow_up_to_line,
              color: colorTeal,
              size: 50,
            ),
          ),
        )
      ]),
    );
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
