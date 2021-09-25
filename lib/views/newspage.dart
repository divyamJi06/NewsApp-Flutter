import 'package:flutter/material.dart';
import 'package:newsapp/models/news.dart';

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
      backgroundColor: Colors.teal[800],
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentArticle.urlToImage == "Empty"
                    ? Image.asset(
                        "./assets/images/image_loader.gif",
                      )
                    : Image.network(currentArticle.urlToImage), //Image
                const SizedBox(
                  height: 10,
                ),
                Text(
                  currentArticle.title,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ), //Title
                const SizedBox(
                  height: 8,
                ),
                Text(
                  currentArticle.publishedAt,
                  style: TextStyle(color: Colors.amber),
                ), //Date
                Text(
                  "By " + currentArticle.author!,
                  style: TextStyle(color: Colors.amber),
                ), //author
                const Divider(),

                Text(
                  currentArticle.description,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.amber,
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
                    color: Colors.amber,
                  ),
                ), //Content
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  child: const Text("Button will work soon"),
                  onPressed: () {
                    // go to newsUrl
                    //go to news
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
}
