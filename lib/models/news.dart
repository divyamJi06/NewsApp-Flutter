class News {
  News({
    required this.status,
    required this.totalResults,
    required this.articles,
  });
  late final String status;
  late final int totalResults;
  late final List<Articles> articles;

  News.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 'Empty';
    totalResults = json['totalResults'] ?? 0;
    articles =
        List.from(json['articles']).map((e) => Articles.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['totalResults'] = totalResults;
    _data['articles'] = articles.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Articles {
  Articles({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });
  late final Source source;
  late final String author;
  late final String title;
  late final String description;
  late final String url;
  late final String urlToImage;
  late final String publishedAt;
  late final String content;

  Articles.fromJson(Map<String, dynamic> json) {
    source = Source.fromJson(json['source']);
    author = json['author'] ?? 'Anonymous';
    title = json['title'] ?? 'Empty';
    // if(description==null)

    description = json['description'] ?? 'Empty';
    url = json['url'] ?? 'Empty';
    urlToImage = json['urlToImage'] ?? 'Empty';
    publishedAt = json['publishedAt'] ?? 'Date Not Known';
    content = json['content'] ?? 'Empty';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['source'] = source.toJson();
    _data['author'] = author;
    _data['title'] = title;
    _data['description'] = description;
    _data['url'] = url;
    _data['urlToImage'] = urlToImage;
    _data['publishedAt'] = publishedAt;
    _data['content'] = content;
    return _data;
  }
}

class Source {
  Source({
    required this.id,
    required this.name,
  });
  late final String id;
  late final String name;

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 'Anonymous';
    name = json['name'] ?? 'Anonymous';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
