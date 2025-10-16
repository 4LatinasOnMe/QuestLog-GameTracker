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
  
  // Get new releases (last 30 days)
  Future<List<GameModel>> getNewReleases({int page = 1, int pageSize = 10}) async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final dateRange = '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')},${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    return fetchGames(
      page: page,
      pageSize: pageSize,
      dates: dateRange,
      ordering: '-released',
    );
  }
  
  // Get popular games (by metacritic score)
  Future<List<GameModel>> getPopularGames({int page = 1, int pageSize = 10}) async {
    return fetchGames(
      page: page,
      pageSize: pageSize,
      ordering: '-metacritic',
    );
  }
  
  // Get recommended games based on a list of game IDs
  Future<List<GameModel>> getRecommendedGames(List<int> gameIds, {int page = 1, int pageSize = 10}) async {
    if (gameIds.isEmpty) return [];
    
    // For simplicity, we'll get similar games to the first game in the list
    // In a production app, you might want to implement a more sophisticated recommendation algorithm
    final similarGames = await getSimilarGames(gameIds.first, page: page, pageSize: pageSize);
    return similarGames;
  }
  
  // Get similar games to a specific game
  Future<List<GameModel>> getSimilarGames(int gameId, {int page = 1, int pageSize = 10}) async {
    final apiKey = AppConfig.apiKey;
    final baseUrl = AppConfig.apiBaseUrl;
    
    final url = Uri.parse('$baseUrl/games/$gameId/suggested').replace(queryParameters: {
      'key': apiKey,
      'page': page.toString(),
      'page_size': pageSize.toString(),
    });
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> results = jsonData['results'] ?? [];
        return results.map((json) => GameModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load similar games: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching similar games: $e');
    }
  }
  
  // Get game details with optional parameters for additional data
  Future<GameModel> getGameDetails(int gameId, {bool includeScreenshots = false, bool includeStores = false}) async {
    final apiKey = AppConfig.apiKey;
    final baseUrl = AppConfig.apiBaseUrl;
    
    final params = {
      'key': apiKey,
      if (includeScreenshots) 'additions': 'screenshots',
      if (includeStores) 'stores': '1',
    };
    
    final url = Uri.parse('$baseUrl/games/$gameId').replace(queryParameters: params);
    
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
