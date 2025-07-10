import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohud/mushaf/core/api_service.dart';
import 'package:ohud/themes/custom_exception.dart';
import 'package:ohud/themes/error_codes.dart';
import '../core/data.dart';
import '../modules/line.dart';
import '../modules/note.dart';
import 'package:quran/quran.dart' as quran;
import 'page_states.dart';

class PageCubit extends Cubit<PageStates> {
  int pageNumber = 3;
  List<Line> pageLines = [];
  int startPage = -1;

  List<Note> get notes => allNotes[currentDate] ?? [];
  String currentDate = "";
  String todayDate = "current";
  final String studentId;
  String studentName = "";

  final Set<String> _highlightedWords = {};

  List<String> get datesValues => allNotes.keys.toList();

  PageCubit(Function() initialState, this.studentId) : super(initialState()) {
    if (initialState() is InitialMultiPageState) {
      pageNumber = (initialState() as InitialMultiPageState).startPage;
      startPage = pageNumber;
    } else if (initialState() is InitialOnePageState) {
      pageNumber = (initialState() as InitialOnePageState).pageNumber;
    }
    initialPage();
  }

  Map<String, List<Note>> allNotes = {};


  bool get isCurrent => todayDate == currentDate;

  Future<void> initialPage() async {
    try {
      emit(LoadingPageState());

      allNotes.addAll({todayDate: []});
      currentDate = todayDate;
      var response = await ApiService.getDetails(
        pageNumber: pageNumber,
        studentId: studentId,
      );
      studentName = response.keys.single;
      for (var listen in response.values.single) {
        allNotes.addAll({
          listen["created_at"].substring(0, 15): Note.getListFromObject(
            listen["mistakes"],
          ),
        });
      }
      getPageData();

      emit(SuccessPageState());
    } catch (e) {
      emit(FailToStartPage(error: e.toString()));
    }
  }

  void getPageData() {
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
    for (var line in lines) {
      lineNumber++;
      pageLines.add(
        Line(text: line, pageNumber: pageNumber, lineNumber: lineNumber),
      );
    }
  }

  void saveNote({
    required int lineNumber,
    required int wordOrder,
    required String falseType,
  }) {
    if (currentDate == todayDate) {
      notes.add(
        Note(
          pageNumber: pageNumber,
          lineNumber: lineNumber,
          wordNumber: wordOrder,
          falseType: falseType,
        ),
      );
    }
  }

  void highlightWord({required int lineNumber, required int wordOrder}) {
    if (currentDate == todayDate) {
      _highlightedWords.add('$lineNumber-$wordOrder');
      emit(WordHighlightPageState(highlightedWords: _highlightedWords));
    }
  }

  void unhighlightWord({required int lineNumber, required int wordOrder}) {
    if (currentDate == todayDate) {
      _highlightedWords.remove('$lineNumber-$wordOrder');
      emit(WordHighlightPageState(highlightedWords: _highlightedWords));
    }
  }

  bool isHighlighted(int lineNumber, int wordOrder) {
    return _highlightedWords.contains('$lineNumber-$wordOrder');
  }

  String surNames() {
    if (pageNumber > 604 || pageNumber < 1) return "";
    List pagesData = quran.getPageData(pageNumber);

    String text = "";
    for (var pageD in pagesData) {
      text += "${quran.getSurahNameArabic(pageD["surah"])},";
    }
    return text.substring(0, text.length - 1);
  }

  void changeToPage({required int number}) {
    pageNumber = startPage + number;
    getPageData();
    emit(SuccessPageState());
  }

  Future<void> savePageTest() async {
    if (currentDate == todayDate) {
      emit(LoadingPageState());
      try {
        String result = await ApiService.saveNotes(
          pageNumber: pageNumber,
          notes: notes,
          studentId: studentId,
          isOneTest: startPage == -1,
        );
        emit(CompletedListenState(result));
      } catch (e) {
        emit(FailurePageState(error: e.toString()));
      }
    }
  }

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

  List<Color> containerColor({
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
      return [defaultColor, defaultColor];
    }
    List<Note> currentNotes =
        notes
            .where(
              (note) =>
                  (note.lineNumber == lineNumber &&
                      note.wordNumber == wordOrder &&
                      note.pageNumber == pageNumber),
            )
            .toList();
    List<Color> colors = [];
    for (var element in currentNotes) {
      if (element.falseType == FalseTypes.hafez) {
        colors.add(Colors.red[100]!);
      } else if (element.falseType == FalseTypes.tajweed) {
        colors.add(Colors.green[100]!);
      } else {
        colors.add(Colors.black12);
      }
    }
    if (colors.length < 2) colors.add(colors[0]);
    return colors;
  }

  void removeLastNoteOfPage() {
    if (currentDate == todayDate) {
      List<Note> currentNotes =
          notes.where((element) => element.pageNumber == pageNumber).toList();
      if (currentNotes.isEmpty) {
        return;
      } else {
        notes.remove(currentNotes.last);
        emit(SuccessPageState());
      }
    }
  }

  void updateCurrentDate(String value) {
    currentDate = value;
    emit(ChangeListenState());
  }
}
