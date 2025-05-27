abstract class PageStates {}

class InitialOnePageState extends PageStates {
  final int pageNumber;

  InitialOnePageState({required this.pageNumber});
}

class InitialMultiPageState extends PageStates{
  final int startPage;
  InitialMultiPageState({required this.startPage});
}

class LoadingPageState extends PageStates {}

class SuccessPageState extends PageStates {}

class FailurePageState extends PageStates {
  final String error;
  FailurePageState({required this.error});
}

class WordHighlightPageState extends PageStates {
  final Set<String> highlightedWords;
  WordHighlightPageState({required this.highlightedWords});
}
