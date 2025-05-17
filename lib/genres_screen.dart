import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movies_screen.dart';
import 'tmdb_provider.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TMDBProvider>(context, listen: false);
    provider.fetchGenres(); // Pobierz gatunki z API
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TMDBProvider>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tło z obrazka
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          provider.isLoading
              ? Center(child: CircularProgressIndicator()) // Ładowanie
              : provider.errorMessage.isNotEmpty
              ? Center(child: Text(provider.errorMessage)) // Obsługa błędów
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 przyciski w rzędzie
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5, // Proporcje przycisku
              ),
              itemCount: provider.genres.length,
              itemBuilder: (context, index) {
                final genre = provider.genres[index];
                final isScienceFiction = genre['name'] == "Science Fiction"; // Specjalny przypadek

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesScreen(
                          genreId: genre['id'],
                          genreName: genre['name'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        genre['name'],
                        style: TextStyle(
                          fontFamily: 'moviesfont',
                          fontSize: isScienceFiction ? 16 : 20, // Mniejszy tekst dla Science Fiction
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: isScienceFiction
                            ? TextAlign.center
                            : TextAlign.left, // Wyśrodkowanie tekstu
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
