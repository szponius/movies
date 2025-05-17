import 'package:filmy/login_screen.dart';
import 'package:flutter/material.dart';
import 'genres_screen.dart';
import 'actors_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tło z obrazka
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          // Wycentrowane przyciski w kolumnie
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Przycisk "Movies"
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GenresScreen()),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 100,
                    margin: EdgeInsets.only(bottom: 20), // Odstęp między przyciskami
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7), // Tło z przezroczystością
                      borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5), // Cień przycisku
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'MOVIES',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily:'moviesfont' ,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Przycisk "Actors"
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7), // Tło z przezroczystością
                      borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5), // Cień przycisku
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'ACTORS',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'moviesfont',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
