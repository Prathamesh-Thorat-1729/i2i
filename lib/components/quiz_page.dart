import 'package:flutter/material.dart';
import 'package:i2i/components/common_button.dart';
import 'package:i2i/components/objects/questions.dart';

class QuizPage extends StatefulWidget {
  final Question question;
  final int index;
  final int currentPageIndex;
  final VoidCallback onNext;
  final bool isLast;

  const QuizPage({
    super.key,
    required this.question,
    required this.index,
    required this.currentPageIndex,
    required this.onNext,
    required this.isLast,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    if (widget.index == widget.currentPageIndex) {
      _startTiming();
    }
  }

  @override
  void didUpdateWidget(covariant QuizPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.index == widget.currentPageIndex &&
        oldWidget.currentPageIndex != widget.currentPageIndex) {
      _startTiming();
    } else if (oldWidget.index == oldWidget.currentPageIndex &&
        widget.index != widget.currentPageIndex) {
      _stopTiming();
    }
  }

  void _startTiming() {
    _startTime = DateTime.now();
  }

  void _stopTiming() {
    final elapsed = DateTime.now().difference(_startTime).inMilliseconds;
    widget.question.timeTakenInSeconds += elapsed;
  }

  void _answerQuestion(String selectedAnswer) {
    setState(() {
      widget.question.answered = selectedAnswer;
    });
    _stopTiming();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Question Text
          Text(
            widget.question.questionString,
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Image(
                image: AssetImage(widget.question.imageId),
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Options or Answer
          Expanded(
            flex: 5,
            child:
                widget.question.options.isEmpty
                    ? Center(
                      child: Text(
                        widget.question.correctAnswer,
                        style: textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      itemCount: widget.question.options.length,
                      itemBuilder: (context, index) {
                        final option = widget.question.options[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: CommonButton(
                            onPressed: () => _answerQuestion(option),
                            text: option,
                            isOutlined: true,
                          ),
                        );
                      },
                    ),
          ),

          // Skip / Next Button
          if (widget.question.options.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 65),
              child: CommonButton(
                onPressed: () {
                  _stopTiming();
                  widget.onNext();
                },
                text: 'Skip',
              ),
            ),
        ],
      ),
    );
  }
}
