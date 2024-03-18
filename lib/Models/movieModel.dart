class Movie {
  final int id; // Add id property
  final String title;
  final String backDropPath;
  final String overview;
  final String posterPath;

  Movie({
    required this.id, // Add id parameter to the constructor
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      // Assign value to id property
      title: map['title'],
      backDropPath: map['backdrop_path'],
      overview: map['overview'],
      posterPath: map['poster_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in the map
      'title': title,
      'backDropPath': backDropPath,
      'overview': overview,
      'posterPath': posterPath,
    };
  }
}
