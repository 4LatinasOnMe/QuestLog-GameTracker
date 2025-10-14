import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_model.dart';

class WishlistService {
  static const String _boxName = 'gameWishlist';
  late Box<Map> _box;

  // Initialize Hive
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Map>(_boxName);
    } else {
      _box = Hive.box<Map>(_boxName);
    }
    print('💫 Wishlist service initialized with ${_box.length} games');
  }

  // Add game to wishlist
  Future<void> addGame(GameModel game) async {
    await _box.put(game.id.toString(), game.toJson());
    print('✅ Added ${game.name} to wishlist');
  }

  // Remove game from wishlist
  Future<void> removeGame(int gameId) async {
    await _box.delete(gameId.toString());
    print('🗑️ Removed game from wishlist');
  }

  // Check if game is in wishlist
  bool isInWishlist(int gameId) {
    return _box.containsKey(gameId.toString());
  }

  // Get all games in wishlist
  List<GameModel> getAllGames() {
    final games = _box.values
        .map((json) => GameModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
    return games;
  }

  // Get wishlist count
  int getCount() {
    return _box.length;
  }

  // Clear entire wishlist
  Future<void> clearWishlist() async {
    await _box.clear();
    print('🗑️ Wishlist cleared');
  }

  // Move game to collection (returns the game)
  Future<GameModel?> moveToCollection(int gameId) async {
    final gameData = _box.get(gameId.toString());
    if (gameData != null) {
      final game = GameModel.fromJson(Map<String, dynamic>.from(gameData));
      await removeGame(gameId);
      return game;
    }
    return null;
  }
}
