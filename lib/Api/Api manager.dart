import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/movieModel.dart'; // Import Movie model
import 'ApiConstats.dart'; // Import ApiConstants.dart to ensure apiKey is correctly defined

class Api {
  // Define URLs for various movie API endpoints
  final upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final searchApiUrl =
      "https://api.themoviedb.org/3/search/movie?api_key=$apiKey";
  final genreApiUrl =
      "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey";
  final discoverApiUrl =
      "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey";

  // Fetch upcoming movies from the API
  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  // Fetch popular movies from the API
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Fetch top rated movies from the API
  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  // Fetch details of a specific movie using its ID
  Future<Movie> getMovieDetails(int movieId) async {
    final movieDetailsUrl =
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey";

    final response = await http.get(Uri.parse(movieDetailsUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Movie.fromMap(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  // Fetch similar movies for a given movie ID
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final similarMoviesUrl =
        "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apiKey";

    final response = await http.get(Uri.parse(similarMoviesUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  // Search for movies based on a query string
  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse("$searchApiUrl&query=$query"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  // Fetch movies by a specific genre ID
  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    final response =
        await http.get(Uri.parse("$discoverApiUrl&with_genres=$genreId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to fetch movies by genre');
    }
  }

  // Fetch list of movie genres
  Future<List<Map<String, dynamic>>> getGenres() async {
    final response = await http.get(Uri.parse(genreApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['genres'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch genres');
    }
  }
}
