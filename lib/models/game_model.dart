enum GameStatus {
  wantToPlay('Want to Play', '🎯'),
  playing('Playing', '🎮'),
  completed('Completed', '✅'),
  dropped('Dropped', '❌'),
  onHold('On Hold', '⏸️');

  final String label;
  final String emoji;
  const GameStatus(this.label, this.emoji);
}

class GameModel {
  final int id;
  final String name;
  final String? backgroundImage;
  final double rating;
  final String? released;
  final List<String> platforms;
  final List<String> genres;
  final String? description;
  final int? metacritic;
  GameStatus? status;

  GameModel({
    required this.id,
    required this.name,
    this.backgroundImage,
    required this.rating,
    this.released,
    this.platforms = const [],
    this.genres = const [],
    this.description,
    this.metacritic,
    this.status,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    GameStatus? status;
    if (json['status'] != null) {
      try {
        status = GameStatus.values.firstWhere(
          (s) => s.name == json['status'],
        );
      } catch (e) {
        status = null;
      }
    }

    // Parse platforms - handle both RAWG API format and stored format
    List<String> platforms = [];
    if (json['platforms'] != null) {
      final platformsData = json['platforms'] as List<dynamic>;
      if (platformsData.isNotEmpty) {
        if (platformsData.first is String) {
          // Already parsed (from Hive storage)
          platforms = platformsData.map((p) => p.toString()).toList();
        } else if (platformsData.first is Map) {
          // From RAWG API
          platforms = platformsData
              .map((p) => (p['platform']?['name'] ?? p['name'] ?? 'Unknown') as String)
              .toList();
        }
      }
    }

    // Parse genres - handle both formats
    List<String> genres = [];
    if (json['genres'] != null) {
      final genresData = json['genres'] as List<dynamic>;
      if (genresData.isNotEmpty) {
        if (genresData.first is String) {
          // Already parsed (from Hive storage)
          genres = genresData.map((g) => g.toString()).toList();
        } else if (genresData.first is Map) {
          // From RAWG API
          genres = genresData
              .map((g) => (g['name'] ?? 'Unknown') as String)
              .toList();
        }
      }
    }

    return GameModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Game',
      backgroundImage: json['background_image'],
      rating: (json['rating'] ?? 0).toDouble(),
      released: json['released'],
      platforms: platforms,
      genres: genres,
      description: json['description_raw'] ?? json['description'],
      metacritic: json['metacritic'],
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'background_image': backgroundImage,
      'rating': rating,
      'released': released,
      'platforms': platforms,
      'genres': genres,
      'description': description,
      'metacritic': metacritic,
      'status': status?.name,
    };
  }
}
