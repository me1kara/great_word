import 'package:flutter/material.dart';
import 'package:greate_word/models/quote.dart';
import 'package:greate_word/widgets/favorite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greate_word/widgets/words_screen.dart';
import 'package:flutter/services.dart'; // 플랫폼 채널 사용

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '좋은말',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RandomQuoteScreen(),
    );
  }
}

class RandomQuoteScreen extends StatefulWidget {
  const RandomQuoteScreen({super.key});

  @override
  _RandomQuoteScreenState createState() => _RandomQuoteScreenState();
}

class _RandomQuoteScreenState extends State<RandomQuoteScreen> {
  static const platform = MethodChannel('foreground_service');
  bool _isForegroundEnabled = false;
  QuotesManager manager = QuotesManager();

  List<Quote> quotes = [];
  Quote? currentQuote;

  @override
  void initState() {
    super.initState();
    _loadSetting();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    await manager.loadQuotes();
    List<Quote> loadedQuotes = manager.quotes;

    setState(() {
      quotes = loadedQuotes;
      _generateRandomQuote(); // 앱 실행 시 랜덤 명언 표시
    });
  }

  void _generateRandomQuote() {
    if (quotes.isNotEmpty) {
      setState(() {
        currentQuote = quotes[
            (quotes.length * DateTime.now().millisecond / 1000).floor() %
                quotes.length];
      });
    }
  }

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isForegroundEnabled = prefs.getBool('foregroundEnabled') ?? false;
    });
  }

  Future<void> _toggleForeground(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('foregroundEnabled', value);

    try {
      if (value) {
        await platform.invokeMethod('startService');
      } else {
        await platform.invokeMethod('stopService');
      }
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }

    setState(() {
      _isForegroundEnabled = value;
    });
  }

  Future<void> _toggleFavorite(Quote quote) async {
    // 1. 리스트 내 해당 명언 찾기
    int index = quotes.indexWhere((q) => q.id == quote.id);
    if (index != -1) {
      // 4. 변경된 찜 목록을 저장
      await manager.toggleFavorite(quote.id);

      setState(() {
        currentQuote = quotes[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text('좋은말'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'allQuotes') {
                // 일반 목록으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordsScreen(
                      quotes: quotes,
                    ),
                  ),
                );
              } else if (value == 'favorites') {
                // 찜 목록으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteScreen(
                      favoriteQuotes: quotes,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'allQuotes',
                child: Text('일반 목록'),
              ),
              const PopupMenuItem<String>(
                value: 'favorites',
                child: Text('찜 목록'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: currentQuote == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      currentQuote!.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border, // 찜 상태에 따라 변경
                      color:
                          currentQuote!.isFavorite ? Colors.red : Colors.grey,
                      size: 50,
                    ),
                    onPressed: () {
                      _toggleFavorite(currentQuote!);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '"${currentQuote!.quote}"\n\n- ${currentQuote!.author} -',
                      style: const TextStyle(
                          fontSize: 20, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generateRandomQuote,
                    child: const Text('클릭'),
                  ),
                ],
              ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('잠금 해제 시 앱 보기'),
            Switch(
              value: _isForegroundEnabled,
              onChanged: _toggleForeground,
            ),
          ],
        ),
      ),
    );
  }
}
