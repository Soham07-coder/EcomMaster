import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecomprj/providers/cart_provider.dart';
import 'package:ecomprj/route/route_constants.dart';
import 'package:ecomprj/route/router.dart' as router;
import 'package:ecomprj/theme/app_theme.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase (for authentication)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: Platform.isAndroid
            ? const FirebaseOptions(
          apiKey: 'AIzaSyB0U_OrBGTueeaiwmhoRrddNQHpei4LLj0',
          appId: '1:942827391657:android:00a9650c160e0683a777b8',
          messagingSenderId: '942827391657',
          projectId: 'flutterapp-c2e1f',
        )
            : null, // Use default options for iOS
      );
    }

    runApp(const MyApp());
  }, (error, stackTrace) {
    // Enhanced error logging
    print('Error during initialization: $error');
    print('Stack trace: $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Add other providers here as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop Template by The Flutter Way',
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        onGenerateRoute: router.generateRoute,
        initialRoute: onbordingScreenRoute,
      ),
    );
  }
}
