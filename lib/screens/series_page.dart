import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/re_widgets.dart';
import 'package:flutter_application_1/screens/seeall_page_movies.dart';
import 'package:flutter_application_1/screens/series_desc.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'moviepage.dart';

class SeriesPage extends StatefulWidget {
  SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';

  List popularSeries = [];
  List topratedSeries = [];
  List trendingSeries = [];

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));

    Map popularresult = await tmdbWithCustomLogs.v3.tv.getPopular();
    Map topratedresult = await tmdbWithCustomLogs.v3.tv.getTopRated();
    Map trendinresult = await tmdbWithCustomLogs.v3.trending
        .getTrending(mediaType: MediaType.tv, timeWindow: TimeWindow.day);
    setState(() {
      popularSeries = popularresult['results'];
      topratedSeries = topratedresult['results'];
      trendingSeries = trendinresult['results'];
    });
  }

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: popularSeries.length != 0
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // / ///////////////////////////////////////////////////////This Displays the Header Part of the app

                    Padding(
                      padding: const EdgeInsets.only(top: 11.0, bottom: 10),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('images/me.jpg'),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 0, bottom: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Trending Series',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900)),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeeAllPage(
                                      trendingSeries, 'Trending Series'),
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
                        itemCount: trendingSeries.length,
                        itemBuilder: (context, index, realIndex) =>
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SeriesDesc(
                                          trendingSeries[index]['id']))),
                              child: CarouselItem(
                                  trendingSeries[index]['poster_path']
                                      .toString(),
                                  trendingSeries[index]['name'].toString(),
                                  trendingSeries[index]['first_air_date']
                                      .toString(),
                                  trendingSeries[index]['original_language']
                                      .toString()
                                      .toUpperCase()),
                            ),
                        options: CarouselOptions(
                            enlargeCenterPage: true,
                            viewportFraction: 0.7,
                            height: 400,
                            autoPlay: true,
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            autoPlayInterval: Duration(seconds: 4))),
                    listBuilderSeries(topratedSeries, 'TopRated Series'),
                    listBuilderSeries(popularSeries, 'Popular Series')
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
