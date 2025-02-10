import 'package:flutter/material.dart';

class Word extends StatefulWidget {
  final String title;

  const Word({
    super.key,
    required this.title,
  });

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> {
  bool _isExpanded = false; // 텍스트 확장 여부를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded; // 상태 변경
          });
        },
        child: Text(
          widget.title,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: _isExpanded ? 999 : 1,
        ),
      ),
    );
  }
}
