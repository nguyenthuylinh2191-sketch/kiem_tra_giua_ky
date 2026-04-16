// File: lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  // TODO: Thay chuỗi này bằng API Key bạn vừa lấy trên newsapi.org
  final String _apiKey = '4a5d9e0c27d445eaab046b6433b03354'; 
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  // Thêm tham số page để hỗ trợ cuộn vô hạn
  Future<List<Article>> fetchNews({int page = 1, String category = 'general'}) async {
    // Lấy tin tức Công nghệ ở Mỹ (Bạn có thể đổi 'category' hoặc 'country')
    final url = Uri.parse('$_baseUrl?country=us&category=$category&page=$page&pageSize=10&apiKey=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> articlesJson = data['articles'];
        
        // Lọc bỏ những bài báo rác (bị remove)
        return articlesJson
            .where((json) => json['title'] != '[Removed]')
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối mạng');
    }
  }
}