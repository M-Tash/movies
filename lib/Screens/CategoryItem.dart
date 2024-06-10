import 'package:flutter/material.dart';

import '../Screens/MovieDetails.dart';

class CategoryItem extends StatefulWidget {
  int? id;
  String? imagePath;
  String? title;
  String? date;

  CategoryItem({
    super.key,
    required this.title,
    this.date,
    required this.imagePath,
    required this.id,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
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
        padding: const EdgeInsets.all(16.0),
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
                // Placeholder color
              ),
              // Replace 'imagePath' with your actual image path
              child: Image.network(
                'https://image.tmdb.org/t/p/original/${widget.imagePath}',
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0), // Spacer between title and date
                  // Date
                  Text(
                    widget.date == null ? '' : '${widget.date}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
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
