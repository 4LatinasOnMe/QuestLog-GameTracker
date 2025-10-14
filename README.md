# 🎮 QuestLog

**QuestLog** is a beautiful, feature-rich mobile application for tracking your gaming journey. Discover new games, manage your collection, create wishlists, and gain insights into your gaming habits—all with a sleek, modern interface.

Built with **Flutter** and powered by the **RAWG Video Games Database API**.

---

## ✨ Features

### 🔍 **Game Discovery**
- Browse popular and newly released games
- Real-time search with 40+ games loaded
- Advanced filtering by platform, genre, rating, and release date
- Sort by relevance, rating, name, or date
- Detailed game information with ratings, platforms, and genres

### 📚 **Collection Management**
- Add games to your personal collection
- Track game status with 5 categories:
  - 🎯 Want to Play
  - 🎮 Playing
  - ✅ Completed
  - ❌ Dropped
  - ⏸️ On Hold
- Filter and sort your collection
- Pull-to-refresh for real-time updates

### 💛 **Wishlist System**
- Save games you want to buy
- Quick move from wishlist to collection
- Sort by name or rating
- Separate storage from main collection

### 📊 **Statistics Dashboard**
- Total games in collection
- Average game rating
- Top genre analysis
- Status breakdown with visual indicators
- Genre distribution

### 🎨 **Beautiful UI/UX**
- Dark theme with accent colors
- Smooth hero animations between screens
- Haptic feedback on interactions
- Cached images for fast loading
- Pull-to-refresh on all screens
- Responsive design

### ⚙️ **Settings & Data**
- Export collection as JSON
- Clear image cache
- About section with app info
- Powered by RAWG API attribution



## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: 3.9.2 or higher
- **RAWG API Key**: [Get one here](https://rawg.io/apidocs)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/questlog.git
   cd questlog
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   API_KEY=your_rawg_api_key_here
   API_BASE_URL=https://api.rawg.io/api
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── game_model.dart      # Game data model
├── screens/
│   ├── main_navigation.dart # Bottom navigation
│   ├── discovery_screen.dart
│   ├── search_screen.dart
│   ├── wishlist_screen.dart
│   ├── collection_screen.dart
│   ├── statistics_screen.dart
│   ├── game_details_screen.dart
│   └── settings_screen.dart
├── services/
│   ├── api_service.dart     # RAWG API integration
│   ├── collection_service.dart
│   └── wishlist_service.dart
├── widgets/
│   ├── game_card.dart       # Reusable game card
│   ├── status_selector.dart
│   └── shimmer_loading.dart
└── theme/
    └── app_theme.dart       # App colors & styles
```

---

## 🎯 App Walkthrough

### 1️⃣ **Discovery Tab** 🌟
The home screen greets you with:
- **Popular Games**: Trending titles with high ratings
- **New Releases**: Latest games hitting the market
- **See All Button**: Navigate to search for more games
- Beautiful grid layout with game cards showing:
  - Game cover image
  - Title
  - Rating (⭐)
  - Metacritic score

**How to use:**
- Scroll through popular and new releases
- Tap any game card to view details
- Tap "See All" to explore more games

---

### 2️⃣ **Search Tab** 🔍
Powerful search and filtering capabilities:
- **Search Bar**: Find games by name
- **Filter Toggle**: Expand advanced filters
- **Sort Options**: Relevance, Rating, Name, Release Date
- **Minimum Rating Slider**: Filter by rating (0-5 stars)
- **Platform Filter**: PC, PlayStation, Xbox, Nintendo, iOS, Android, Linux
- **Genre Filter**: Action, RPG, Strategy, Adventure, and more
- **Clear All**: Reset filters instantly

**How to use:**
1. Type game name in search bar
2. Tap filter icon to open advanced filters
3. Select sort method (chips at top)
4. Adjust minimum rating slider
5. Choose platform and genre
6. Results update automatically!

---

### 3️⃣ **Wishlist Tab** 💛
Your personal game wishlist:
- Heart icon in navigation bar
- Add games from game details screen
- **Move to Collection**: Green + button
- **Remove**: Red X button
- Sort by name or rating
- Pull down to refresh

**How to use:**
1. Browse games and tap to view details
2. Tap heart button to add to wishlist
3. Go to Wishlist tab to see all saved games
4. Tap green + to move to collection
5. Tap red X to remove from wishlist

---

### 4️⃣ **Collection Tab** 📚
Your game library with status tracking:
- All your collected games in one place
- **Status Badges**: Visual indicators for each game
- **Filter by Status**: All Games, Want to Play, Playing, etc.
- **Sort Options**: Name, Rating, Date Added
- Pull down to refresh

**Game Statuses:**
- 🎯 **Want to Play**: Games on your backlog
- 🎮 **Playing**: Currently active games
- ✅ **Completed**: Finished games
- ❌ **Dropped**: Abandoned games
- ⏸️ **On Hold**: Paused games

**How to use:**
1. Add games from game details screen
2. Tap filter icon to filter by status
3. Tap sort icon to change order
4. Tap game to view details and change status
5. Pull down to refresh collection

---

### 5️⃣ **Statistics Tab** 📊
Insights into your gaming habits:
- **Settings Icon**: Access app settings (top right)
- **Overview Cards**:
  - Total Games count
  - Average Rating
  - Top Genre
- **Status Breakdown**: Visual chart with counts
- **Top Genres**: Your most collected genres
- Pull down to refresh stats

**How to use:**
- View your collection statistics at a glance
- Tap settings icon for app settings
- Pull down to refresh after adding games

---

### 6️⃣ **Game Details Screen** 🎮
Comprehensive game information:
- **Hero Animation**: Smooth image transition from card
- **Game Header**: Large cover image with gradient
- **Wishlist Button**: Heart icon (left)
- **Collection Button**: Add/Remove (right)
- **Status Selector**: Change game status (if in collection)
- **Game Info**:
  - Release date
  - Rating and Metacritic score
  - Available platforms (with icons)
  - Genres
  - Full description

**How to use:**
1. Tap any game card to open details
2. Tap heart to add/remove from wishlist
3. Tap "Add to Collection" to save game
4. Tap status button to change game status
5. Scroll to read full description

---

### 7️⃣ **Settings Screen** ⚙️
Manage your app data:
- Access from Statistics tab (settings icon)
- **Export Collection**: Copy data as JSON to clipboard
- **Clear Image Cache**: Free up storage space
- **About Section**:
  - App icon and name
  - Version number
  - Description
  - "Powered by RAWG API" badge

**How to use:**
1. Go to Statistics tab
2. Tap settings icon (top right)
3. Tap "Export Collection" to backup data
4. Tap "Clear Image Cache" to free space

---

## 🎨 Key Interactions

### **Hero Animations** ✨
- Tap any game card → Watch the image smoothly fly to details screen
- Creates a seamless, professional transition

### **Haptic Feedback** 📳
- Light vibration when tapping game cards
- Medium vibration when adding/removing from collection
- Makes the app feel responsive and tactile

### **Pull-to-Refresh** 🔄
- Available on: Collection, Wishlist, Statistics
- Pull down from top of screen to refresh data
- Ensures you always see latest changes

### **Status Management** 🎯
- Tap status button in game details
- Bottom sheet appears with all 5 statuses
- Tap to select → Instant update with confirmation

---

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **RAWG API**: Game database and information
- **Hive**: Local storage for collections
- **Cached Network Image**: Efficient image loading
- **HTTP**: API requests
- **Google Fonts**: Custom typography (Poppins, Inter)

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_dotenv: ^5.1.0
  http: ^1.1.0
  google_fonts: ^6.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  cached_network_image: ^3.3.1
```

---

## 🔑 API Configuration

This app uses the **RAWG Video Games Database API**. You need to:

1. Sign up at [RAWG.io](https://rawg.io/apidocs)
2. Get your free API key
3. Add it to `.env` file

**API Endpoints Used:**
- `/games` - Game discovery and search
- `/games/{id}` - Game details

**Rate Limits:**
- Free tier: 20,000 requests/month
- Sufficient for personal use

---

## 🚧 Future Enhancements

Potential features for future versions:
- [ ] Game screenshots gallery
- [ ] User reviews and notes
- [ ] Theme color customization
- [ ] Import collection from JSON
- [ ] Social sharing
- [ ] Cloud sync
- [ ] Achievements system
- [ ] Play time tracking

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **RAWG.io** for providing the comprehensive game database API
- **Flutter Team** for the amazing framework
- **Google Fonts** for beautiful typography
- All the open-source packages used in this project

---

## 📧 Contact

Your Name - [@tinypeanut21](https://twitter.com/tinypeanut21)

Project Link: https://github.com/4LatinasOnMe/QuestLog-GameTracker

---

## 🎮 Happy Gaming!

Track your games, discover new adventures, and level up your gaming journey with **QuestLog**! 🚀

---

**Made with ❤️ and Flutter**
