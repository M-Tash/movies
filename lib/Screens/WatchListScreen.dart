import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies/items/watchListItem.dart';

import '../Api/Api manager.dart';
import '../Models/movieDetailsModel.dart';

class WatchListScreen extends StatefulWidget {
  static const String routeName = 'WatchListScreen';

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  List<int> movieIds = []; // List to store movie IDs

  late Future<List<MovieDetailsClass?>> _movieDetailsList = Future.value([]);

  @override
  void initState() {
    super.initState();
    fetchMovieIds();
  }

  Future<void> fetchMovieIds() async {
    // Fetch movie IDs from Firestore collection
    FirebaseFirestore.instance
        .collection('movies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        movieIds = querySnapshot.docs.map((doc) => doc["movie_id"] as int).toList();
        _movieDetailsList = fetchMovieDetails(); // Initialize _movieDetailsList here
      });
    }).catchError((error) {
      // Handle error if fetching movie IDs fails
      print('Failed to fetch movie IDs: $error');
    });
  }

  Future<List<MovieDetailsClass?>> fetchMovieDetails() async {
    List<MovieDetailsClass?> detailsList = [];
    for (int i = 0; i < movieIds.length; i++) {
      final movieDetails = await Api().getDetails(movieIds[i]);
      detailsList.add(movieDetails);
    }
    return detailsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff282A28),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  Color(0xff282A28),
        title: Text('WatchList',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25
        ),
        ),
      ),
      body: FutureBuilder<List<MovieDetailsClass?>>(
        future: _movieDetailsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Display the list of movie details
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(color: Colors.white,
                    height: 2,indent: 5,endIndent: 5,);
              },
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movieDetails = snapshot.data![index];
                return
                    WatchListItem(title: movieDetails?.title,
                        date: movieDetails?.releaseDate,
                        imagePath: movieDetails?.posterPath,
                    id: movieDetails?.id)
                  // ListTile(
                  // title: Text(
                  //   'Movie ID: ${movieIds[index]}',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  // subtitle: movieDetails != null
                  //     ? Text('Details: ${movieDetails.title}')
                  //     : Text('Details not available'),
               // )
                ;
              },
            );
          }
        },
      ),
    );
  }
}
