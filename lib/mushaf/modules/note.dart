class Note{
  final int pageNumber;
  final int lineNumber;
  final int wordNumber;
  final String falseType;

  Note({required this.pageNumber, required this.lineNumber, required this.wordNumber, required this.falseType});
  @override
  String toString() {
    // TODO: implement toString
    return "p:$pageNumber,l:$lineNumber,w:$wordNumber,f:$falseType";
  }
}

class FalseTypes{
  static const String tajweed="1";
  static const String tashkeel="2";
  static const String hafez="3";

}