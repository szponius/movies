import 'package:flutter/material.dart';
import 'actors_provider.dart';

class ActorDetailsScreen extends StatefulWidget {
  final int actorId;
  final String actorName;

  const ActorDetailsScreen({required this.actorId, required this.actorName});

  @override
  _ActorDetailsScreenState createState() => _ActorDetailsScreenState();
}

class _ActorDetailsScreenState extends State<ActorDetailsScreen> {
  Map<String, dynamic>? actorDetails;
  List<dynamic>? actorMovies;
  bool isLoading = true;

  final ActorsProvider _apiService = ActorsProvider();

  @override
  void initState() {
    super.initState();
    _loadActorDetails();
  }

  Future<void> _loadActorDetails() async {
    try {
      final details = await _apiService.fetchActorDetails(widget.actorId);
      final movies = await _apiService.fetchActorMovies(widget.actorId);
      setState(() {
        actorDetails = details;
        actorMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading actor details: $e");
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
          // Tło
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : actorDetails == null
              ? Center(child: Text("Failed to load actor details."))
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Zdjęcie aktora
                      actorDetails!['profile_path'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w185${actorDetails!['profile_path']}",
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        height: 200,
                        width: 120,
                        color: Colors.grey,
                        child: Icon(Icons.person, size: 50),
                      ),
                      SizedBox(width: 16),
                      // Informacje o aktorze
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.actorName,
                                style: TextStyle(
                                  fontFamily: 'moviesfont',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Known for: ${actorDetails!['known_for_department'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Birthday: ${actorDetails!['birthday'] ?? 'N/A'}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Lista filmów
                  Text(
                    "Movies",
                    style: TextStyle(
                      fontFamily: 'moviesfont',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  actorMovies == null || actorMovies!.isEmpty
                      ? Text(
                    "No movies found.",
                    style: TextStyle(color: Colors.white),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: actorMovies!.length,
                    itemBuilder: (context, index) {
                      final movie = actorMovies![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.5),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Text(
                            movie['title'] ?? "Unknown Movie",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
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
