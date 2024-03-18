import 'package:flutter/material.dart';
import '../Api/Api manager.dart';
import '../Models/movieModel.dart';

class MovieDetails extends StatefulWidget {
  static const String routeName = 'MovieDetails';

  final int movieId;

  const MovieDetails({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<Movie> _movieDetails;
  late Future<List<Movie>> _similarMovies;

  @override
  void initState() {
    super.initState();
    _movieDetails = Api().getMovieDetails(widget.movieId);
    _similarMovies = Api().getSimilarMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _movieDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final movie = snapshot.data as Movie;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.overview,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  FutureBuilder(
                    future: _similarMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final similarMovies = snapshot.data as List<Movie>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Similar Movies',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: similarMovies.length,
                                itemBuilder: (context, index) {
                                  final similarMovie = similarMovies[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MovieDetails(
                                                movieId: similarMovie.id),
                                          ),
                                        );
                                      },
                                      child: MovieCard(movie: similarMovie),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://image.tmdb.org/t/p/original/${movie.posterPath}',
          width: 120,
          height: 180,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 4),
        Text(
          movie.title,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
