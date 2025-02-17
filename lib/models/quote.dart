import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Quote {
  final String id;
  final String quote;
  final String author;
  final String category;
  bool isFavorite;

  Quote(
      {required this.id,
      required this.quote,
      required this.author,
      required this.category,
      required this.isFavorite});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
      category: json['category'],
      isFavorite: json['isFavorite'],
    );
  }
  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
      'category': category,
      'isFavorite': isFavorite,
    };
  }
}

class QuotesManager {
  List<Quote> quotes = [];

  // 📌 JSON에서 명언 불러오기
  Future<void> loadQuotes() async {
    final String response = await rootBundle.loadString('assets/quotes.json');
    List<dynamic> data = json.decode(response);
    quotes = data.map((e) => Quote.fromJson(e)).toList();
    await loadFavorites(); // 저장된 찜 데이터 반영
  }

  // 📌 찜한 명언 ID 저장
  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds =
        quotes.where((q) => q.isFavorite).map((q) => q.id).toList();
    await prefs.setStringList('favorite_quotes', favoriteIds);
  }

  // 📌 찜한 명언 불러오기
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favorite_quotes') ?? [];
    for (var quote in quotes) {
      if (favoriteIds.contains(quote.id)) {
        quote.isFavorite = true;
      }
    }
  }

  // 📌 특정 명언 찜 상태 변경
  Future<void> toggleFavorite(String id) async {
    for (var quote in quotes) {
      if (quote.id == id) {
        quote.isFavorite = !quote.isFavorite;
        await saveFavorites();
        break;
      }
    }
  }
}
