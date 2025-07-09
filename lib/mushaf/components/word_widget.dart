import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/note.dart';
import '../page_bloc/page_cubit.dart';
import '../page_bloc/page_states.dart';

class WordWidget extends StatelessWidget {
  String word;
  final bool canPress;
  final int wordOrder;
  final int lineNumber;

  WordWidget({
    super.key,
    required this.word,
    required this.canPress,
    required this.wordOrder,
    required this.lineNumber,
  });

  void _showOptions(BuildContext context, TapDownDetails details) async {
    if (!canPress) return;

    final cubit = context.read<PageCubit>();
    cubit.highlightWord(lineNumber: lineNumber, wordOrder: wordOrder);

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      context: context,

      constraints: const BoxConstraints(minWidth: 20, maxWidth: 60),
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      menuPadding: EdgeInsets.zero,
      items: [
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          value: FalseTypes.tashkeel,
          height: 30,
          child: Center(
            child: Container(
              height: 30,
              width: 60,
              color: Colors.black12,
              child: Center(child: Text("تشكيل")),
            ),
          ),
        ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,

          value: FalseTypes.tajweed,
          height: 30,
          child: Center(
            child: Container(
              height: 30,
              width: 60,
              color: Colors.green[100],
              child: Center(child: Text("تجويد")),
            ),
          ),
        ),
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,

          value: FalseTypes.hafez,
          height: 30,
          child: Center(
            child: Container(
              height: 30,
              width: 60,
              color: Colors.red[100],
              child: Center(child: Text("حفظ")),
            ),
          ),
        ),
      ],
    );

    cubit.unhighlightWord(lineNumber: lineNumber, wordOrder: wordOrder);

    if (selected != null) {
      cubit.saveNote(
        lineNumber: lineNumber,
        wordOrder: wordOrder,
        falseType: selected,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String splitter = containNumber();

    return BlocBuilder<PageCubit, PageStates>(
      buildWhen: (previous, current) => current is WordHighlightPageState,
      builder: (context, state) {
        bool isHighlighted = false;
        if (state is WordHighlightPageState) {
          isHighlighted = state.highlightedWords.contains(
            '$lineNumber-$wordOrder',
          );
        }
        Color defaultColor =
            isHighlighted ? Colors.yellowAccent : Colors.transparent;

        List<Color> gradientColors = context.read<PageCubit>().containerColor(
          wordOrder: wordOrder,
          lineNumber: lineNumber,
          defaultColor: defaultColor,
        );

        return GestureDetector(
          onTapDown: (details) => _showOptions(context, details),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  word,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontFamily: "uthmani", fontSize: 18),
                ),
              ),
              splitter.isNotEmpty
                  ? Text(
                    splitter,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontFamily: "uthmani", fontSize: 18),
                  )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  String containNumber() {
    List numbers = [
      '٦',

      '١',

      '٠',

      '٩',
      '٨',
      '٧',
      '٥',
      '٤',
      '٣',
      '٢',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
      '1',
      '2',
      '3',
    ];
    String num = "";
    int index = 3;
    while (index > 0) {
      String hh = num;

      for (var number in numbers) {
        if (word.substring(word.length - 2, word.length - 1).contains(" ")) {
          word = word.replaceRange(word.length - 2, word.length - 1, "");
        }
        print(word.characters.last==number.toString());
        if (word.characters.last == number.toString()) {

          word = word.replaceFirst(word.characters.last, "");
          num = number.toString() + num;
          break;
        }
      }
      if (hh == num) {
        index = 0;
      } else {
        index--;
      }
    }
    return num;
  }
}
