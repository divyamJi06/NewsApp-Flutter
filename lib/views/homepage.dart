// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:newsapp/controllers/news_controller.dart';
import 'package:newsapp/utils/constants.dart';
import 'package:newsapp/views/newspage.dart';
import '../models/news.dart';
import '../strings/strings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<News> futureNews;
  late List<Articles> articles;
  late var apiKey;
  String category = "sports";
  var page = 1;
  var pageCount = 20;
  String country = "in";
  String link = "Read More";
  List<String> categories = [
    "general",
    "business",
    "technology",
    "science",
    "health",
    "sports",
    "entertainment"
  ];
  Map<String, String> countriesName = {
    "India": "in",
    "USA": "us",
    "UK": "uk",
    "Argentina": "ar",
    "Portugal": "pt",
    "Hong Kong": "hk",
    "Israel": "il",
    "China": "cn",
    "Singapore": "sg",
    "France": "fr",
  };
  LanguageIn languageIn = LanguageIn();
  GetNews getNews = GetNews();
  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env["NEWS_API_KEY"];
    futureNews = getNews.fetchNews(category, country, apiKey, page, pageCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text(languageIn.appHome),
        actions: [
          DropdownButton<String>(
            value: category,
            onChanged: (var newValue) {
              // showToast();
              setState(() {
                category = newValue!;
                futureNews = getNews.fetchNews(
                    category, country, apiKey, page, pageCount);

                futureResult();
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value[0].toUpperCase() + value.substring(1)),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: country,
            onChanged: (var newValue) {
              setState(() {
                country = newValue!;
                futureNews = getNews.fetchNews(
                    category, country, apiKey, page, pageCount);
                futureResult();
              });
            },
            items: countriesName.keys
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: countriesName[value],
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
      body: futureResult(),
      backgroundColor: colorBlack,
    );
  }

  Widget futureResult() {
    return FutureBuilder<News>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return listTypeView(snapshot.data!.articles);
        } else if (snapshot.hasError) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              "Could Not get data from server , Please check your Internet Connection",
              style: TextStyle(
                  color: colorText, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget listTypeView(var newsList) {
    articles = newsList;
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return Card(
            color: colorBG,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NewsPage(
                    articles: articles,
                    index: index,
                  );
                }));
              },
              child: NewsElement(
                  imageUrl: newsList[index].urlToImage,
                  title: newsList[index].title),
            ));
      },
    );
  }

  // void showToast() {
  //
  //   Fluttertoast.showToast(
  //       msg: "Loading $category news",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.yellow);
  // }
}

class NewsElement extends StatelessWidget {
  const NewsElement({Key? key, required this.imageUrl, required this.title})
      : super(key: key);

  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: imageUrl == "Empty"
                ? imageFromAssets("./assets/images/image_not_found.png")
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return imageFromAssets(
                            "./assets/images/image_loader.gif");
                      },
                      fit: BoxFit.fill,
                      height: 70,
                      width: 100,
                    ),
                  ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: colorText, fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
    );
  }

  Widget imageFromAssets(String source) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        source,
        fit: BoxFit.fill,
        height: 70,
        width: 100,
      ),
    );
  }
}
