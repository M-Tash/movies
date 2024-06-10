import 'package:flutter/material.dart';

import '../Api/FireBase.dart';
import '../Screens/MovieDetails.dart';
class WatchListItem extends StatefulWidget {
  int? id;
  String? imagePath;
  String? title;
  String? date;
  Function? fetchMovieIds;
  bool
      showDeleteIcon; // Add a parameter to control the visibility of the delete icon

  WatchListItem({super.key, required this.title,
      this.date,
      required this.imagePath,
      required this.id,
      this.fetchMovieIds,
      this.showDeleteIcon =
          true}); // Provide a default value for the showDeleteIcon parameter

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
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
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
                'https://image.tmdb.org/t/p/original/${widget.imagePath}',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${widget.title}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.date == null ? '' : '${widget.date}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  if (widget
                      .showDeleteIcon) // Check if the delete icon should be shown
                    Padding(
                      padding: const EdgeInsets.only(left: 150),
                      child: IconButton(
                        onPressed: () async {
                          await FireBase().deleteMovie(widget.id!);
                          setState(() {});
                          widget.fetchMovieIds!();
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 35),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
