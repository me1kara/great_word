import 'package:flutter/material.dart';
import 'package:greate_word/models/quote.dart';
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

  List<Quote> quotes = [];
  Quote? currentQuote;

  @override
  void initState() {
    super.initState();
    _loadSetting();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    List<Quote> loadedQuotes = await QuotesLoader.loadQuotes();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('좋은말'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WordsScreen(
                            quotes: quotes,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade100, // 텍스트 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                ),
              ),
              child: const Text(
                '목록',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: currentQuote == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
