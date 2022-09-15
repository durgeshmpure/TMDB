import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/genre_page.dart';
import 'package:tmdb_api/tmdb_api.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List genrelist = [];
  List genrepostername = [
    'images/Action.png',
    'images/Adventure.png',
    'images/Animation.png',
    'images/Comedy.png',
    'images/Crime.png',
    'images/Documentaries.png',
    'images/Drama.png',
    'images/Family.png',
    'images/Fantasy.png',
    'images/History.png',
    'images/Horror.png',
    'images/Music.png',
    'images/Mystery.png',
    'images/Romance.png',
    'images/Science Fiction.png',
    'images/default.jpg',
    'images/Thriller.png',
    'images/War.png',
    'images/Westerns.png',
  ];
  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';
  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map trendingresult = await tmdbWithCustomLogs.v3.genres.getMovieList();

    setState(() {
      genrelist = trendingresult['genres'];
    });
  }

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Discover',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Container(
                    child: GridView.builder(
                        itemCount: genrelist.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 80 / 120,
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GenrePage(
                                              genrelist[index]['id'].toString(),
                                              genrelist[index]['name']
                                                  .toString())));
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    genrepostername[index],
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ))),
              ),
            ],
          ),
        ));
  }
}
