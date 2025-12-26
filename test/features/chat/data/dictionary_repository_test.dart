import 'package:flutter_test/flutter_test.dart';
import 'package:my_sivi/core/network/api_client.dart';
import 'package:my_sivi/features/chat/data/repository/dictionary_repository.dart';

class FakeApiClient extends ApiClient {
  @override
  Future<dynamic> get(String url) async {
    return [
      {
        "word": "flutter",
        "meanings": [
          {
            "partOfSpeech": "noun",
            "definitions": [
              {"definition": "A quick and irregular motion"}
            ]
          }
        ]
      }
    ];
  }
}

void main() {
  late DictionaryRepository repository;

  setUp(() {
    repository = DictionaryRepository(FakeApiClient());
  });

  test('parses dictionary API response correctly', () async {
    final result = await repository.fetchMeaning('flutter');

    expect(result.word, 'flutter');
    expect(result.partOfSpeech, 'noun');
    expect(result.definition, isNotEmpty);
  });
}
