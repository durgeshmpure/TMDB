import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_application_1/screens/peoples_page.dart';
import 'package:flutter_application_1/screens/reviewScreen.dart';
import 'package:flutter_application_1/screens/watclistProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SeriesDesc extends StatefulWidget {
  final int seriesID;
  const SeriesDesc(this.seriesID);

  @override
  State<SeriesDesc> createState() => _SeriesDescState();
}

class _SeriesDescState extends State<SeriesDesc> {
  bool isInWatchlist = false;
  Map SeriesDetails = {'name': 'Tom', 'age': '23'};
  List SeriesCredits = [];
  List SimilarSeries = [];
  List reviews = [];
  List Seriesseasons = [];
  List Seasons = [];
  int seasonNumber = 1;
  List episodeInfo = [];
  List videos = [];
  Map certifications = {};

  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';

  loadVideos(int id) async {
    var endpoint = Uri.parse(
        'https://api.themoviedb.org/3/tv/$id/videos?api_key=18ae282b0af89a13697e609ae851dac1&language=en-US');
    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);

    setState(() {
      videos = body['results'];
    });
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map trendingresult =
        await tmdbWithCustomLogs.v3.tv.getDetails(widget.seriesID);
    Map getCredits = await tmdbWithCustomLogs.v3.tv.getCredits(widget.seriesID);
    Map getSimilarSeries =
        await tmdbWithCustomLogs.v3.tv.getSimilar(widget.seriesID);
    Map reviewresult =
        await tmdbWithCustomLogs.v3.tv.getReviews(widget.seriesID);

