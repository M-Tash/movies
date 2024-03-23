import 'package:flutter/material.dart';

class WatchListItem extends StatelessWidget  {

String? imagePath;
String? title;
String? date;

WatchListItem({required this.title,required this.date,required this.imagePath});

  @override
  Widget build(BuildContext context) {

  return  Container(
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
              'https://image.tmdb.org/t/p/original/${imagePath}', // Placeholder image
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
                  '$title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0), // Spacer between title and date
                // Date
                Text(
                  '$date',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

}