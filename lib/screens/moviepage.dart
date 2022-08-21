
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:badges/badges.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {



  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';
  List inTheatreMovies = [];
  List topratedmovies = [];
  List popularMovies = [];
  List upcomingMovies = [];
  

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map trendingresult =
        await tmdbWithCustomLogs.v3.movies.getNowPlaying(region: 'IN');
    Map topratedmoviesresult =
        await tmdbWithCustomLogs.v3.movies.getTopRated(region: 'IN');
    Map popularMoviesresult =
        await tmdbWithCustomLogs.v3.movies.getPopular(region: 'IN');
    Map upcomingMoviesresult =
        await tmdbWithCustomLogs.v3.movies.getUpcoming(region: 'IN');

    setState(() {
      inTheatreMovies = trendingresult['results'];
      topratedmovies = topratedmoviesresult['results'];
      popularMovies = popularMoviesresult['results'];
      upcomingMovies = upcomingMoviesresult['results'];
    });
  }

  @override
  void initState() {
    loadMovies();
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
   return  SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // / ///////////////////////////////////////////////////////This Displays the Header Part of the app

              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' Hello Durgesh ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('images/me.jpg'),
                    )
                  ],
                ),
              ),
              ////////////////////////////////////////////////////this Part displays the search bar in top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                      hoverColor: Colors.orange[400],
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search)),
                ),
              ),

              //ListView

              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
                child: Text('In Theatres',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900)),
              ),

              //Displays The List Of Movies

              Container(
                height: 280,
                child: ListView.builder(
                    itemCount: inTheatreMovies.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 170,
                                    height: 210,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/w500/" +
                                              inTheatreMovies[index]
                                                      ['poster_path']
                                                  .toString(),
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LinearProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'images/default.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                    inTheatreMovies[index]['title'] != null
                                        ? inTheatreMovies[index]['title']
                                        : "Movie",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10.0),
                                child: Row(children: [
                                  Text(inTheatreMovies[index]['release_date'] != null
                                            ? inTheatreMovies[index]['release_date']
                                            : "Movie",
                                        style: TextStyle(color: Colors.white30)),
                                   Text(inTheatreMovies[index]['original_language'] != null
                                            ? inTheatreMovies[index]['original_language'].toUpperCase()
                                            : "Movie",
                                        style: TextStyle(color: Colors.white38,fontWeight: FontWeight.bold),)     
                                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                              )
                            ]),
                      );
                    }),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
                child: Text(
                  'Upcoming Movies',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                height: 280,
                child: ListView.builder(
                    itemCount: upcomingMovies.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 170,
                                    height: 210,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/w500/" +
                                              upcomingMovies[index]
                                                      ['poster_path']
                                                  .toString(),
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LinearProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'images/default.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                    upcomingMovies[index]['title'] != null
                                        ? upcomingMovies[index]['title']
                                        : "Movie",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10.0),
                                child: Row(children: [
                                  Text(upcomingMovies[index]['release_date'] != null
                                            ? upcomingMovies[index]['release_date']
                                            : "Movie",
                                        style: TextStyle(color: Colors.white30)),
                                   Text(upcomingMovies[index]['original_language'] != null
                                            ? upcomingMovies[index]['original_language'].toUpperCase()
                                            : "Movie",
                                        style: TextStyle(color: Colors.white38,fontWeight: FontWeight.bold),)     
                                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                              )
                            ]),
                      );
                    }),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
                child: Text('Popular Movies',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),

              Container(
                height: 280,
                child: ListView.builder(
                    itemCount: popularMovies.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 170,
                                    height: 210,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/w500/" +
                                              popularMovies[index]
                                                      ['poster_path']
                                                  .toString(),
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LinearProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'images/default.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                    popularMovies[index]['title'] != null
                                        ? popularMovies[index]['title']
                                        : "Movie",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10.0),
                                child: Row(children: [
                                  Text(popularMovies[index]['release_date'] != null
                                            ? popularMovies[index]['release_date']
                                            : "Movie",
                                        style: TextStyle(color: Colors.white30)),
                                   Text(popularMovies[index]['original_language'] != null
                                            ? popularMovies[index]['original_language'].toUpperCase()
                                            : "Movie",
                                        style: TextStyle(color: Colors.white38,fontWeight: FontWeight.bold),)     
                                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                              )
                            ]),
                      );
                    }),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
                child: Text('TopRated Movies',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),

              Container(
                height: 280,
                child: ListView.builder(
                    itemCount: topratedmovies.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 170,
                                    height: 210,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/w500/" +
                                              topratedmovies[index]
                                                      ['poster_path']
                                                  .toString(),
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LinearProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'images/default.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                    topratedmovies[index]['title'] != null
                                        ? topratedmovies[index]['title']
                                        : "Movie",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10.0),
                                child: Row(children: [
                                  Text(topratedmovies[index]['release_date'] != null
                                            ? topratedmovies[index]['release_date']
                                            : "Movie",
                                        style: TextStyle(color: Colors.white30)),
                                   Text(topratedmovies[index]['original_language'] != null
                                            ? topratedmovies[index]['original_language'].toUpperCase()
                                            : "Movie",
                                        style: TextStyle(color: Colors.white38,fontWeight: FontWeight.bold),)     
                                ],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                              )
                            ]),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}