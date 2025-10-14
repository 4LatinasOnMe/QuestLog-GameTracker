import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/game_card.dart';
import '../theme/app_theme.dart';
import '../services/collection_service.dart';
import 'game_details_screen.dart';
import 'main_navigation.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> with AutomaticKeepAliveClientMixin {
  final CollectionService _collectionService = CollectionService();
  List<GameModel> _collection = [];
  bool _isLoading = true;
  String _sortBy = 'name'; // name, rating, date
  GameStatus? _filterStatus;

  @override
  bool get wantKeepAlive => false; // Reload fresh data each time

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  @override
  void didUpdateWidget(CollectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when widget updates (tab switch)
    _loadCollection();
  }

  // Public method to refresh from outside
  void refresh() {
    _loadCollection();
  }

  Future<void> _loadCollection() async {
    try {
      await _collectionService.init();
      setState(() {
        _collection = _collectionService.getAllGames();
        _sortCollection();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading collection: $e');
      setState(() => _isLoading = false);
    }
  }

  void _sortCollection() {
    switch (_sortBy) {
      case 'name':
        _collection.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        _collection.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }

  Future<void> _removeGame(GameModel game) async {
    await _collectionService.removeGame(game.id);
    await _loadCollection(); // Reload entire collection
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCollection,
          color: AppTheme.accentColor,
          backgroundColor: AppTheme.surfaceDark,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.accentColor),
                )
              : _collection.isEmpty
                  ? _buildEmptyState()
                  : _buildCollection(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Empty State Icon
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.surfaceDark,
                              AppTheme.cardDark,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentColor.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.collections_bookmark_outlined,
                              size: 70,
                              color: AppTheme.textTertiary.withOpacity(0.6),
                            ),
                            Positioned(
                              right: 15,
                              bottom: 15,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppTheme.accentColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 28,
                                  color: AppTheme.backgroundDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Empty State Title
                const Text(
                  'Your Collection is Empty',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Empty State Description
                const Text(
                  'Start building your epic game library!\nDiscover amazing games and add them to your collection.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    height: 1.6,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Quick Tips
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTipRow(Icons.explore, 'Browse trending games'),
                      const SizedBox(height: 12),
                      _buildTipRow(Icons.search, 'Search for your favorites'),
                      const SizedBox(height: 12),
                      _buildTipRow(Icons.add_circle_outline, 'Tap to add to collection'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Call to Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Switch to Discovery tab
                      MainNavigation.of(context)?.switchTab(0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: AppTheme.backgroundDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.explore, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Discover Games',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCollection() {
    // Apply status filter
    final filteredGames = _filterStatus == null
        ? _collection
        : _collection.where((game) => game.status == _filterStatus).toList();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Collection',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${filteredGames.length} ${filteredGames.length == 1 ? 'game' : 'games'}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Filter button
                        PopupMenuButton<GameStatus?>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _filterStatus != null
                                  ? AppTheme.accentColor.withOpacity(0.15)
                                  : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.filter_list,
                              color: _filterStatus != null
                                  ? AppTheme.accentColor
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          color: AppTheme.surfaceDark,
                          onSelected: (value) {
                            setState(() {
                              _filterStatus = value;
                            });
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<GameStatus?>(
                              value: null,
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    _filterStatus = null;
                                  });
                                });
                              },
                              child: Text(
                                'All Games',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _filterStatus == null
                                      ? AppTheme.accentColor
                                      : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            ...GameStatus.values.map((status) {
                              return PopupMenuItem(
                                value: status,
                                child: Row(
                                  children: [
                                    Text(status.emoji),
                                    const SizedBox(width: 8),
                                    Text(
                                      status.label,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: _filterStatus == status
                                            ? AppTheme.accentColor
                                            : AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                        const SizedBox(width: 8),
                        // Sort button
                        PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.sort,
                              color: AppTheme.accentColor,
                            ),
                          ),
                          color: AppTheme.surfaceDark,
                          onSelected: (value) {
                            setState(() {
                              _sortBy = value;
                              _sortCollection();
                            });
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'name',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.sort_by_alpha,
                                    size: 20,
                                    color: _sortBy == 'name' ? AppTheme.accentColor : AppTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Name (A-Z)',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: _sortBy == 'name' ? AppTheme.accentColor : AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'rating',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: _sortBy == 'rating' ? AppTheme.accentColor : AppTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Rating (High-Low)',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: _sortBy == 'rating' ? AppTheme.accentColor : AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Collection Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final game = filteredGames[index];
                return Stack(
                  children: [
                    GameCard(
                      game: game,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailsScreen(game: game),
                          ),
                        );
                        // Reload collection when returning from details
                        _loadCollection();
                      },
                    ),
                    
                    // Remove Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          await _removeGame(game);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${game.name} removed from collection'),
                                backgroundColor: AppTheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundDark.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              childCount: filteredGames.length,
            ),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
