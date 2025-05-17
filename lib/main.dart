import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'tmdb_provider.dart';
import 'actors_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dodaj obsługę błędów inicjalizacji Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Błąd inicjalizacji Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TMDBProvider()),
        ChangeNotifierProvider(create: (_) => ActorsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TMDb Filmy & Actors',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => HomeScreen(),
        },
        // Dodaj obsługę nieznanych tras (opcjonalne)
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Nie znaleziono trasy: ${settings.name}'),
            ),
          ),
        ),
      ),
    );
  }
}