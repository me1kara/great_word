import 'package:flutter/material.dart';
import 'package:greate_word/widgets/words_screen.dart';

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
  final List<String> quotes = [
    "삶이 있는 한 희망은 있다. - 키케로",
    "산다는 것은 치열한 전투이다. - 로망 롤랑",
    "하루에 3시간을 걸으면 7년 후에 지구를 한 바퀴 돌 수 있다. - 사무엘 존슨",
    "언제나 현재에 집중할 수 있다면 행복할 것이다. - 파울로 코엘료",
    "진정으로 웃으려면 고통을 참아야 하며, 나아가 고통을 즐길 줄 알아야 한다. - 찰리 채플린",
    "직업에서 행복을 찾아라. 아니면 행복이 무엇인지 절대 모를 것이다. - 엘버트 허버드",
    "신은 용기 있는 자를 결코 버리지 않는다. - 켄러",
    "행복의 문이 하나 닫히면 다른 문이 열린다. 그러나 우리는 종종 닫힌 문을 멍하니 바라보다가 우리를 향해 열린 문을 보지 못하게 된다. - 헬렌 켈러",
    "피할 수 없으면 즐겨라. - 로버트 엘리엇",
    "단순하게 살아라. 현대인은 쓸데없는 절차와 일 때문에 얼마나 복잡한 삶을 살아가는가? - 이드리스 샤흐",
    "먼저 자신을 비웃어라. 다른 사람이 당신을 비웃기 전에. - 엘사 맥스웰",
    "먼저 핀 꽃은 먼저 진다. 남보다 먼저 공을 세우려고 조급히 서두르지 마라. - 채근담",
    "행복한 삶을 살기 위해 필요한 것은 거의 없다. - 마르쿠스 아우렐리우스 안토니우스",
    "절대 어제를 후회하지 마라. 인생은 오늘의 나 안에 있고 내일은 스스로 만드는 것이다. - L. 론 허바드",
    "어리석은 자는 멀리서 행복을 찾고, 현명한 자는 자신의 발치에서 행복을 키워간다. - 제임스 오펜하임",
    "너무 소심하고 까다롭게 자신의 행동을 고민하지 마라. 모든 인생은 실험이다. 더 많이 실험할수록 더 나아진다. - 랄프 왈도 에머슨",
    "한 번의 실패와 영원한 실패를 혼동하지 마라. - F. 스콧 피츠제럴드",
    "내일은 내일의 태양이 뜬다.",
    "계단을 밟아야 계단 위에 올라설 수 있다. - 터키 속담",
    "오랫동안 꿈을 그리는 사람은 마침내 그 꿈을 닮아 간다. - 앙드레 말로",
    "좋은 성과를 얻으려면 한 걸음 한 걸음이 힘차고 충실하지 않으면 안 된다. - 단테",
    "행복은 습관이다. 그것을 몸에 지니라. - 허버드",
    "성공의 비결은 단 한 가지, 잘할 수 있는 일에 광적으로 집중하는 것이다. - 톰 모나건",
    "자신감 있는 표정을 지으면 자신감이 생긴다. - 찰스 다윈",
    "평생 살 것처럼 꿈을 꾸어라. 그리고 내일 죽을 것처럼 오늘을 살아라. - 제임스 딘",
    "네 믿음은 네 생각이 된다. 네 생각은 네 말이 된다. 네 말은 네 행동이 된다. 네 행동은 네 습관이 된다. 네 습관은 네 가치가 된다. 네 가치는 네 운명이 된다. - 간디",
    "일하는 시간과 노는 시간을 뚜렷이 구분하라. 시간의 중요성을 이해하고 매 순간을 즐겁게 보내고 유용하게 활용하라. 그러면 젊은 날은 유쾌함으로 가득 찰 것이고 늙어서도 후회할 일이 적어질 것이며, 비록 가난할 때라도 인생을 아름답게 살아갈 수 있다. - 루이사 메이 올컷",
    "절대 포기하지 말라. 당신이 되고 싶은 무언가가 있다면, 그에 대해 자부심을 가져라. 당신 자신에게 기회를 주어라. 스스로가 형편없다고 생각하지 말라. 그래 봐야 아무것도 얻을 것이 없다. 목표를 높이 세워라. 인생은 그렇게 살아야 한다. - 마이크 맥라렌",
    "1퍼센트의 가능성, 그것이 나의 길이다. - 나폴레옹",
    "그대 자신의 영혼을 탐구하라. 다른 누구에게도 의지하지 말고 오직 그대 혼자의 힘으로 하라. - 인디언 속담",
    "고통이 남기고 간 뒤를 보라! 고난이 지나면 반드시 기쁨이 스며든다. - 괴테",
    "삶은 소유물이 아니라 순간순간의 있음이다. 영원한 것이 어디 있는가? 모두가 한때일 뿐, 그러나 그 한때를 최선을 다해 최대한으로 살아야 한다. - 법정 스님",
    "꿈을 계속 간직하고 있으면 반드시 실현할 때가 온다. - 괴테",
    "화려한 일을 추구하지 말라. 중요한 것은 스스로의 재능이며, 자신의 행동에 쏟아 붓는 사랑의 정도이다. - 마더 테레사",
    "마음만을 가지고 있어서는 안 된다. 반드시 실천하여야 한다. - 이소룡",
    "흔히 사람들은 기회를 기다리고 있지만 기회는 기다리는 사람에게 잡히지 않는다. 우리는 기회를 기다리는 사람이 되기 전에 기회를 얻을 수 있는 실력을 갖춰야 한다. - 안창호",
    "고개 숙이지 마십시오. 세상을 똑바로 정면으로 바라보십시오. - 헬렌 켈러",
    "행복은 결코 많고 큰 데만 있는 것이 아니다. 작은 것을 가지고도 고마워하고 만족할 줄 안다면 그는 행복한 사람이다. - 법정 스님",
    "용기 있는 자로 살아라. 운이 따라주지 않는다면 용기 있는 가슴으로 불행에 맞서라. - 키케로",
    "최고에 도달하려면 최저에서 시작하라. - P. 시루스",
    "내 비장의 무기는 아직 손안에 있다. 그것은 희망이다. - 나폴레옹",
    "삶을 사는 데는 단 두 가지 방법이 있다. 하나는 기적이 전혀 없다고 여기는 것이고, 또 다른 하나는 모든 것이 기적이라고 여기는 방식이다. - 알베르트 아인슈타인"
  ];

  String currentQuote = "버튼을 눌러 명언을 확인하세요!";

  @override
  void initState() {
    super.initState();
    _generateRandomQuote(); // 앱이 시작될 때 명언 생성
  }

  void _generateRandomQuote() {
    setState(() {
      currentQuote = quotes[
          (quotes.length * DateTime.now().millisecond / 1000).floor() %
              quotes.length];
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentQuote,
                style:
                    const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
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
    );
  }
}
