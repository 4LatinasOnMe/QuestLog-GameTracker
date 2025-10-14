# API Setup Guide

## How to Add Your API Key

### Step 1: Open the `.env` file
The `.env` file is located in the root directory of your project:
```
QuestLog/.env
```

### Step 2: Replace the placeholder with your actual API key
Open the `.env` file and replace `YOUR_API_KEY_HERE` with your actual API key:

```env
API_KEY=your_actual_api_key_here
API_BASE_URL=https://api.example.com
```

**Example:**
```env
API_KEY=sk_1234567890abcdef
API_BASE_URL=https://api.rawg.io/api
```

### Step 3: Update the API Base URL
Replace `https://api.example.com` with your actual API endpoint URL.

### Step 4: Install dependencies
Run the following command to install the required packages:
```bash
flutter pub get
```

### Step 5: Run the app
```bash
flutter run
```

## Important Security Notes

✅ **DO:**
- Keep your `.env` file private
- The `.env` file is already added to `.gitignore` to prevent accidental commits
- Never share your API key publicly

❌ **DON'T:**
- Commit the `.env` file to version control
- Share your API key in screenshots or code snippets
- Hardcode API keys directly in your code

## How the API Key is Used

The API key is accessed through the `AppConfig` class:

```dart
import 'package:questlog/config/app_config.dart';

// Access the API key
String apiKey = AppConfig.apiKey;
String baseUrl = AppConfig.apiBaseUrl;
```

The `ApiService` class automatically uses these values when making API requests.

## Testing Without Real API

If you want to test the app without connecting to a real API, you can use the mock data method:

In `lib/screens/home_screen.dart`, change:
```dart
_gamesFuture = _apiService.fetchGames();
```

To:
```dart
_gamesFuture = _apiService.fetchGamesMock();
```

This will use the mock data instead of making real API calls.
