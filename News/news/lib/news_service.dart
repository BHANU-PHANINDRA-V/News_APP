// lib/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secrets.dart';

class NewsService {
  // Change country to "in" for India headlines if you like
  final String _endpoint =
      "https://newsapi.org/v2/everything?q=country=india&apiKey=$newsApiKey";

  Future<List<Map<String, dynamic>>> fetchTopHeadlines() async {
    final uri = Uri.parse(_endpoint);
    final response = await http.get(uri);
  

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List articles = data["articles"] ?? [];
      // Normalize to List<Map<String, dynamic>>
      return articles.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load news: ${response.statusCode}");
    }
  }
}