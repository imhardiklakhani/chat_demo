import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/users/data/models/user_model.dart';
import '../network/api_constants.dart';

class UsersApi {
  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/users?limit=20'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load users');
    }

    final data = jsonDecode(response.body);
    final List list = data['users'];

    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}