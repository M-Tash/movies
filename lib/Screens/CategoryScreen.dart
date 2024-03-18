import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = 'CategoryScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Center(
        child: Text(
          'Category Screen Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
