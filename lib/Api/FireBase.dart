import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireBase {

  CollectionReference movies = FirebaseFirestore.instance.collection('movies');

  Future<void> addMovie(int movieId,bool isDone) {
    return movies
        .add({
          'movie_id': movieId,
          'is_done': isDone

        })
        .then((value) => log("movie Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  Future<void> deleteMovie(int movieId) async {
    try {
      QuerySnapshot querySnapshot =
          await movies.where('movie_id', isEqualTo: movieId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with the given movie_id
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.delete();
        log('Movie deleted successfully');
      } else {
        log('No movie found with the given ID');
      }
    } catch (error) {
      log('Failed to delete movie:$error');
    }
  }
}
