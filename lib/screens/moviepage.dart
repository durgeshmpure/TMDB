import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/desc_test.dart';
import 'package:flutter_application_1/screens/re_widgets.dart';
import 'package:flutter_application_1/screens/seeall_page_movies.dart';
import 'package:flutter_application_1/screens/watclistProvider.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tmdb_api/tmdb_api.dart';

import 'package:cached_network_image/cached_network_image.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key? key}) : super(key: key);

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
  List trendingMovies = [];

  loadMovies() async {
    try {
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
      Map trendingmovieresult = await tmdbWithCustomLogs.v3.trending
          .getTrending(mediaType: MediaType.movie, timeWindow: TimeWindow.day);
      FlutterNativeSplash.remove();
      setState(() {
        inTheatreMovies = trendingresult['results'];
        topratedmovies = topratedmoviesresult['results'];
        popularMovies = popularMoviesresult['results'];
        upcomingMovies = upcomingMoviesresult['results'];
        trendingMovies = trendingmovieresult['results'];
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => Center(
            child: Text(
                  'No Internet Connection\nPlease check your internet connection ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
          ));
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Error Please check your Internet connection'),
      //     backgroundColor: Colors.red,
      //   ));
    }
  }

  getMovieList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String> movielistids = pref.getStringList('movieids') ?? [];
      return movielistids;
      // context.read<WatchListProvider>().getreferences(movielistids);
    } catch (e) {

    }
  }

  getSeriesList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String> serieslistids = pref.getStringList('seriesids') ?? [];
      return serieslistids;
      // context.read<WatchListProvider>().getreferences(movielistids);
    } catch (e) {
    }
  }

  checkList() async {
    try {
      List<String> cm = await getMovieList();
      List<String> cs = await getSeriesList();
      context.read<WatchListProvider>().getPreferences(cm);
      context.read<WatchListProvider>().getPreferencesSeries(cs);
    } catch (e) {
    }
  }

  @override
  void initState() {
    loadMovies();
    checkList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: inTheatreMovies.length != 0
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 11.0, bottom: 10, left: 15, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ' TMDB ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/default_user.png'),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 0, bottom: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('In Theatres',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900)),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeeAllPage(
                                      inTheatreMovies, 'In Theatres'),
                                )),
                            child: Text('See All',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                          )
                        ],
                      ),
                    ),
                    CarouselSlider.builder(
                        itemCount: inTheatreMovies.length,
                        itemBuilder: (context, index, realIndex) => InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Desctest(
                                          inTheatreMovies[index]['id']))),
                              child: CarouselItem(
                                  inTheatreMovies[index]['poster_path']
                                      .toString(),
                                  inTheatreMovies[index]['title'].toString(),
                                  inTheatreMovies[index]['release_date']
                                      .toString(),
                                  inTheatreMovies[index]['original_language']
                                      .toString()
                                      .toUpperCase()),
                            ),
                        options: CarouselOptions(
                            viewportFraction: 0.6,
                            enlargeCenterPage: true,
                            height: 400,
                            autoPlay: true,
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            autoPlayInterval: Duration(seconds: 4))),
                    listBuilderMovie(upcomingMovies, 'UpComing Movies'),
                    listBuilderMovie(trendingMovies, 'Trending Movies'),
                    listBuilderMovie(popularMovies, 'Popular Movies'),
                    listBuilderMovie(topratedmovies, 'TopRated Movies')
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}

class CarouselItem extends StatelessWidget {
  final String title;
  final String poster_path;

  final String releasedate;
  final String language;
  CarouselItem(this.poster_path, this.title, this.releasedate, this.language);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 400,
          height: 300,
          child: CachedNetworkImage(
            imageUrl: "https://image.tmdb.org/t/p/original/" + poster_path,
            fit: BoxFit.fill,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                LinearProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Image.asset(
              'images/default.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: Text(title,
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.white)),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Text(releasedate, style: TextStyle(color: Colors.white30)),
              Text(
                language,
                style: TextStyle(
                    color: Colors.white38, fontWeight: FontWeight.bold),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      )
    ]);
  }
}
