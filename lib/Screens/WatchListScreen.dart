import 'package:flutter/material.dart';

class WatchListScreen extends StatelessWidget {
  static const String routeName = 'WatchListScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch List'),
      ),
      body: Center(
        child: Text(
          'Watch List Screen Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
