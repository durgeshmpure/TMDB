import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/reviewScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_application_1/screens/peoples_page.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'watclistProvider.dart';
import 'package:provider/provider.dart';

class Desctest extends StatefulWidget {
  final int movieId;
  const Desctest(this.movieId);

  @override
  State<Desctest> createState() => _DesctestState();
}

class _DesctestState extends State<Desctest> {
  bool isInWatchlist = false;
  Map MovieDetails = {};
  List Moviecredits = [];
  List SimilarMovies = [];
  List videos = [];
  String videoThumbnail = '';
  List Flatrate = [];
  List buy = [];
  List rent = [];
  List watchProvidersStream = [];
  List watchProvidersRent = [];
  List watchProvidersBuy = [];
  Map certifications = {};
  List reviews = [];

  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';
  setList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setStringList(
          'movieids', context.read<WatchListProvider>().movieIds);
    } catch (e) {
      print(e);
    }
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map trendingresult =
        await tmdbWithCustomLogs.v3.movies.getDetails(widget.movieId);
    Map getCredits =
        await tmdbWithCustomLogs.v3.movies.getCredits(widget.movieId);
    Map getSimilarMovies =
        await tmdbWithCustomLogs.v3.movies.getSimilar(widget.movieId);

    Map videosresult =
        await tmdbWithCustomLogs.v3.movies.getVideos(widget.movieId);
    Map watchProvidersResult =
        await tmdbWithCustomLogs.v3.movies.getWatchProviders(widget.movieId);
    Map reviewresult =
        await tmdbWithCustomLogs.v3.movies.getReviews(widget.movieId);

    setState(() {
      MovieDetails = trendingresult;
      Moviecredits = getCredits['cast'];
      SimilarMovies = getSimilarMovies['results'];
      videos = videosresult['results'];
      reviews = reviewresult['results'];
      // certifications = certificationsresult['results'];

      try {
        watchProvidersStream =
            watchProvidersResult['results']['IN']['flatrate'];
      } catch (e) {
        watchProvidersStream = [];
      }
      try {
        watchProvidersRent = watchProvidersResult['results']['IN']['rent'];
      } catch (e) {
        watchProvidersStream = [];
      }
      try {
        watchProvidersBuy = watchProvidersResult['results']['IN']['buy'];
      } catch (e) {
        watchProvidersStream = [];
      }
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
    setState(() {
      isInWatchlist = context
          .read<WatchListProvider>()
          .isMovieInWatchlist(widget.movieId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: MovieDetails['spoken_languages'] == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                                        MovieDetails['backdrop_path']
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
                                              MovieDetails['poster_path']
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
                                            MovieDetails['title'].toString(),
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
                                                        MovieDetails[
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
                                                  MovieDetails['vote_count']
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
                                                    MovieDetails['release_date']
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
                                                getTimeString(
                                                    MovieDetails['runtime']),
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
                                                        .addMovietoList(
                                                            MovieDetails['id']
                                                                .toString())
                                                    : context
                                                        .read<
                                                            WatchListProvider>()
                                                        .removeMovietoList(
                                                            MovieDetails['id']
                                                                .toString());
                                                setList();
                                                setState(() {
                                                  isInWatchlist =
                                                      !isInWatchlist;
                                                });
                                                setList();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: isInWatchlist ==
                                                                false
                                                            ? Text(
                                                                'Removed from Watch list')
                                                            : Text(
                                                                'Added to the list')));
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
                    MovieDetails['genres'].length != 0
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MovieDetails['genres'].length != 0 ? 25 : 0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: MovieDetails['genres'].length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color:
                                            Color.fromARGB(255, 138, 136, 136),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            MovieDetails['genres'][index]
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
                            ),
                          )
                        : Container(),
                    MovieDetails['spoken_languages'].length != 0
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
                                          MovieDetails['spoken_languages']
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
                                              MovieDetails['spoken_languages']
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
                    MovieDetails['overview'].toString() != ''
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
                                  child: Text('Description',
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
                                      MovieDetails['overview'].toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ),
                              ],
                            ),
                          )
                        : Container(),
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
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             playerpage(
                                              //               videos[index]['key'],
                                              //             ))),
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
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
                                                                        'images/default_wide.jpg',
                                                                        fit: BoxFit
                                                                            .fill,
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
                    Moviecredits.length != 0
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
                                    Moviecredits.length != 0
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
                                  height: Moviecredits.length != 0 ? 230 : 0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Moviecredits.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PeoplesPage(
                                                Moviecredits[index]['id']),
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
                                                            Moviecredits[index][
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
                                                      Moviecredits[index]
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
                                                      Moviecredits[index]
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
                    watchProvidersStream.length != 0
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
                                    itemCount: watchProvidersStream.length,
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
                                                            watchProvidersStream[
                                                                        index][
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
                                                    watchProvidersStream[index]
                                                        ['provider_name'],
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
                    watchProvidersRent.length != 0
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
                                    'Rent',
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
                                    itemCount: watchProvidersRent.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color:
                                              Color.fromARGB(255, 62, 61, 61),
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
                                                            watchProvidersRent[
                                                                        index][
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
                                                    watchProvidersRent[index]
                                                        ['provider_name'],
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
                    watchProvidersBuy.length != 0
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
                                    'Buy',
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
                                    itemCount: watchProvidersBuy.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          color:
                                              Color.fromARGB(255, 62, 61, 61),
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
                                                            watchProvidersBuy[
                                                                        index][
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
                                                    watchProvidersBuy[index]
                                                        ['provider_name'],
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 10, top: 10),
                      child: Text(
                          SimilarMovies.length != 0 ? 'Similar Movies' : '',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: SimilarMovies.length != 0 ? 280 : 0,
                      child: ListView.builder(
                          itemCount: SimilarMovies.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return Desctest(SimilarMovies[index]['id']);
                                }));
                              },
                              child: Container(
                                width: 170,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 170,
                                            height: 210,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://image.tmdb.org/t/p/original/" +
                                                      SimilarMovies[index]
                                                              ['poster_path']
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
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Text(
                                              SimilarMovies[index]['title'] !=
                                                      null
                                                  ? SimilarMovies[index]
                                                      ['title']
                                                  : "Movie",
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                SimilarMovies[index]
                                                            ['release_date'] !=
                                                        null
                                                    ? SimilarMovies[index]
                                                        ['release_date']
                                                    : "Movie",
                                                style: TextStyle(
                                                    color: Colors.white30)),
                                            Text(
                                              SimilarMovies[index][
                                                          'original_language'] !=
                                                      null
                                                  ? SimilarMovies[index]
                                                          ['original_language']
                                                      .toUpperCase()
                                                  : "Movie",
                                              style: TextStyle(
                                                  color: Colors.white38,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

String getTimeString(int value) {
  final int hour = value ~/ 60;
  final int minutes = value % 60;
  return '${hour.toString().padLeft(2, "0")} h ${minutes.toString().padLeft(2, "0")} m';
}
