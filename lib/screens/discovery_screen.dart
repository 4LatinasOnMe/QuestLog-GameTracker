import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/game_card.dart';
import '../widgets/shimmer_loading.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/collection_service.dart';
import 'game_details_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  bool _isLoading = true;

  // Game lists for each tab
  List<GameModel> _popularGames = [];
  List<GameModel> _newReleases = [];
  List<GameModel> _recommendedGames = [];

  // Track loading and error states
  final Map<int, bool> _tabLoadingStates = {
    0: true, // Recommended
    1: true, // New Releases
    2: true, // Popular
  };

  final Map<int, String?> _tabErrorStates = {
    0: null,
    1: null,
    2: null,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllTabs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllTabs() async {
    await Future.wait([
      _loadRecommendedGames(),
      _loadNewReleases(),
      _loadPopularGames(),
    ]);
  }

  Future<void> _loadRecommendedGames() async {
    if (!mounted) return;

    setState(() {
      _tabLoadingStates[0] = true;
      _tabErrorStates[0] = null;
    });

    try {
      final collectionService = CollectionService();
      await collectionService.init();
      final userCollection = collectionService.getAllGames();

      if (userCollection.isNotEmpty) {
        final gameIds = userCollection.map((game) => game.id).toList();
        debugPrint('Loading recommendations based on ${gameIds.length} games in collection');
        
        try {
          final recommended = await _apiService.getRecommendedGames(gameIds);
          
          if (mounted) {
            setState(() {
              _recommendedGames = recommended;
            });
          }
        } catch (e) {
          // If recommendation API fails, fall back to popular games
          debugPrint('Recommendation API failed, falling back to popular games: $e');
          final fallback = await _apiService.getPopularGames(pageSize: 10);
          
          if (mounted) {
            setState(() {
              _recommendedGames = fallback;
            });
          }
        }
      } else {
        // If collection is empty, show popular games as recommendations
        debugPrint('Collection is empty, showing popular games as recommendations');
        final fallback = await _apiService.getPopularGames(pageSize: 10);
        
        if (mounted) {
          setState(() {
            _recommendedGames = fallback;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tabErrorStates[0] = 'Failed to load recommendations. Please try again.';
        });
      }
      debugPrint('Error loading recommended games: $e');
    } finally {
      if (mounted) {
        setState(() {
          _tabLoadingStates[0] = false;
          _updateGlobalLoadingState();
        });
      }
    }
  }

  Future<void> _loadNewReleases() async {
    if (!mounted) return;

    setState(() {
      _tabLoadingStates[1] = true;
      _tabErrorStates[1] = null;
    });

    try {
      final newReleases = await _apiService.getNewReleases();

      if (mounted) {
        setState(() {
          _newReleases = newReleases;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tabErrorStates[1] = 'Failed to load new releases. Please try again.';
        });
      }
      debugPrint('Error loading new releases: $e');
    } finally {
      if (mounted) {
        setState(() {
          _tabLoadingStates[1] = false;
          _updateGlobalLoadingState();
        });
      }
    }
  }

  Future<void> _loadPopularGames() async {
    if (!mounted) return;

    setState(() {
      _tabLoadingStates[2] = true;
      _tabErrorStates[2] = null;
    });

    try {
      final popularGames = await _apiService.getPopularGames();

      if (mounted) {
        setState(() {
          _popularGames = popularGames;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tabErrorStates[2] = 'Failed to load popular games. Please try again.';
        });
      }
      debugPrint('Error loading popular games: $e');
    } finally {
      if (mounted) {
        setState(() {
          _tabLoadingStates[2] = false;
          _updateGlobalLoadingState();
        });
      }
    }
  }

  void _updateGlobalLoadingState() {
    setState(() {
      _isLoading = _tabLoadingStates.values.any((isLoading) => isLoading);
    });
  }

  Widget _buildTabContent(int index) {
    if (_tabErrorStates[index] != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _tabErrorStates[index]!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  switch (index) {
                    case 0: _loadRecommendedGames(); break;
                    case 1: _loadNewReleases(); break;
                    case 2: _loadPopularGames(); break;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_tabLoadingStates[index] == true) {
      return _buildLoadingGrid();
    }

    List<GameModel> gamesToShow;
    String emptyMessage;

    switch (index) {
      case 0: // Recommended
        gamesToShow = _recommendedGames;
        emptyMessage = 'No recommendations available. Add some games to your collection first!';
        break;
      case 1: // New Releases
        gamesToShow = _newReleases;
        emptyMessage = 'No new releases found.';
        break;
      case 2: // Popular
        gamesToShow = _popularGames;
        emptyMessage = 'Unable to load popular games.';
        break;
      default:
        gamesToShow = [];
        emptyMessage = 'No data available.';
    }

    if (gamesToShow.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return _buildGamesGrid(gamesToShow);
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerGameCard(),
    );
  }

  Widget _buildGamesGrid(List<GameModel> games) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return GameCard(
          game: game,
          onTap: () => _navigateToGameDetails(game),
        );
      },
    );
  }

  void _navigateToGameDetails(GameModel game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailsScreen(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.0,
              pinned: true,
              backgroundColor: AppTheme.backgroundDark,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 56),
                title: const Text(
                  'Discover',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                centerTitle: false,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppTheme.accentColor,
                  unselectedLabelColor: Colors.white54,
                  indicatorColor: AppTheme.accentColor,
                  indicatorWeight: 3.0,
                  tabs: const [
                    Tab(text: 'Recommended'),
                    Tab(text: 'New Releases'),
                    Tab(text: 'Popular'),
                  ],
                  onTap: (index) {
                    if (_tabLoadingStates[index] == null) {
                      switch (index) {
                        case 0: _loadRecommendedGames(); break;
                        case 1: _loadNewReleases(); break;
                        case 2: _loadPopularGames(); break;
                      }
                    }
                  },
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent(0), // Recommended
            _buildTabContent(1), // New Releases
            _buildTabContent(2), // Popular
          ],
        ),
      ),
    );
  }
}