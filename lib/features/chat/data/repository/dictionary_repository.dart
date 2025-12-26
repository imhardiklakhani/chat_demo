import 'package:my_sivi/core/constants/app_strings.dart';
import 'package:my_sivi/core/network/api_constants.dart';

import '../../../../core/network/api_client.dart';

class DictionaryRepository {
  final ApiClient apiClient;

  DictionaryRepository(this.apiClient);

  Future<DictionaryMeaning> fetchMeaning(String word) async {
    final url = '${ApiConstants.baseUrlDictionary}/api/v2/entries/en/$word';

    try {
      final response = await ApiClient.getDictionary(url);

      final List<dynamic> list = response as List<dynamic>;

      if (list.isEmpty) {
        throw Exception(AppStrings.meaningNotFound);
      }

      final entry = list.first as Map<String, dynamic>;
      final meanings = entry['meanings'] as List;
      final firstMeaning = meanings.first as Map<String, dynamic>;
      final definitions = firstMeaning['definitions'] as List;
      final firstDefinition = definitions.first as Map<String, dynamic>;

      return DictionaryMeaning(
        word: entry['word'],
        partOfSpeech: firstMeaning['partOfSpeech'],
        definition: firstDefinition['definition'],
      );
    } catch (e, stack) {
      rethrow;
    }
  }
}

class DictionaryMeaning {
  final String word;
  final String partOfSpeech;
  final String definition;

  DictionaryMeaning({
    required this.word,
    required this.partOfSpeech,
    required this.definition,
  });
}
