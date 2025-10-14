import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/game_card.dart';
import '../theme/app_theme.dart';
import '../services/wishlist_service.dart';
import '../services/collection_service.dart';
import 'game_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> with AutomaticKeepAliveClientMixin {
  final WishlistService _wishlistService = WishlistService();
  final CollectionService _collectionService = CollectionService();
  List<GameModel> _wishlist = [];
  bool _isLoading = true;
  String _sortBy = 'name';

  @override
  bool get wantKeepAlive => false; // Reload fresh data each time

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  @override
  void didUpdateWidget(WishlistScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when widget updates (tab switch)
    _loadWishlist();
  }

  void refresh() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      await _wishlistService.init();
      setState(() {
        _wishlist = _wishlistService.getAllGames();
        _sortWishlist();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading wishlist: $e');
      setState(() => _isLoading = false);
    }
  }

  void _sortWishlist() {
    switch (_sortBy) {
      case 'name':
        _wishlist.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        _wishlist.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }

  Future<void> _removeGame(GameModel game) async {
    await _wishlistService.removeGame(game.id);
    await _loadWishlist();
  }

  Future<void> _moveToCollection(GameModel game) async {
    await _collectionService.init();
    await _collectionService.addGame(game);
    await _wishlistService.removeGame(game.id);
    await _loadWishlist();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${game.name} moved to collection!'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadWishlist,
          color: AppTheme.accentColor,
          backgroundColor: AppTheme.surfaceDark,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.accentColor),
                )
              : _wishlist.isEmpty
                  ? _buildEmptyState()
                  : _buildWishlist(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                    color: AppTheme.warning.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 70,
                color: AppTheme.warning,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add games you want to buy to your wishlist and track them here',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                height: 1.6,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlist() {
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
                          'Wishlist',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_wishlist.length} ${_wishlist.length == 1 ? 'game' : 'games'}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
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
                          _sortWishlist();
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
          ),
        ),
        
        // Wishlist Grid
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
                final game = _wishlist[index];
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
                        _loadWishlist();
                      },
                    ),
                    
                    // Move to Collection Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _moveToCollection(game),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.success.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () async {
                              await _removeGame(game);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${game.name} removed from wishlist'),
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
                        ],
                      ),
                    ),
                  ],
                );
              },
              childCount: _wishlist.length,
            ),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
