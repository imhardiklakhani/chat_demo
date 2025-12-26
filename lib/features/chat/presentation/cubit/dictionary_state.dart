abstract class DictionaryState {}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionarySuccess extends DictionaryState {
  final String word;
  final String partOfSpeech;
  final String definition;

  DictionarySuccess({
    required this.word,
    required this.partOfSpeech,
    required this.definition,
  });
}

class DictionaryError extends DictionaryState {
  final String message;

  DictionaryError(this.message);
}