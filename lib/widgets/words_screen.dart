// words_screen.dart
import 'package:flutter/material.dart';
import 'package:greate_word/models/quote.dart';
import 'package:greate_word/widgets/word.dart';

class WordsScreen extends StatelessWidget {
  const WordsScreen({super.key, required this.quotes});

  final List<Quote> quotes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text('단어 목록'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              for (var i = 0; i < quotes.length; i++)
                Word(
                    title:
                        "${i + 1}.${quotes[i].quote} \n -${quotes[i].author}-"), // 'quotes' 배열을 사용하고, 'i'는 변수로
            ],
          ),
        ),
      ),
    );
  }
}
