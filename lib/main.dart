import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies/Screens/homeScreen.dart';

import 'Screens/CategoryScreen.dart';
import 'Screens/SearchScreen.dart';
import 'Screens/WatchListScreen.dart';
import 'Screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        HomePage.routeName: (context) => const HomePage(),
        SearchScreen.routeName: (context) => const SearchScreen(),
        CategoryScreen.routeName: (context) => CategoryScreen(),
        WatchListScreen.routeName: (context) => const WatchListScreen(),
      },
    );
  }
}
