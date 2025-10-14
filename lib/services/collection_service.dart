import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_model.dart';

class CollectionService {
  static const String _boxName = 'gameCollection';
  late Box<Map> _box;

  // Initialize Hive
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Map>(_boxName);
    } else {
      _box = Hive.box<Map>(_boxName);
    }
    print('📦 Collection service initialized with ${_box.length} games');
  }

  // Add game to collection
  Future<void> addGame(GameModel game) async {
    // Set default status if not set
    if (game.status == null) {
      game.status = GameStatus.wantToPlay;
    }
    await _box.put(game.id.toString(), game.toJson());
    print('✅ Added ${game.name} to collection with status: ${game.status?.label}');
  }

  // Update game status
  Future<void> updateGameStatus(int gameId, GameStatus status) async {
    final gameData = _box.get(gameId.toString());
    if (gameData != null) {
      final game = GameModel.fromJson(Map<String, dynamic>.from(gameData));
      print('🔄 Updating ${game.name} from ${game.status?.label} to ${status.label}');
      game.status = status;
      await _box.put(gameId.toString(), game.toJson());
      print('✅ Status saved to database');
      
      // Verify it was saved
      final verifyData = _box.get(gameId.toString());
      if (verifyData != null) {
        final verifyGame = GameModel.fromJson(Map<String, dynamic>.from(verifyData));
        print('✅ Verified: Status is now ${verifyGame.status?.label}');
      }
    } else {
      print('❌ Game not found in collection: $gameId');
    }
  }

  // Remove game from collection
  Future<void> removeGame(int gameId) async {
    await _box.delete(gameId.toString());
    print('🗑️ Removed game from collection');
  }

  // Check if game is in collection
  bool isInCollection(int gameId) {
    return _box.containsKey(gameId.toString());
  }

  // Get all games in collection
  List<GameModel> getAllGames() {
    final games = _box.values
        .map((json) => GameModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
    return games;
  }

  // Get collection count
  int getCount() {
    return _box.length;
  }

  // Clear entire collection
  Future<void> clearCollection() async {
    await _box.clear();
    print('🗑️ Collection cleared');
  }

  // Listen to collection changes
  Stream<BoxEvent> watchCollection() {
    return _box.watch();
  }
}
