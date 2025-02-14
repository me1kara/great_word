import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Quote {
  final String quote;
  final String author;
  final String category;
  bool isFavorite;

  Quote(
      {required this.quote,
      required this.author,
      required this.category,
      required this.isFavorite});

  factory Quote.fromJson(Map<String, dynamic> json) {
    print(json);
    return Quote(
      quote: json['quote'],
      author: json['author'],
      category: json['category'],
      isFavorite: json['isFavorite'],
    );
  }
  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'quote': quote,
      'author': author,
      'category': category,
      'isFavorite': isFavorite,
    };
  }
}

class QuotesLoader {
  static Future<List<Quote>> loadQuotes() async {
    final String response = await rootBundle.loadString('assets/quotes.json');
    final data = json.decode(response);
    // quotesJson이 실제로 List<Map<String, dynamic>> 형태여야 합니다.
    List<dynamic> quotesJson = data;
    // 올바르게 형 변환 후 List<Quote>로 변환
    return quotesJson.map((json) {
      if (json is Map<String, dynamic>) {
        return Quote.fromJson(json); // 올바른 형식으로 변환
      } else {
        throw Exception('Invalid format');
      }
    }).toList();
  }
}
