import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sivi/core/constants/app_strings.dart';
import '../../data/repository/dictionary_repository.dart';
import 'dictionary_state.dart';

class DictionaryCubit extends Cubit<DictionaryState> {
  final DictionaryRepository repository;

  DictionaryCubit(this.repository) : super(DictionaryInitial());

  Future<void> lookupWord(String word) async {
    emit(DictionaryLoading());

    try {
      final result = await repository.fetchMeaning(word);

      emit(
        DictionarySuccess(
          word: result.word,
          partOfSpeech: result.partOfSpeech,
          definition: result.definition,
        ),
      );
    } catch (e) {
      emit(DictionaryError(AppStrings.meaningNotFound));
    }
  }
}