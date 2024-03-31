import 'package:flutter/material.dart';
import 'package:movies/Screens/WatchListScreen.dart';

import '../Api/FireBase.dart';
import '../Screens/MovieDetails.dart';

class WatchListItem extends StatefulWidget {
  int? id;
  String? imagePath;
  String? title;
  String? date;
  Function? fetchMovieIds;

  WatchListItem(
      {required this.title,
      this.date,
      required this.imagePath,
      required this.id,
      this.fetchMovieIds});

  @override
  State<WatchListItem> createState() => _WatchListItemState();
}

class _WatchListItemState extends State<WatchListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(movieId: widget.id!),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Picture
            Container(
              width: 110,
              height: 150,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300], // Placeholder color
              ),
              // Replace 'imagePath' with your actual image path
              child: Image.network(
                'https://image.tmdb.org/t/p/original/${widget.imagePath}',
                // Placeholder image
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0), // Spacer between picture and text
            // Title and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title
                  Text(
                    '${widget.title}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0), // Spacer between title and date
                  // Date
                  Text(
                    widget.date == null ? '' : '${widget.date}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         FireBase().deleteMovie(widget.id!);
                  //         widget.fetchMovieIds!();
                  //       });
                  //     },
                  //     child: Text('delete')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchMovieIds() {}
}