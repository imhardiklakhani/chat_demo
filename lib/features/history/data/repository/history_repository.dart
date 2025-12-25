import 'package:flutter/material.dart';
import 'package:my_sivi/core/network/api_client.dart';
import 'package:my_sivi/core/network/api_constants.dart';

import '../models/history_item_model.dart';

class HistoryRepository {
  Future<List<HistoryItemModel>> fetchHistory() async {
    try {
      debugPrint('HISTORY API CALL START');

      final response = await ApiClient.get(
        '${ApiConstants.baseUrl}/comments?limit=100',
      );

      debugPrint('HISTORY API RESPONSE: $response');

      final List list = response['comments'] as List;

      return list
          .map((e) => HistoryItemModel.fromApi(e))
          .toList();
    } catch (e) {
      debugPrint('HISTORY API ERROR: $e');
      rethrow;
    }
  }
}