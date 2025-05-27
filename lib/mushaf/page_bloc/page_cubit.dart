import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/data.dart';
import '../modules/line.dart';
import '../modules/note.dart';
import 'package:quran/quran.dart' as quran;
import 'page_states.dart';

class PageCubit extends Cubit<PageStates> {
  int pageNumber = 3;
  List<Line> pageLines = [];
  List<Note> notes = [];
  int startPage = 0;
  final String studentId;
  final Set<String> _highlightedWords = {}; // For tracking highlighted words

  PageCubit(Function() initialState, this.studentId) : super(initialState()) {
    if (initialState() is InitialMultiPageState) {
      pageNumber = (initialState() as InitialMultiPageState).startPage;
      startPage = pageNumber;
    } else if (initialState() is InitialOnePageState) {
      pageNumber = (initialState() as InitialOnePageState).pageNumber;
    }
    initialPage();
  }

  void initialPage() {
    emit(LoadingPageState());
    int start = -1;
    int end = -1;
    pageLines = [];
    if (pageNumber == 1) {
      start = 0;
      end = 8;
    } else if (pageNumber == 2) {
      start = 8;
      end = 16;
    } else {
      start = 16 + 15 * (pageNumber - 3);
      end = 16 + 15 * (pageNumber - 3) + 15;
    }
    List<String> lines = mushafLines.sublist(start, end);
    int lineNumber = 0;
    lines.forEach((line) {
      lineNumber++;
      pageLines.add(
        Line(text: line, pageNumber: pageNumber, lineNumber: lineNumber),
      );
    });

    emit(SuccessPageState());
  }

  void saveNote({
    required int lineNumber,
    required int wordOrder,
    required String falseType,
  }) {
    notes.add(
      Note(
        pageNumber: pageNumber,
        lineNumber: lineNumber,
        wordNumber: wordOrder,
        falseType: falseType,
      ),
    );
  }

  void highlightWord({required int lineNumber, required int wordOrder}) {
    _highlightedWords.add('$lineNumber-$wordOrder');
    emit(WordHighlightPageState(highlightedWords: _highlightedWords));
  }

  void unhighlightWord({required int lineNumber, required int wordOrder}) {
    _highlightedWords.remove('$lineNumber-$wordOrder');
    emit(WordHighlightPageState(highlightedWords: _highlightedWords));
  }

  bool isHighlighted(int lineNumber, int wordOrder) {
    return _highlightedWords.contains('$lineNumber-$wordOrder');
  }

  String surNames() {
    List pagesData = quran.getPageData(pageNumber);

    String text = "";
    for (var pageD in pagesData) {
      text += "${quran.getSurahNameArabic(pageD["surah"])},";
    }
    return text.substring(0, text.length - 1);
  }

  void changeToPage({required int number}) {
    pageNumber = startPage + number;
    initialPage();
  }

  void savePageTest() {}

  String tajweedNotes() {
    return notes
        .where((note) => note.falseType == FalseTypes.tajweed)
        .length
        .toString();
  }

  String tashkeelNotes() {
    return notes
        .where((note) => note.falseType == FalseTypes.tashkeel)
        .length
        .toString();
  }

  String hafezNotes() {
    return notes
        .where((note) => note.falseType == FalseTypes.hafez)
        .length
        .toString();
  }

  Color containerColor({
    required int wordOrder,
    required int lineNumber,
    required Color defaultColor,
  }) {
    if (notes
        .where(
          (note) =>
              (note.lineNumber == lineNumber &&
                  note.wordNumber == wordOrder &&
                  note.pageNumber == pageNumber),
        )
        .isEmpty) {
      return defaultColor;
    }
    Note note =
        notes.where(
              (note) =>
                  (note.lineNumber == lineNumber &&
                      note.wordNumber == wordOrder &&
                      note.pageNumber == pageNumber),
            ).single;
    if (note.falseType == FalseTypes.hafez) {
      return Colors.red[100]!;
    } else if (note.falseType == FalseTypes.tajweed) {
      return Colors.green[100]!;
    } else {
      return Colors.black12;
    }
  }
}
