import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/peoples_page.dart';
import 'package:flutter_application_1/screens/series_desc.dart';

import 'package:flutter_application_1/screens/watclistProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'desc_test.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({Key? key}) : super(key: key);

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  List<String> itemMovies = [];
  List<String> itemSeries = [];

  List<Map> results = [];

  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';

  loadmoives(String MovieId) async {
    var endpoint = Uri.parse(
        'https://api.themoviedb.org/3/movie/$MovieId?api_key=18ae282b0af89a13697e609ae851dac1&language=en-US');
    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    return body;
  }

  loadSeries(String seriesId) async {
    var endpoint = Uri.parse(
        'https://api.themoviedb.org/3/tv/$seriesId?api_key=18ae282b0af89a13697e609ae851dac1&language=en-US');
    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    return body;
  }

  setList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setStringList(
          'movieids', context.read<WatchListProvider>().movieIds);
      pref.setStringList(
          'seriesids', context.read<WatchListProvider>().seriesIds);
    } catch (e) {
      print(e);
    }
  }

  addmovies() async {
    for (String item in itemMovies) {
      Map c = await loadmoives(item);
      c['media_type'] = 'movie';
      setState(() {
        results.add(c);
      });
    }
  }

  addSeries() async {
    for (String item in itemSeries) {
      Map c = await loadSeries(item);
      c['media_type'] = 'tv';
      setState(() {
        results.add(c);
      });
    }
  }

  getnewlist() {
    setState(() {
      results = [];
    });
    addmovies();
    addSeries();
  }

  @override
  void initState() {
    itemMovies = context.read<WatchListProvider>().movieIds;
    itemSeries = context.read<WatchListProvider>().seriesIds;

    addmovies();
    addSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'WatchList',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
                results.length != 0
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      if (results[index]['media_type'] ==
                                          'movie') {
                                        return Desctest(results[index]['id']);
                                      } else if (results[index]['media_type'] ==
                                          'tv') {
                                        return SeriesDesc(results[index]['id']);
                                      } else {
                                        return PeoplesPage(
                                            results[index]['id']);
                                      }
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  width: 100,
                                                  child: results[index][
                                                                      'media_type']
                                                                  .toString() ==
                                                              'movie' ||
                                                          results[index][
                                                                      'media_type']
                                                                  .toString() ==
                                                              'tv'
                                                      ? CachedNetworkImage(
                                                          imageUrl: "https://image.tmdb.org/t/p/original/" +
                                                              results[index][
                                                                      'poster_path']
                                                                  .toString(),
                                                          fit: BoxFit.fill,
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              LinearProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'images/default.jpg',
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: "https://image.tmdb.org/t/p/original/" +
                                                              results[index][
                                                                      'profile_path']
                                                                  .toString(),
                                                          fit: BoxFit.fill,
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              LinearProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'images/default.jpg',
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              right: 10,
                                                              bottom: 10),
                                                      child: Container(height:25,
                                                        child: Text(
                                                          results[index]['title']
                                                                      .toString() !=
                                                                  'null'
                                                              ? results[index]
                                                                      ['title']
                                                                  .toString()
                                                              : results[index]
                                                                      ['name']
                                                                  .toString(),
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        results[index]['media_type']
                                                                    .toString() !=
                                                                'tv'
                                                            ? results[index][
                                                                    'media_type']
                                                                .toString()
                                                                .toUpperCase()
                                                            : 'SERIES',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                results[index][
                                                                            'media_type'] !=
                                                                        'person'
                                                                    ? Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .yellow,
                                                                        size:
                                                                            18,
                                                                      )
                                                                    : Container(),
                                                                results[index][
                                                                            'media_type'] !=
                                                                        'person'
                                                                    ? Text(
                                                                        results[index]['vote_average'].toString() +
                                                                            '/10',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                        ))
                                                                    : Text(
                                                                        'Known for ' +
                                                                            results[index]['known_for_department']
                                                                                .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                              width: 85,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                  results[index]['media_type']
                                                                              .toString() ==
                                                                          'movie'
                                                                      ? results[index]
                                                                              [
                                                                              'release_date']
                                                                          .toString()
                                                                      : results[index]['first_air_date'].toString() ==
                                                                              'null'
                                                                          ? ''
                                                                          : results[index]['first_air_date']
                                                                              .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0,
                                                                  top: 8),
                                                          child: Text(
                                                            results[index][
                                                                        'media_type'] !=
                                                                    'person'
                                                                ? results[index]
                                                                        [
                                                                        'original_language']
                                                                    .toString()
                                                                    .toUpperCase()
                                                                : results[index]['gender']
                                                                            .toString() ==
                                                                        '2'
                                                                    ? 'Male'
                                                                    : 'Female',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    context
                                                                        .read<
                                                                            WatchListProvider>()
                                                                        .removeMovietoList(
                                                                            results[index]['id'].toString());
                                                                    context
                                                                        .read<
                                                                            WatchListProvider>()
                                                                        .removeSeriestoList(
                                                                            results[index]['id'].toString());
                                                                    setList();
                                                                    getnewlist();
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      content: Text(
                                                                          'Removed Sucessfully'),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                    ));
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            157,
                                                                            155,
                                                                            155),
                                                                  )),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        color: Color.fromARGB(255, 32, 32, 32),
                                        height: 140,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }))
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: Text(
                            'Add Movies to watchlist',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ));
  }
}
