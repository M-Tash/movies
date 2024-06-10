import 'package:flutter/material.dart';
import 'package:movies/items/watchListItem.dart';

import '../Api/Api manager.dart'; // Import your API manager
import '../Models/movieModel.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'SearchScreen';

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Movie>> _searchResults = Future.value([]);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff121312),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xff121312),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: const TextStyle(color: Colors.white70),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMovies,
                ),
              ),
              onSubmitted: (_) {
                _searchMovies();
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<Movie>>(
      future: _searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "We're sorry, but it seems that the movie you're searching for isn't available in our database",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          List<Movie> movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                "No results found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              Movie movie = movies[index];
              return WatchListItem(
                showDeleteIcon: false,
                title: movie.title,
                imagePath: movie.posterPath,
                id: movie.id,
              );
            },
          );
        }
      },
    );
  }

  void _searchMovies() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      Api().searchMovies(query).then((movies) {
        setState(() {
          _searchResults = Future.value(movies);
          _isLoading = false;
        });
        print("Search completed with ${movies.length} results");
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        print("Error searching movies: $error");
      });
    }
  }
}
