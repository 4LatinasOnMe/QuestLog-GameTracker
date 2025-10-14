import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/game_card.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'game_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<GameModel> _allGames = [];
  List<GameModel> _displayedGames = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _selectedPlatform;
  String? _selectedGenre;
  String _sortBy = 'relevance'; // relevance, rating, name, released
  double _minRating = 0;
  bool _showFilters = false;

  final List<String> _platforms = ['All', 'PC', 'PlayStation', 'Xbox', 'Nintendo Switch', 'Android', 'iOS'];
  final List<String> _genres = ['All', 'Action', 'Adventure', 'RPG', 'Strategy', 'Sports', 'Shooter', 'Puzzle', 'Indie'];

  @override
  void initState() {
    super.initState();
    _loadInitialGames();
  }

  Future<void> _loadInitialGames() async {
    setState(() => _isLoading = true);
    
    try {
      final games = await _apiService.fetchGames(page: 1, pageSize: 40);
      setState(() {
        _allGames = games;
        _displayedGames = games;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading games: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      // Reset to all games when search is cleared
      _applyFilters();
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await _apiService.searchGames(query);
      setState(() {
        _displayedGames = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _displayedGames = [];
        _isSearching = false;
      });
    }
  }

  void _applyFilters() {
    List<GameModel> filtered = _allGames;

    // Apply platform filter
    if (_selectedPlatform != null && _selectedPlatform != 'All') {
      filtered = filtered.where((game) {
        return game.platforms.any((platform) => 
          platform.toLowerCase().contains(_selectedPlatform!.toLowerCase())
        );
      }).toList();
    }

    // Apply genre filter
    if (_selectedGenre != null && _selectedGenre != 'All') {
      filtered = filtered.where((game) {
        return game.genres.any((genre) => 
          genre.toLowerCase().contains(_selectedGenre!.toLowerCase())
        );
      }).toList();
    }

    // Apply rating filter
    if (_minRating > 0) {
      filtered = filtered.where((game) => game.rating >= _minRating).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'released':
        filtered.sort((a, b) {
          if (a.released == null) return 1;
          if (b.released == null) return -1;
          return b.released!.compareTo(a.released!);
        });
        break;
      // 'relevance' - keep original order
    }

    setState(() {
      _displayedGames = filtered;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedPlatform = null;
      _selectedGenre = null;
      _minRating = 0;
      _sortBy = 'relevance';
      _searchController.clear();
      _displayedGames = _allGames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search for games...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppTheme.accentColor,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppTheme.textTertiary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.accentColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filters
                  Row(
                    children: [
                      // Platform Filter
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPlatform,
                              isExpanded: true,
                              hint: const Text(
                                'Platform',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: AppTheme.textTertiary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.accentColor,
                                size: 20,
                              ),
                              dropdownColor: AppTheme.surfaceDark,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppTheme.textPrimary,
                              ),
                              items: _platforms.map((platform) {
                                return DropdownMenuItem(
                                  value: platform,
                                  child: Text(
                                    platform,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPlatform = value;
                                });
                                _applyFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Genre Filter
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGenre,
                              isExpanded: true,
                              hint: const Text(
                                'Genre',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: AppTheme.textTertiary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.accentColor,
                                size: 20,
                              ),
                              dropdownColor: AppTheme.surfaceDark,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppTheme.textPrimary,
                              ),
                              items: _genres.map((genre) {
                                return DropdownMenuItem(
                                  value: genre,
                                  child: Text(
                                    genre,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGenre = value;
                                });
                                _applyFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Advanced Filters Toggle
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                        icon: Icon(
                          _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                          color: _showFilters ? AppTheme.accentColor : AppTheme.textSecondary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Advanced Filters Panel
                  if (_showFilters) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Advanced Filters',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              TextButton(
                                onPressed: _clearFilters,
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppTheme.accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Sort By
                          const Text(
                            'Sort By',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildSortChip('Relevance', 'relevance'),
                              _buildSortChip('Rating', 'rating'),
                              _buildSortChip('Name', 'name'),
                              _buildSortChip('Release Date', 'released'),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Minimum Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Minimum Rating',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                _minRating == 0 ? 'Any' : _minRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _minRating,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            activeColor: AppTheme.accentColor,
                            inactiveColor: AppTheme.surfaceDark,
                            onChanged: (value) {
                              setState(() {
                                _minRating = value;
                              });
                            },
                            onChangeEnd: (value) {
                              _applyFilters();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Search Results
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: AppTheme.accentColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading games...',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _displayedGames.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: AppTheme.textTertiary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No games found',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Try a different search or filter',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // Results count
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Row(
                                children: [
                                  Text(
                                    '${_displayedGames.length} games found',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  if (_selectedPlatform != null || _selectedGenre != null) ...[
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedPlatform = null;
                                          _selectedGenre = null;
                                          _searchController.clear();
                                          _displayedGames = _allGames;
                                        });
                                      },
                                      child: const Text(
                                        'Clear Filters',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: AppTheme.accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Games grid
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: _displayedGames.length,
                                itemBuilder: (context, index) {
                                  final game = _displayedGames[index];
                                  return GameCard(
                                    game: game,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GameDetailsScreen(game: game),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _sortBy = value;
        });
        _applyFilters();
      },
      backgroundColor: AppTheme.surfaceDark,
      selectedColor: AppTheme.accentColor.withOpacity(0.2),
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
      ),
      checkmarkColor: AppTheme.accentColor,
      side: BorderSide(
        color: isSelected ? AppTheme.accentColor : Colors.transparent,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
