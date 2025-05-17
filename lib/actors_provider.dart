import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActorsProvider with ChangeNotifier {
  final String _baseUrl = "https://api.themoviedb.org/3";
  final String _apiKey = "948350a450415ab3c4b06cdeb4ed9b67";

  List<dynamic> _actors = [];
  bool _isLoading = false;
  String _errorMessage = "";

  List<dynamic> get actors => _actors;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchActors() async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final uri = Uri.parse("$_baseUrl/person/popular?api_key=$_apiKey");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _actors = jsonData['results'];
      } else {
        _errorMessage = "Failed to fetch actors.";
      }
    } catch (e) {
      _errorMessage = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchActorDetails(int actorId) async {
    final uri = Uri.parse("$_baseUrl/person/$actorId?api_key=$_apiKey");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch actor details.");
    }
  }

  Future<List<dynamic>> fetchActorMovies(int actorId) async {
    final uri =
    Uri.parse("$_baseUrl/person/$actorId/movie_credits?api_key=$_apiKey");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['cast'];
    } else {
      throw Exception("Failed to fetch actor movies.");
    }
  }
}
