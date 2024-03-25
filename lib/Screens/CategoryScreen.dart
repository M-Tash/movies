import 'package:flutter/material.dart';
import 'package:movies/Api/Api%20manager.dart';
import 'package:movies/Screens/CategoryDetailsScreen.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = 'CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>>? genres;

  Future<void> fetchGenres() async {
    genres = await Api().getGenres();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGenres();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff121312),
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: fetchGenres(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Genres',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height - 200,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 1.3),
                              itemCount: genres?.length ?? 0,
                              itemBuilder: (context, index) {
                                final genre = genres?[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryDetailsScreen(
                                                genreId: genre?['id'] ?? 0),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/genre.jpg',
                                        height: 150,
                                        width: 200,
                                      ),
                                      Center(
                                        child: Text(
                                          genre?['name'] ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  void navigateToMovieDetails(int genreID) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryDetailsScreen(genreId: genreID)),
    );
  }
}
