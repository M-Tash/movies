import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Api/Api manager.dart';
import '../Models/movieDetailsModel.dart';

class MovieDetails extends StatefulWidget {
  static const String routeName = 'MovieDetails';
  final int movieId;

  const MovieDetails({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<MovieDetailsClass?> _movieDetails;
  late Future<List<MovieDetailsClass?>> _similarMovies;

  @override
  void initState() {
    super.initState();
    _movieDetails = Api().getDetails(widget.movieId);
    _similarMovies = Api().getSimilarMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121312),
      body: SingleChildScrollView(
        child: FutureBuilder<MovieDetailsClass?>(
          future: _movieDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final movie = snapshot.data as MovieDetailsClass;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                        width: 412,
                        height: 220,
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.topCenter,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 5),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Text(
                      movie.originalTitle!,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: Text(
                      ' ${movie.releaseDate}  ${movie.runtime! ~/ 60}h  ${movie.runtime! % 60}m ',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                          width: 129,
                          height: 199,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Row(
                              children: [
                                TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        side: const BorderSide(
                                            width: 1, color: Colors.white)),
                                    onPressed: () {
                                      // todo:go to genre
                                    },
                                    child: Text('${movie.genres![0].name}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ))),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            width: 235,
                            height: 120,
                            child: Text(
                              movie.overview!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xffFFBB3B),
                                  size: 30,
                                ),
                                Text(
                                  movie.voteAverage!.toString().substring(0, 3),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FutureBuilder(
                    future: _similarMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final similarMovies =
                        snapshot.data as List<MovieDetailsClass>;
                        return Container(
                          color: const Color(0xff282A28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'More Like This',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 210,
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
                                              builder: (context) =>
                                                  MovieDetails(
                                                      movieId:
                                                          similarMovie.id!),
                                            ),
                                          );
                                        },
                                        child: MovieCard(
                                          movie: similarMovie,
                                          movieId: similarMovie.id!,
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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatefulWidget {
  final MovieDetailsClass movie;
  final int movieId;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  late bool isSelected;
  late CollectionReference movies;

  @override
  void initState() {
    super.initState();
    isSelected = false;
    movies = FirebaseFirestore.instance.collection('movies');
    fetchBookmarkStatus();
  }

  Future<void> fetchBookmarkStatus() async {
    final snapshot = await movies.doc(widget.movie.id.toString()).get();
    if (snapshot.exists) {
      setState(() {
        isSelected = snapshot.get('is_done');
      });
    }
  }

  Future<void> updateBookmarkStatus(bool value) async {
    // Get a reference to the document for this movie ID
    final movieDoc = movies.doc(widget.movie.id.toString());

    // Check if the document already exists in Firestore
    movieDoc.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        // If the document exists, update the bookmark status
        movieDoc.update({
          'is_done': value,
        }).then((_) {
          setState(() {
            isSelected = value;
          });
        });
      } else {
        // If the document doesn't exist, add it with the movie ID and bookmark status
        movieDoc.set({
          'movie_id': widget.movie.id, // Store the movie ID
          'is_done': value,
        }).then((_) {
          setState(() {
            isSelected = value;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: const BoxDecoration(color: Color(0xff343534)),
        height: 200,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        heightFactor: 2,
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                  'https://image.tmdb.org/t/p/original/${widget.movie.posterPath}',
                  width: 100,
                  height: 127,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    // Return a placeholder widget or an error message
                    return const Placeholder(
                      fallbackWidth: 100,
                      fallbackHeight: 127,
                    ); // You can replace Placeholder with any other widget
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                      updateBookmarkStatus(isSelected);
                    });
                  },
                  child: Icon(Icons.bookmark,
                      size: 30,
                      color:
                          isSelected ? const Color(0xffFFBB3B) : Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xffFFBB3B),
                  size: 15,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  widget.movie.voteAverage!.toString().substring(
                      0, min(3, widget.movie.voteAverage!.toString().length)),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 100,
              height: 26,
              child: Text(
                ' ${widget.movie.originalTitle!}',
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            SizedBox(
              width: 70,
              child: Row(
                children: [
                  Text(
                    '   ${widget.movie.releaseDate!.substring(0, 4)}',
                    style: const TextStyle(fontSize: 8, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
