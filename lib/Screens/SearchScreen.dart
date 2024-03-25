import 'package:flutter/material.dart';
import 'package:movies/items/watchListItem.dart';

import '../Api/Api manager.dart'; // Import your API manager
import '../Models/movieModel.dart';
import 'MovieDetails.dart'; // Import your Movie model

class SearchScreen extends StatefulWidget {
  static const String routeName = 'SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<Movie>> _searchResults = Future.value([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
         backgroundColor: Colors.black ,
        title: Text(
          'Search',
          style:
              TextStyle(color: Colors.white), // Set app bar text color to white
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              // Set text color of search bar to white
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: TextStyle(color: Colors.white70),
                // Set hint text color to white70
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchMovies();
                  },
                ),
              ),
              onSubmitted: (_) {
                _searchMovies();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                          color: Colors.white), // Set text color to white
                    ),
                  );
                } else {
                  List<Movie> movies = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      Movie movie = movies[index];
                      return WatchListItem(title: movie.title, imagePath: movie.posterPath,id: movie.id);
                      //   ListTile(
                      //   title: Text(
                      //     movie.title,
                      //     style: TextStyle(
                      //         color: Colors.white), // Set text color to white
                      //   ),
                      //   onTap: () {
                      //     // Navigate to movie details screen
                      //     navigateToMovieDetails(movie.id);
                      //   },
                      // );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchMovies() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = Api().searchMovies(query);
      });
    }
  }

  void navigateToMovieDetails(int movieId) {
    // Implement navigation to movie details screen
    Navigator.pushNamed(context, MovieDetails.routeName, arguments: movieId);
  }
}
