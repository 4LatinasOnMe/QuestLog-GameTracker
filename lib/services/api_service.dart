import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import '../models/game_model.dart';

class ApiService {
  // Fetch games from RAWG.io API
  Future<List<GameModel>> fetchGames({
    int page = 1,
    int pageSize = 20,
    String? ordering,
    String? dates,
  }) async {
    final apiKey = AppConfig.apiKey;
    final baseUrl = AppConfig.apiBaseUrl;
    
    print('🔑 API Key: ${apiKey.substring(0, 8)}...');
    print('🌐 Base URL: $baseUrl');
    
    // RAWG API uses 'key' parameter in URL
    final queryParams = {
      'key': apiKey,
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
    
    if (ordering != null) queryParams['ordering'] = ordering;
    if (dates != null) queryParams['dates'] = dates;
    
    final url = Uri.parse('$baseUrl/games').replace(queryParameters: queryParams);
    
    print('📡 Full URL: $url');
    
    try {
      final response = await http.get(url);
      
      print('📊 Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> results = jsonData['results'] ?? [];
        
        print('✅ Loaded ${results.length} games from RAWG API');
        
        return results.map((json) => GameModel.fromJson(json)).toList();
      } else {
        print('❌ Response Body: ${response.body}');
        throw Exception('Failed to load games: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error fetching games: $e');
    }
  }
  
  // Search games
  Future<List<GameModel>> searchGames(String query, {int page = 1}) async {
    final apiKey = AppConfig.apiKey;
    final baseUrl = AppConfig.apiBaseUrl;
    
    final url = Uri.parse('$baseUrl/games').replace(queryParameters: {
      'key': apiKey,
      'search': query,
      'page': page.toString(),
      'page_size': '20',
    });
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> results = jsonData['results'] ?? [];
        return results.map((json) => GameModel.fromJson(json)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching games: $e');
    }
  }
  
  // Get game details
  Future<GameModel> getGameDetails(int gameId) async {
    final apiKey = AppConfig.apiKey;
    final baseUrl = AppConfig.apiBaseUrl;
    
    final url = Uri.parse('$baseUrl/games/$gameId').replace(queryParameters: {
      'key': apiKey,
    });
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return GameModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load game details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching game details: $e');
    }
  }
  
  // Fetch games by genre
  Future<List<GameModel>> fetchGamesByGenre(String genre, {int page = 1}) async {
    final apiKey = AppConfig.apiKey;
    final baseUrl = AppConfig.apiBaseUrl;
    
    final url = Uri.parse('$baseUrl/games').replace(queryParameters: {
      'key': apiKey,
      'genres': genre,
      'page': page.toString(),
      'page_size': '20',
    });
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> results = jsonData['results'] ?? [];
        return results.map((json) => GameModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load games by genre: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching games by genre: $e');
    }
  }
}
