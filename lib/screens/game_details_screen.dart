import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game_model.dart';
import '../theme/app_theme.dart';
import '../services/collection_service.dart';
import '../services/wishlist_service.dart';
import '../widgets/status_selector.dart';

class GameDetailsScreen extends StatefulWidget {
  final GameModel game;

  const GameDetailsScreen({super.key, required this.game});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  final CollectionService _collectionService = CollectionService();
  final WishlistService _wishlistService = WishlistService();
  bool _isInCollection = false;
  bool _isInWishlist = false;
  bool _isLoading = true;
  GameStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    _checkCollection();
  }

  Future<void> _checkCollection() async {
    await _collectionService.init();
    await _wishlistService.init();
    
    final isInCollection = _collectionService.isInCollection(widget.game.id);
    final isInWishlist = _wishlistService.isInWishlist(widget.game.id);
    
    // Get current status if in collection
    GameStatus? status;
    if (isInCollection) {
      final games = _collectionService.getAllGames();
      final game = games.firstWhere((g) => g.id == widget.game.id);
      status = game.status;
    }
    
    setState(() {
      _isInCollection = isInCollection;
      _isInWishlist = isInWishlist;
      _currentStatus = status;
      _isLoading = false;
    });
  }

  Future<void> _toggleCollection() async {
    HapticFeedback.mediumImpact();
    if (_isInCollection) {
      await _collectionService.removeGame(widget.game.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.game.name} removed from collection'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      setState(() {
        _isInCollection = false;
        _currentStatus = null;
      });
    } else {
      await _collectionService.addGame(widget.game);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.game.name} added to collection!'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
      setState(() {
        _isInCollection = true;
        _currentStatus = GameStatus.wantToPlay;
      });
    }
  }

  Future<void> _toggleWishlist() async {
    HapticFeedback.lightImpact();
    if (_isInWishlist) {
      await _wishlistService.removeGame(widget.game.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.game.name} removed from wishlist'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } else {
      await _wishlistService.addGame(widget.game);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.game.name} added to wishlist!'),
            backgroundColor: AppTheme.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
    setState(() {
      _isInWishlist = !_isInWishlist;
    });
  }

  void _showStatusSelector() {
    if (!_isInCollection) {
      // If not in collection, add it first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add the game to your collection first'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatusSelector(
        currentStatus: _currentStatus,
        onStatusSelected: (status) async {
          // Update status in database
          await _collectionService.updateGameStatus(widget.game.id, status);
          
          // Update local state
          setState(() {
            _currentStatus = status;
          });
          
          // Show confirmation
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Text(status.emoji),
                    const SizedBox(width: 8),
                    Text('Status updated to ${status.label}'),
                  ],
                ),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Header Image with Back Button
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.backgroundDark,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Game Header Image with Hero animation
                  Hero(
                    tag: 'game_${widget.game.id}',
                    child: widget.game.backgroundImage != null
                        ? CachedNetworkImage(
                            imageUrl: widget.game.backgroundImage!,
                            fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppTheme.surfaceDark,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.accentColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.surfaceDark,
                            child: const Icon(
                              Icons.videogame_asset,
                              size: 80,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                            fadeInDuration: const Duration(milliseconds: 500),
                          )
                        : Container(
                            color: AppTheme.surfaceDark,
                            child: const Icon(
                              Icons.videogame_asset,
                              size: 80,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                  ),
                  
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.backgroundDark.withOpacity(0.7),
                          AppTheme.backgroundDark,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Game Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game Title
                  Text(
                    widget.game.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Rating and Metacritic
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: AppTheme.accentColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.game.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (widget.game.metacritic != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getMetacriticColor(widget.game.metacritic!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'META',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.backgroundDark,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.game.metacritic.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.backgroundDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Release Date
                      if (widget.game.released != null)
                        Text(
                          widget.game.released!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Genres
                  if (widget.game.genres.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.game.genres.map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.accentColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            genre,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Status (if in collection)
                  if (_isInCollection) ...[
                    Row(
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _showStatusSelector,
                          icon: Text(
                            _currentStatus?.emoji ?? '🎯',
                            style: const TextStyle(fontSize: 18),
                          ),
                          label: Text(
                            _currentStatus?.label ?? 'Set Status',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentColor,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.accentColor.withOpacity(0.15),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Platforms
                  if (widget.game.platforms.isNotEmpty) ...[
                    const Text(
                      'Available on',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: widget.game.platforms.map((platform) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getPlatformIcon(platform),
                                size: 18,
                                color: AppTheme.accentColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                platform,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.game.description ??
                        'An epic gaming experience that will take you on an unforgettable journey. '
                            'Immerse yourself in stunning visuals, engaging gameplay, and a captivating story.',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      height: 1.6,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Buttons Row
                  Row(
                    children: [
                      // Wishlist Button
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _toggleWishlist,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _isInWishlist ? AppTheme.warning : AppTheme.textPrimary,
                              side: BorderSide(
                                color: _isInWishlist ? AppTheme.warning : AppTheme.surfaceDark,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Icon(
                              _isInWishlist ? Icons.favorite : Icons.favorite_border,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Collection Button
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _toggleCollection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isInCollection ? AppTheme.error : AppTheme.accentColor,
                              foregroundColor: AppTheme.backgroundDark,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isInCollection ? Icons.remove_circle_outline : Icons.add_circle_outline,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _isInCollection ? 'Remove' : 'Add to Collection',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMetacriticColor(int score) {
    if (score >= 75) return AppTheme.success;
    if (score >= 50) return AppTheme.warning;
    return AppTheme.error;
  }

  IconData _getPlatformIcon(String platform) {
    final platformLower = platform.toLowerCase();
    if (platformLower.contains('playstation') || platformLower.contains('ps')) {
      return Icons.sports_esports;
    } else if (platformLower.contains('xbox')) {
      return Icons.sports_esports;
    } else if (platformLower.contains('pc')) {
      return Icons.computer;
    } else if (platformLower.contains('nintendo') || platformLower.contains('switch')) {
      return Icons.videogame_asset;
    }
    return Icons.devices;
  }
}
