import 'package:flutter/material.dart';
import 'package:newsapp/controllers/news_controller.dart';
import 'package:newsapp/utils/constants.dart';
import 'package:newsapp/views/news_element.dart';
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
  List<Articles> articles = List.empty(growable: true);
  // ignore: prefer_typing_uninitialized_variables
  late var apiKey;
  var moreNewsAvailable = true;
  String category = "sports";
  var page = 1;
  var pageUpdate = 1;
  var totalResults = 0;
  var pageSize = 20;
  String country = "in";
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
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env["NEWS_API_KEY2"];
    futureNews = getNews.fetchNews(category, country, apiKey, page, pageSize);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          if (page * pageSize < totalResults) {
            print("End of page $page reached");
            updateArticles();
          } else {
            moreNewsAvailable = false;
          }
        }
      }
    });
  }
  void updateArticles() async {
    setState(() {
      page++;
      futureNews = getNews.fetchNews(category, country, apiKey, page, pageSize);
      futureResult();
    });
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            languageIn.appHome,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: LinearProgressIndicator(
            // backgroundColor: colorBlack,
            valueColor: AlwaysStoppedAnimation<Color>(colorBlack),
            value: 0.5,
          ),
        ),
        actions: [
          // IconButton(
          //     icon: const Icon(Icons.search),
          //     onPressed: () {
          //       print("S");
          //       futureNews = getNews.fetchNewsWithQuery(
          //           category, country, apiKey, page, pageSize, "Alia");
          //       futureResult();
          //     }),
          Container(
            padding: const EdgeInsets.only(left: 12),
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
            decoration: BoxDecoration(
                color: colorBlack, borderRadius: BorderRadius.circular(12)),
            child: DropdownButton<String>(
              dropdownColor: (Colors.black),
              style: const TextStyle(color: colorText),
              borderRadius: BorderRadius.circular(12),
              value: category,
              onChanged: (var newValue) {
                // showToast();
                setState(() {
                  articles = [];
                  page = 1;
                  category = newValue!;
                  futureNews = getNews.fetchNews(
                      category, country, apiKey, page, pageSize);

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
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
                color: colorBlack, borderRadius: BorderRadius.circular(12)),
            child: DropdownButton<String>(
              dropdownColor: (Colors.black),
              style: const TextStyle(color: colorText),
              borderRadius: BorderRadius.circular(12),
              value: country,
              onChanged: (var newValue) {
                setState(() {
                  country = newValue!;
                  page = 1;
                  articles = [];
                  futureNews = getNews.fetchNews(
                      category, country, apiKey, page, pageSize);
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
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              futureResult(),
            ],
          ),
        ),
      ),
      backgroundColor: colorBrown,
    );
  }

  Widget futureResult() {
    return FutureBuilder<News>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          totalResults = snapshot.data!.totalResults;
          return listTypeView(snapshot.data!.articles);
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              "Could Not get data from server , Please check your Internet Connection",
              style: TextStyle(
                  color: colorText, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }
        return CircularProgressIndicator(
          color: colorBlack,
        );
      },
    );
  }

  Widget listTypeView(var newsList) {
    // articles.addAll(newsList);
    articles = newsList;
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          if (index == articles.length - 1 && moreNewsAvailable)
            return Center(child: CircularProgressIndicator(
              color:colorBlack
            ));
          return Card(
              color: colorBlack,
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
                    imageUrl: articles[index].urlToImage,
                    title: articles[index].title),
              ));
        },
      ),
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
