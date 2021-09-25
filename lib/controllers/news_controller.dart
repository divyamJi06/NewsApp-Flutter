import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:newsapp/models/news.dart';

class GetNews {
  String url = "https://newsapi.org/v2/top-headlines";
  Future<News> fetchNews(
      var category, var country, var apiKey, var page, var pageCount) async {
    Response response = await Dio().get(url, queryParameters: {
      "category": category,
      "country": country,
      "apiKey": apiKey,
      "page": page,
      "pageCount": pageCount
    });
    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.toString()));
    } else {
      throw Exception('Failed to load news');
    }
  }
}
