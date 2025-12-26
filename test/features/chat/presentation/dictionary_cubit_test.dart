import 'package:flutter_test/flutter_test.dart';
import 'package:my_sivi/features/chat/presentation/cubit/dictionary_cubit.dart';
import 'package:my_sivi/features/chat/presentation/cubit/dictionary_state.dart';
import 'package:my_sivi/features/chat/data/repository/dictionary_repository.dart';
import 'package:my_sivi/core/network/api_client.dart';

class FakeApiClient extends ApiClient {}

class FakeDictionaryRepository extends DictionaryRepository {
  FakeDictionaryRepository() : super(FakeApiClient());

  @override
  Future<DictionaryMeaning> fetchMeaning(String word) async {
    return DictionaryMeaning(
      word: word,
      partOfSpeech: 'noun',
      definition: 'A test definition',
    );
  }
}

void main() {
  late DictionaryCubit cubit;

  setUp(() {
    cubit = DictionaryCubit(FakeDictionaryRepository());
  });

  tearDown(() async {
    await cubit.close();
  });

  test('emits Loading then Success when lookupWord succeeds', () async {
    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<DictionaryLoading>(),
        isA<DictionarySuccess>(),
      ]),
    );

    await cubit.lookupWord('flutter');
  });
}