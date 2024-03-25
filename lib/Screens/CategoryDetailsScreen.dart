import 'package:flutter/material.dart';
import 'package:movies/Screens/CategoryItem.dart';

import '../Api/Api manager.dart'; // Import your API manager
import '../Models/movieModel.dart';
import 'MovieDetails.dart'; // Import your Movie model

class CategoryDetailsScreen extends StatefulWidget {
  static const String routeName = 'CategoryScreen';
  final int genreId;

  const CategoryDetailsScreen({Key? key, required this.genreId})
      : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  late Future<List<Movie>> genreResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genreResult = Api().getMoviesByGenre(widget.genreId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style:
              TextStyle(color: Colors.white), // Set app bar text color to white
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: genreResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${'error'}',
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
                      return CategoryItem(
                          title: movie.title,
                          imagePath: movie.posterPath,
                          id: movie.id);
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

  void navigateToMovieDetails(int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetails(movieId: movieId)),
    );
  }
}
