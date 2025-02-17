import 'package:flutter/material.dart';
import 'package:greate_word/models/quote.dart';

class QuoteItem extends StatelessWidget {
  final Quote quote;

  const QuoteItem({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(quote.quote),
      subtitle: Text("- ${quote.author} -"),
      trailing: Icon(
        quote.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: quote.isFavorite ? Colors.red : Colors.grey,
      ),
      onTap: () {
        // 찜하기/해제 버튼을 눌렀을 때
      },
    );
  }
}
