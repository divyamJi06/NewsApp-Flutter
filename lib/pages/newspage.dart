import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.author,
    required this.newsUrl,
    required this.source,
    required this.content,
  }) : super(key: key);
  final String title;
  final String description;
  final String content;
  final String date;
  final String author;
  final String source;
  final String imageUrl;
  final String newsUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(source),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(imageUrl), //Image
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ), //Title
            SizedBox(
              height: 8,
            ),
            Text(date), //Date
            Text("By " + author), //author
            Divider(),

            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ), //Description
            SizedBox(
              height: 10,
            ),
            Text(
              filter(content),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ), //Content
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              child: Text("Button will work soon"),
              onPressed: () {
                // go to newsUrl
                //go to news
              },
            ),
          ],
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