    setState(() {
      SeriesDetails = trendingresult;
      SeriesCredits = getCredits['cast'];
      SimilarSeries = getSimilarSeries['results'];
      Seasons = SeriesDetails['seasons'];
      reviews = reviewresult['results'];
    });
  }
  setList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setStringList(
          'seriesids', context.read<WatchListProvider>().seriesIds);
    } catch (e) {
      print(e);
    }
  }

  loadEpi() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map getEpisodeInfo = await tmdbWithCustomLogs.v3.tvSeasons
        .getDetails(widget.seriesID, seasonNumber);
    setState(() {
      episodeInfo = getEpisodeInfo['episodes'];
    });
  }

  Future<void> _launchInBrowser(String key) async {
    String uriyt = 'https://www.youtube.com/watch?v=' + key;
    Uri url = Uri.parse(uriyt);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    loadMovies();
    loadEpi();
    setState(() {
      isInWatchlist = context
          .read<WatchListProvider>()
          .isSeriesInWatchlist(widget.seriesID.toString());
    });
    loadVideos(widget.seriesID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Seasons.length != 0
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 370,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              foregroundDecoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [0, 0.5],
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://image.tmdb.org/t/p/original/" +
                                        SeriesDetails['backdrop_path']
                                            .toString(),
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        LinearProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'images/default_wide.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 130,
                            left: 20,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 150,
                                    height: 210,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/original/" +
                                              SeriesDetails['poster_path']
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 90.0, left: 20),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Text(
                                            SeriesDetails['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                        SeriesDetails[
                                                                    'vote_average']
                                                                .toString() +
                                                            '/10',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  SeriesDetails['vote_count']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 113, 111, 111),
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                            Container(
                                                width: 85,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    SeriesDetails[
                                                            'first_air_date']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                SeriesDetails[
                                                            'number_of_seasons']
                                                        .toString() +
                                                    ' Seasons',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                isInWatchlist == false
                                                    ? context
                                                        .read<
                                                            WatchListProvider>()
                                                        .addSeriestoList(
                                                            SeriesDetails['id']
                                                                .toString())
                                                    : context
                                                        .read<
                                                            WatchListProvider>()
                                                        .removeSeriestoList(
                                                            SeriesDetails['id']
                                                                .toString());
                                                                setList();
                                                setState(() {
                                                  isInWatchlist =
                                                      !isInWatchlist;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: isInWatchlist ==
                                                                false
                                                            ? Text(
                                                                'Removed from Watchlist')
                                                            : Text(
                                                                'Added to The list')));
                                              },
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 30.0),
                                                  child: isInWatchlist != true
                                                      ? Icon(
                                                          Icons
                                                              .bookmark_add_outlined,
                                                          color: Colors.white,
                                                          size: 30,
                                                        )
                                                      : Icon(
                                                          Icons.bookmark_add,
                                                          color: Colors.white,
                                                          size: 30,
                                                        )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SeriesDetails['genres'].length != 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: SeriesDetails['genres'].length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Color.fromARGB(255, 138, 136, 136),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          SeriesDetails['genres'][index]
                                              ['name'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SeriesDetails['spoken_languages'].length != 0
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Languages Spoken :',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 35,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          SeriesDetails['spoken_languages']
                                              .length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              SeriesDetails['spoken_languages']
                                                      [index]['english_name']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SeriesDetails['overview'].toString() != ''
                        ? Container(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, bottom: 10, top: 10),
                                child: Text(
                                    SeriesDetails['overview'].toString() != ''
                                        ? 'Plot Summary'
                                        : 'No Description Available',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: ExpandableText(
                                    expandText: 'Show more',
                                    collapseText: 'Show less',
                                    maxLines: 3,
                                    SeriesDetails['overview'] != ''
                                        ? SeriesDetails['overview'].toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ],
                          ))
                        : Container(),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Seasons.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  seasonNumber =
                                      Seasons[index]['season_number'];

                                  loadEpi();
                                }),
                                child: Seasons[index]['season_number'] != 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: seasonNumber ==
                                                  Seasons[index]
                                                      ['season_number']
                                              ? Color.fromARGB(255, 82, 81, 81)
                                              : Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Season ' +
                                                Seasons[index]['season_number']
                                                    .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                              // ListView.builder(itemBuilder: (context, index) => Container(child: Text(''),),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: episodeInfo.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                color: Color.fromARGB(255, 32, 32, 32),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              height: 70,
                                              width: 110,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "https://image.tmdb.org/t/p/original" +
                                                        episodeInfo[index]
                                                                ['still_path']
                                                            .toString(),
                                                fit: BoxFit.fill,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        LinearProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  'images/default.jpg',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                episodeInfo[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTimeString(episodeInfo[
                                                                          index]
                                                                      [
                                                                      'runtime'] ==
                                                                  null
                                                              ? 0
                                                              : episodeInfo[
                                                                      index]
                                                                  ['runtime'])
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              142,
                                                              140,
                                                              140)),
                                                    ),
                                                    Text(
                                                      episodeInfo[index]
                                                              ['air_date']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              142,
                                                              140,
                                                              140)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: episodeInfo[index]['overview']
                                                    .toString() !=
                                                ''
                                            ? 50
                                            : 0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5, bottom: 5),
                                          child: Text(
                                            episodeInfo[index]['overview']
                                                .toString(),
                                            overflow: TextOverflow.fade,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                    videos.length != 0
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                      bottom: 00,
                                      top: 10),
                                  child: Text(
                                      videos.length != 0
                                          ? 'Videos'
                                          : 'No Videos Available',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: videos.length != 0 ? 200 : 0,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: videos.length,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                              onTap: () => _launchInBrowser(
                                                  videos[index]['key']),
                                              child: Container(
                                                width: 250,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 18.0),
                                                      child: Container(
                                                          child:
                                                              CachedNetworkImage(
                                                                  imageUrl:
                                                                      'https://img.youtube.com/vi/${videos[index]['key']}/0.jpg',
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  progressIndicatorBuilder: (context,
                                                                          url,
                                                                          downloadProgress) =>
                                                                      LinearProgressIndicator(
                                                                          value: downloadProgress
                                                                              .progress),
                                                                  errorWidget:
                                                                      (context,
                                                                              url,
                                                                              error) =>
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 20.0),
                                                                            child:
                                                                                Container(
                                                                              child: Image.asset(
                                                                                'images/default_wide.jpg',
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ))),
                                                    ),
                                                    Expanded(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 18.0),
                                                      child: Text(
                                                        videos[index]['name'],
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ))),
                              ],
                            ),
                          )
                        : Container(),
                    SeriesCredits.length != 0
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                      bottom: 10,
                                      top: 10),
                                  child: Text(
                                    SeriesCredits.length != 0
                                        ? 'Cast'
                                        : 'No Cast Information Available',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: SeriesCredits.length != 0 ? 230 : 0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: SeriesCredits.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PeoplesPage(
                                                SeriesCredits[index]['id']),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          child: Container(
                                            width: 100,
                                            height: 200,
                                            color:
                                                Color.fromARGB(255, 32, 32, 32),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 150,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://image.tmdb.org/t/p/original" +
                                                            SeriesCredits[index]
                                                                    [
                                                                    'profile_path']
                                                                .toString(),
                                                    fit: BoxFit.fill,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        LinearProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'images/default_user.png',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2.0,
                                                            top: 8),
                                                    child: Text(
                                                      SeriesCredits[index]
                                                          ['name'],
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      SeriesCredits[index]
                                                          ['character'],
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              179,
                                                              176,
                                                              176),
                                                          fontSize: 13)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    reviews.length != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, bottom: 10, top: 10),
                                child: Text('Top Reviews',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewPage(
                                                        reviews[index]['id']),
                                              ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          width: 300,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 47,
                                                    width: 200,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  top: 10),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            child: Container(
                                                              height: 40,
                                                              width: 40,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: "https://image.tmdb.org/t/p/original/" +
                                                                    reviews[index]['author_details']
                                                                            [
                                                                            'avatar_path']
                                                                        .toString(),
                                                                fit:
                                                                    BoxFit.fill,
                                                                progressIndicatorBuilder: (context,
                                                                        url,
                                                                        downloadProgress) =>
                                                                    LinearProgressIndicator(
                                                                        value: downloadProgress
                                                                            .progress),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  'images/default_user.png',
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              reviews[index]
                                                                  ['author'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.yellow,
                                                        ),
                                                        Text(
                                                          reviews[index]['author_details']
                                                                          [
                                                                          'rating']
                                                                      .toString() ==
                                                                  'null'
                                                              ? 'NR'
                                                              : reviews[index][
                                                                              'author_details']
                                                                          [
                                                                          'rating']
                                                                      .toString() +
                                                                  '/10',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    reviews[index]['content']
                                                        .toString(),
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 196, 193, 193),
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                  itemCount: reviews.length,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SeriesDetails['networks'].length != 0
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                      bottom: 10,
                                      top: 10),
                                  child: Text(
                                    'Stream',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: SeriesDetails['networks'].length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color:
                                              Color.fromARGB(255, 32, 32, 32),
                                          height: 50,
                                          width: 100,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "https://image.tmdb.org/t/p/original/" +
                                                            SeriesDetails['networks']
                                                                        [index][
                                                                    'logo_path']
                                                                .toString(),
                                                    fit: BoxFit.fill,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        LinearProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'images/default.jpg',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    SeriesDetails['networks']
                                                        [index]['name'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SimilarSeries.length != 0
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                      bottom: 0,
                                      top: 10),
                                  child: Text(
                                      SimilarSeries.length != 0
                                          ? 'Similar Series'
                                          : '',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  height: SimilarSeries.length != 0 ? 280 : 0,
                                  child: ListView.builder(
                                      itemCount: SimilarSeries.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return SeriesDesc(
                                                  SimilarSeries[index]['id']);
                                            }));
                                          },
                                          child: Container(
                                            width: 170,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Container(
                                                        width: 170,
                                                        height: 210,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: "https://image.tmdb.org/t/p/original/" +
                                                              SimilarSeries[
                                                                          index]
                                                                      [
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
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      child: Text(
                                                          SimilarSeries[index][
                                                                      'name'] !=
                                                                  null
                                                              ? SimilarSeries[
                                                                  index]['name']
                                                              : "Movie",
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            SimilarSeries[index]
                                                                        [
                                                                        'first_air_date'] !=
                                                                    null
                                                                ? SimilarSeries[
                                                                        index][
                                                                    'first_air_date']
                                                                : "Movie",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white30)),
                                                        Text(
                                                          SimilarSeries[index][
                                                                      'original_language'] !=
                                                                  null
                                                              ? SimilarSeries[
                                                                          index]
                                                                      [
                                                                      'original_language']
                                                                  .toUpperCase()
                                                              : "Movie",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white38,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

String getTimeString(int value) {
  final int hour = value ~/ 60;
  final int minutes = value % 60;
  return '${hour.toString().padLeft(2, "0")} h ${minutes.toString().padLeft(2, "0")} m';
}
