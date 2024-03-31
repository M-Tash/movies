import 'package:cloud_firestore/cloud_firestore.dart';

class FireBase {
  // static Future<void> deleteTaskFromFireStore(Task task, String uId) {
  //   return getTasksCollection(uId).doc(task.id).delete();
  // }

  CollectionReference movies = FirebaseFirestore.instance.collection('movies');

  Future<void> addMovie(int movieId,bool isDone) {
    return movies
        .add({
          'movie_id': movieId,
          'is_done': isDone

        })
        .then((value) => print("movie Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> deleteMovie(int movieId) async {
    try {
      QuerySnapshot querySnapshot =
          await movies.where('movie_id', isEqualTo: movieId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with the given movie_id
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        await docSnapshot.reference.delete();
        print('Movie deleted successfully');
      } else {
        print('No movie found with the given ID');
      }
    } catch (error) {
      print('Failed to delete movie:$error');
    }
  }
}
