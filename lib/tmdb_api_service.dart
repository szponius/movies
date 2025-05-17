import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApiService {
  final String _baseUrl = "api.themoviedb.org";
  final String _apiKey = "948350a450415ab3c4b06cdeb4ed9b67"; 

  // Pobieranie gatunków
  Future<List<dynamic>> fetchGenres() async {
    final uri = Uri.https(
      _baseUrl,
      "/3/genre/movie/list",
      {"api_key": _apiKey},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['genres'];
    } else {
      throw Exception("Failed to fetch genres. Error: ${response.body}");
    }
  }

  // Pobieranie filmów według gatunku
  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    final uri = Uri.https(
      _baseUrl,
      "/3/discover/movie",
      {
        "api_key": _apiKey,
        "with_genres": "$genreId",
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['results'];
    } else {
      throw Exception("Failed to fetch movies for genre ID $genreId. Error: ${response.body}");
    }
  }

  // Pobieranie szczegółów filmu
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final uri = Uri.https(
      _baseUrl,
      "/3/movie/$movieId",
      {
        "api_key": _apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch movie details for ID $movieId. Error: ${response.body}");
    }
  }

  // Pobieranie obsady filmu
  Future<List<dynamic>> fetchMovieCast(int movieId) async {
    final uri = Uri.https(
      _baseUrl,
      "/3/movie/$movieId/credits",
      {
        "api_key": _apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['cast'];
    } else {
      throw Exception("Failed to fetch movie cast for ID $movieId. Error: ${response.body}");
    }
  }

  // Pobieranie popularnych aktorów z opcjonalną paginacją
  Future<List<dynamic>> fetchPopularPersons({int page = 1}) async {
    final uri = Uri.https(
      _baseUrl,
      "/3/person/popular",
      {
        "api_key": _apiKey,
        "page": "$page",
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['results'];
    } else {
      throw Exception("Failed to fetch popular persons. Error: ${response.body}");
    }
  }
}
