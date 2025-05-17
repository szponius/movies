import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tmdb_provider.dart';
import 'movie_details_screen.dart'; // Import ekranu szczegółów filmu

class MoviesScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const MoviesScreen({required this.genreId, required this.genreName});

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool _sortByRating = false; // Flaga do sortowania (domyślnie alfabetycznie)

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TMDBProvider>(context, listen: false);
    provider.fetchMoviesByGenre(widget.genreId); // Pobierz filmy dla kategorii
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TMDBProvider>(context);

    // Sortowanie filmów
    final sortedMovies = List.from(provider.movies);
    sortedMovies.sort((a, b) {
      if (_sortByRating) {
        return b['vote_average'].compareTo(a['vote_average']); // Sortowanie po ocenie (malejąco)
      } else {
        return a['title'].toLowerCase().compareTo(b['title'].toLowerCase()); // Sortowanie alfabetyczne
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tło z obrazka
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              // Sortowanie na górze
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () {
                        setState(() {
                          _sortByRating = false; // Sortuj alfabetycznie
                        });
                      },
                      child: Text(
                        'Alphabetical',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () {
                        setState(() {
                          _sortByRating = true; // Sortuj po ocenie
                        });
                      },
                      child: Text(
                        'By Rating',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Lista filmów
              Expanded(
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator()) // Ładowanie
                    : provider.movies.isEmpty
                    ? Center(child: Text("No movies found")) // Brak filmów
                    : ListView.builder(
                  itemCount: sortedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = sortedMovies[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7), // Półprzezroczysta ramka
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            // Nawigacja do ekranu szczegółów filmu
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(
                                  movieId: movie['id'], // Przekazanie ID filmu
                                ),
                              ),
                            );
                          },
                          leading: movie['poster_path'] != null
                              ? Image.network(
                            "https://image.tmdb.org/t/p/w92${movie['poster_path']}",
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.movie),
                          )
                              : Icon(Icons.movie),
                          title: Text(
                            movie['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Rating: ${movie['vote_average']}",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
