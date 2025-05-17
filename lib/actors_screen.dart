import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'actors_provider.dart';
import 'actor_details_screen.dart';

class ActorsScreen extends StatefulWidget {
  @override
  _ActorsScreenState createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ActorsProvider>(context, listen: false);
    provider.fetchActors();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActorsProvider>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tło
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.errorMessage.isNotEmpty
              ? Center(child: Text(provider.errorMessage))
              : ListView.builder(
            itemCount: provider.actors.length,
            itemBuilder: (context, index) {
              final actor = provider.actors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActorDetailsScreen(
                          actorId: actor['id'],
                          actorName: actor['name'],
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
                    child: ListTile(
                      leading: actor['profile_path'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w92${actor['profile_path']}",
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(Icons.person, size: 45),
                      title: Text(
                        actor['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Known for: ${actor['known_for_department']}",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
