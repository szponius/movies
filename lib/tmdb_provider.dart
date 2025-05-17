import 'package:flutter/material.dart';
import 'tmdb_api_service.dart';

class TMDBProvider with ChangeNotifier {
  final TMDBApiService _apiService = TMDBApiService();
  List<dynamic> _genres = [];
  List<dynamic> _movies = [];
  bool _isLoading = false;
  String _errorMessage = "";

  List<dynamic> get genres => _genres;
  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Pobieranie gatunków
  Future<bool> fetchGenres() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _apiService.fetchGenres();
      if (response.isNotEmpty) {
        _genres = response;
        print("Genres fetched successfully: $_genres"); // Debugowanie
        return true;
      } else {
        _errorMessage = "No genres found.";
        print("No genres found."); // Debugowanie
        return false;
      }
    } catch (e) {
      _errorMessage = "Failed to load genres: $e";
      print("Error fetching genres: $e"); // Debugowanie
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pobieranie filmów według gatunku
  Future<bool> fetchMoviesByGenre(int genreId) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _apiService.fetchMoviesByGenre(genreId);
      if (response.isNotEmpty) {
        _movies = response;
        print("Movies fetched successfully for genre $genreId: $_movies"); // Debugowanie
        return true;
      } else {
        _errorMessage = "No movies found for genre $genreId.";
        print("No movies found for genre $genreId."); // Debugowanie
        return false;
      }
    } catch (e) {
      _errorMessage = "Failed to load movies: $e";
      print("Error fetching movies for genre $genreId: $e"); // Debugowanie
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
