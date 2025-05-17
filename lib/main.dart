import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'tmdb_provider.dart';
import 'actors_provider.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TMDBProvider()), // Provider dla filmów i gatunków
        ChangeNotifierProvider(create: (_) => ActorsProvider()), // Provider dla aktorów
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TMDb Movies & Actors',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
