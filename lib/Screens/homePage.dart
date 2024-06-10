import 'package:flutter/material.dart';
import 'package:movies/Models/movieDetailsModel.dart';

import '../Api/Api manager.dart'; // Import API manager
import '../Models/movieModel.dart'; // Import Movie model
import 'MovieDetails.dart'; // Import MovieDetails screen

class HomePage extends StatefulWidget {
  static const String routeName = 'Home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index to track selected bottom navigation bar item
  late Future<List<MovieDetailsClass>>
      upcomingMovies; // Future for upcoming movies
  late Future<List<Movie>> popularMovies; // Future for popular movies
  late Future<List<MovieDetailsClass>>
      topRatedMovies; // Future for top rated movies
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    // Initialize futures to fetch movie data
    upcomingMovies = Api().getUpcomingMovies();
    popularMovies = Api().getPopularMovies();
    topRatedMovies = Api().getRecommended();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121312),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 20),
              height: 270,
              child: FutureBuilder<List<Movie>>(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final movies = snapshot.data!;
                  return PageView.builder(
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          navigateToMovieDetails(movie.id);// mask object mn movie
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 400,
                              decoration: BoxDecoration(
                                color: const Color(0xff121312),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 90, left: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: SizedBox(
                                  width: 120,
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(top: 225, left: 135),
                                child: Text(
                                  movie.title,
                                  style: const TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            FutureBuilder<List<MovieDetailsClass>>(
              future: upcomingMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final movies = snapshot.data!;
                return Container(
                  color: Color(0xff282A28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'New Releases',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            final movie = movies[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetails(movieId: movie.id!),
                                    ),
                                  );
                                },
                                child:
                                    MovieCard(movie: movie, movieId: movie.id!),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 270,
              child: FutureBuilder(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final movies = snapshot.data!;
                    return Container(
                      color: const Color(0xff282A28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Recommended',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            height: 210,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movies.length,
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                final movie = movies[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetails(movieId: movie.id!),
                                        ),
                                      );
                                    },
                                    child: MovieCard(
                                      movie: movie,
                                      movieId: movie.id!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }




  // Navigate to movie details screen
  void navigateToMovieDetails(int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetails(movieId: movieId)),
    );
  }
}
