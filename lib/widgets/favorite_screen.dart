import 'package:flutter/material.dart';
import 'package:greate_word/models/quote.dart';
import 'package:greate_word/widgets/quote_item.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Quote> favoriteQuotes;

  const FavoriteScreen({super.key, required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('찜목록'),
        centerTitle: true,
      ),
      body: favoriteQuotes.isEmpty
          ? const Center(child: Text("찜한 말이 없습니다."))
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                return QuoteItem(quote: favoriteQuotes[index]);
              },
            ),
    );
  }
}
