import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/pages/newspage.dart';
import '../models/news.dart';
import '../strings/strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<News> futureNews;
  late News news;
  var apiKey;
  String category = "sports";
  var page = 1;
  var pageCount = 20;
  String url = "https://newsapi.org/v2/top-headlines";
  String country = "in";
  String link = "Read More";
  List articles = [];
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
  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env["NEWS_API_KEY"];
    futureNews = fetchNews();
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
                  futureNews = fetchNews();
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
                  futureNews = fetchNews();
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
        body: futureResult());
  }

  Widget futureResult() {
    return FutureBuilder<News>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return listTypeView(snapshot.data!.articles);
          // Text(snapshot.data!.articles[0].title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget listTypeView(var newsList) {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(newsList[index].title),
            subtitle: Text(newsList[index].description),
            leading: CircleAvatar(
                child: newsList[index].urlToImage == "Empty"
                    ? Text(newsList[index].title[0].toString())
                    : Image.network(newsList[index].urlToImage)),
            trailing: Text(link),
            isThreeLine: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewsPage(
                    source: newsList[index].source.name,
                    date: newsList[index].publishedAt,
                    author: newsList[index].author,
                    content: newsList[index].content,
                    title: newsList[index].title,
                    description: newsList[index].description,
                    imageUrl: newsList[index].urlToImage,
                    newsUrl: newsList[index].url);
                // Go to dedicated page for the news and in order to read more then send them to the link
              }));
            },
          ),
        );
      },
    );
  }

  Future<News> fetchNews() async {
    Response response = await Dio().get(url, queryParameters: {
      "category": category,
      "country": country,
      "apiKey": apiKey,
      "page": page,
      "pageCount": pageCount
    });
    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.toString()));
    } else {
      throw Exception('Failed to load news');
    }
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
