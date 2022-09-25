import "package:english_words/english_words.dart";

class Word {
  String? _text;
  String? _textPascalCase;
  String? _newText;

  Word({required String text, required String textPascal }) {
    _text = text;
    _textPascalCase = textPascal;
  }

  String get text {
    if (_newText == null) return _text!;
    return _newText!;
  }

  String get asPascalCase {
    if (_newText == null) return _textPascalCase!;
    return _newText!;
  }

  set text(String newText) {
    _newText = newText;
  }

  changeWord(String newString) {
    if (_newText != null) {
      _text = _newText;
      _textPascalCase = _newText;
    }
    _newText = newString;
  }
}

class Repositorio {
  final List<Word> _list = [];

  Repositorio() {
    for (int i = 0; i < 20; i++) {
      final word = generateWordPairs().take(1).first;
      _list.add(Word(
          text: word.toString(), textPascal: word.asPascalCase.toString()));
    }
  }

  List<Word> get list {
    return _list;
  }

  int get length {
    return _list.length;
  }

  index(int index) {
    return _list[index];
  }

  remove(int index) {
    _list.removeAt(index);
  }

  changeWordByIndex(String newString, int index) {
    _list[index].changeWord(newString);
  }
}
