import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  print('📦 Hive initialized');

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surfaceDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env file loaded successfully');
    print('🔑 API_KEY from .env: ${dotenv.env['API_KEY']?.substring(0, 8)}...');
    print('🌐 API_BASE_URL from .env: ${dotenv.env['API_BASE_URL']}');
    
    if (dotenv.env['API_KEY'] == null || dotenv.env['API_KEY']!.isEmpty) {
      print('❌ WARNING: API_KEY is empty or null!');
    }
  } catch (e) {
    print('❌ Error loading .env file: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuestLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}
