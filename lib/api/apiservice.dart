import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
 String apiUrl = 'https://dummyjson.com/users';

  ApiService({required this.apiUrl});

  Future<List<dynamic>> fetchData({required int page, required int limit}) async {
    final response = await http.get(Uri.parse('$apiUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["users"];
      return data;
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
}