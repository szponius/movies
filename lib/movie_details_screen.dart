import 'package:flutter/material.dart';
import 'tmdb_api_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final TMDBApiService _apiService = TMDBApiService();

  Map<String, dynamic>? movieDetails;
  List<dynamic>? movieCast;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      final details = await _apiService.fetchMovieDetails(widget.movieId);
      final cast = await _apiService.fetchMovieCast(widget.movieId);
      setState(() {
        movieDetails = details;
        movieCast = cast;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading movie details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dodanie tła
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : movieDetails == null
              ? Center(child: Text("Failed to load movie details."))
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Obrazek i opis
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Obrazek filmu
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: movieDetails!['poster_path'] != null
                            ? Image.network(
                          "https://image.tmdb.org/t/p/w185${movieDetails!['poster_path']}",
                          height: 200,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          height: 200,
                          width: 120,
                          color: Colors.grey,
                          child: Icon(Icons.movie, size: 50),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Opis i data produkcji w przezroczystej ramce
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), // Półprzezroczysta ramka
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieDetails!['title'] ?? "No Title",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'moviesfont',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Release Date: ${movieDetails!['release_date'] ?? 'N/A'}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                              SizedBox(height: 16),
                              Text(
                                movieDetails!['overview'] ??
                                    "No description available.",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Nagłówek "Cast" na środku
                  Center(
                    child: Text(
                      "Cast",
                      style: TextStyle(
                        fontFamily: 'moviesfont',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Lista aktorów w przezroczystej ramce
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Półprzezroczysta ramka
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: movieCast == null || movieCast!.isEmpty
                        ? Text(
                      "No cast information available.",
                      style: TextStyle(color: Colors.white),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: movieCast!.length,
                      itemBuilder: (context, index) {
                        final actor = movieCast![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0),
                          child: Row(
                            children: [
                              // Zdjęcie aktora
                              actor['profile_path'] != null
                                  ? ClipRRect(
                                borderRadius:
                                BorderRadius.circular(8),
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w45${actor['profile_path']}",
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Icon(Icons.person,
                                  size: 45,
                                  color: Colors.white),
                              SizedBox(width: 16),
                              // Nazwa aktora
                              Expanded(
                                child: Text(
                                  actor['name'] ?? "Unknown",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
