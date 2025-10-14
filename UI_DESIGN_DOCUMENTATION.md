# QuestLog - UI Design Documentation

## 🎨 Design Concept

A modern, immersive video game discovery mobile app with a premium dark theme that feels like a next-gen gaming console interface.

## 🌑 Color Palette

### Primary Colors
- **Background Dark**: `#121212` - Deep, rich black for main background
- **Surface Dark**: `#1E1E1E` - Elevated surface color
- **Card Dark**: `#2A2A2A` - Card background color

### Accent Color
- **Electric Blue**: `#00D9FF` - High-energy accent for all interactive elements
- **Accent Light**: `#33E0FF` - Lighter variant
- **Accent Dark**: `#00A8CC` - Darker variant

*Alternative accent options available in code:*
- Neon Green: `#00FF41`
- Vibrant Purple: `#B026FF`

### Text Colors
- **Primary Text**: `#FFFFFF` - Pure white for headings
- **Secondary Text**: `#B3B3B3` - Medium gray for body text
- **Tertiary Text**: `#808080` - Subtle gray for hints

### Semantic Colors
- **Success**: `#4CAF50` - Green for positive actions
- **Warning**: `#FF9800` - Orange for warnings
- **Error**: `#FF5252` - Red for errors

## 📝 Typography

### Heading Font: Poppins
- **Display Large**: 32px, Bold
- **Display Medium**: 28px, Bold
- **Display Small**: 24px, Bold
- **Headline Medium**: 20px, Semi-bold

### Body Font: Inter
- **Title Large**: 18px, Semi-bold
- **Title Medium**: 16px, Medium
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Body Small**: 12px, Regular

## 📱 Screens

### 1. Home/Discovery Screen
**Purpose**: Main landing page for game discovery

**Features**:
- Large, bold "Discover" heading with subtitle
- Two main sections: "Popular" and "New Releases"
- 2-column grid layout for game cards
- "See All" buttons for each section
- Smooth scrolling with generous padding

**Components**:
- Game cards with 16:9 aspect ratio images
- Star ratings with electric blue icons
- Metacritic scores with color-coded badges
- Skeleton loaders during data fetch

### 2. Game Details Screen
**Purpose**: Detailed view of selected game

**Features**:
- Full-width header image with gradient overlay
- Floating back button with dark background
- Game title in large Poppins font
- Rating and Metacritic score badges
- Genre tags with accent color borders
- Platform availability with icons
- "About" section with game description
- Prominent "Add to Collection" button (56px height)

**Interactions**:
- Collapsing header on scroll
- Smooth transitions
- Success snackbar on add to collection

### 3. Search Screen
**Purpose**: Find games with filters

**Features**:
- Large "Search" heading
- Prominent search bar with electric blue accent
- Clear button when text is entered
- Two dropdown filters: Platform and Genre
- Real-time search results in 2-column grid
- Empty state with search icon when no input
- "No games found" state with helpful message

**Filters**:
- **Platforms**: All, PC, PlayStation, Xbox, Nintendo Switch
- **Genres**: All, Action, Adventure, RPG, Strategy, Sports

### 4. My Collection Screen
**Purpose**: Personal game library

**Features**:
- **Empty State** (when no games):
  - Large circular icon with game controller
  - Plus icon overlay in accent color
  - "Your Collection is Empty" heading
  - Descriptive text
  - "Discover Games" call-to-action button

- **Populated State** (with games):
  - "My Collection" heading with game count
  - 2-column grid of game cards
  - Remove button (X) on each card
  - Confirmation snackbar on removal

## 🎯 UI Components

### Game Card
- **Size**: Flexible with 0.7 aspect ratio
- **Border Radius**: 16px
- **Shadow**: Soft black shadow with 8px blur
- **Image**: 16:9 aspect ratio, rounded top corners
- **Content Padding**: 12px
- **Elements**:
  - Game name (2 lines max, ellipsis)
  - Star rating with accent color
  - Metacritic score badge (color-coded)

### Skeleton Loader
- **Animation**: Shimmer effect with gradient
- **Duration**: 1500ms repeat
- **Colors**: Gradient from `#2A2A2A` → `#3A3A3A` → `#2A2A2A`
- **Usage**: Replaces game cards during loading

### Bottom Navigation
- **Background**: Surface dark with shadow
- **Height**: Auto with safe area
- **Items**: 3 tabs (Discover, Search, Collection)
- **Active State**: 
  - Accent color icon and text
  - Rounded background with accent opacity
  - Expanded with label
- **Inactive State**:
  - Tertiary text color
  - Outline icons
  - Icon only

### Buttons
- **Primary Button**:
  - Background: Accent color
  - Text: Background dark
  - Height: 56px
  - Border Radius: 12px
  - Font: Inter, 16px, Bold
  - No elevation

### Input Fields
- **Background**: Surface dark
- **Border Radius**: 12px
- **Padding**: 20px horizontal, 16px vertical
- **Focus State**: 2px accent color border
- **Hint Text**: Tertiary color

## 🎭 Interactions & Animations

### Loading States
- Skeleton loaders with shimmer animation
- Circular progress indicators in accent color
- Smooth fade-in when content loads

### Navigation
- Bottom nav with smooth tab switching
- Page transitions with material motion
- Back button with fade animation

### Cards
- Tap feedback with slight scale
- Shadow elevation on hover (web)
- Smooth image loading with placeholder

### Snackbars
- Floating style with rounded corners
- Color-coded by type (success/error)
- 12px border radius
- Auto-dismiss after 3 seconds

## 📐 Spacing & Layout

### Padding
- **Screen edges**: 20px
- **Card padding**: 12px
- **Section spacing**: 32px
- **Element spacing**: 8-16px

### Grid Layout
- **Columns**: 2
- **Aspect Ratio**: 0.7
- **Cross-axis spacing**: 16px
- **Main-axis spacing**: 16px

### Border Radius
- **Cards**: 16px
- **Buttons**: 12px
- **Input fields**: 12px
- **Chips/Tags**: 20px (pill shape)
- **Small elements**: 8px

## 🎮 Platform Considerations

### Android
- Material 3 design language
- System navigation bar color matches surface dark
- Status bar transparent with light icons

### iOS
- Respects safe areas
- Native-feeling scrolling
- Adaptive icons

## 🚀 Performance Features

- Lazy loading of images
- Efficient grid rendering with builders
- Cached network images (via google_fonts)
- Minimal rebuilds with const constructors
- IndexedStack for navigation (preserves state)

## 🎨 Customization Options

To change the accent color, modify in `lib/theme/app_theme.dart`:

```dart
// Electric Blue (current)
static const Color accentColor = Color(0xFF00D9FF);

// Neon Green
static const Color accentColor = Color(0xFF00FF41);

// Vibrant Purple
static const Color accentColor = Color(0xFFB026FF);
```

## 📦 Dependencies

- **google_fonts**: Poppins and Inter fonts
- **flutter_dotenv**: Environment configuration
- **http**: API requests
- **Material 3**: Modern design system

## 🎯 Design Principles

1. **Premium Feel**: Dark theme with high-contrast accent
2. **Generous Spacing**: Uncluttered, breathable layout
3. **Clear Hierarchy**: Bold headings, readable body text
4. **Smooth Interactions**: Animations and transitions
5. **Informative States**: Loading, empty, and error states
6. **Accessibility**: High contrast, readable fonts, clear icons
7. **Console-Inspired**: Feels like a modern gaming platform
