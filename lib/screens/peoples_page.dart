import 'package:url_launcher/url_launcher.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/series_desc.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'desc_test.dart';

// ignore: must_be_immutable
class PeoplesPage extends StatefulWidget {
  int creditID;
  PeoplesPage(this.creditID);

  @override
  State<PeoplesPage> createState() => _PeoplesPageState();
}

class _PeoplesPageState extends State<PeoplesPage> {
  Map creditInfo = {};
  List castMovies = [];
  List iMages = [];
  Map iDs = {};

  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';

  loadCreditInfo() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map CreditInforesult =
        await tmdbWithCustomLogs.v3.people.getDetails(widget.creditID);
    Map castMoviesresult =
        await tmdbWithCustomLogs.v3.people.getCombinedCredits(widget.creditID);
    Map iMagesResult =
        await tmdbWithCustomLogs.v3.people.getImages(widget.creditID);
    Map idresults =
        await tmdbWithCustomLogs.v3.people.getExternalIds(widget.creditID);

    setState(() {
      creditInfo = CreditInforesult;
      castMovies = castMoviesresult['cast'];
      iMages = iMagesResult['profiles'];
      iDs = idresults;
    });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    loadCreditInfo();
    print(widget.creditID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          creditInfo['name'].toString() == 'null'
              ? ''
              : creditInfo['name'].toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: creditInfo['name'].toString() != 'null'
          ? SafeArea(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 170,
                                width: 120,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/original/" +
                                          creditInfo['profile_path'].toString(),
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          LinearProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'images/default_user.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                height: 170,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        creditInfo['name'].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        creditInfo['gender'] == 2
                                            ? 'Male'
                                            : 'Female',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Birthday:',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              creditInfo['birthday'].toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                            'Birthplace:',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            creditInfo['place_of_birth']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Known for:',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            creditInfo['known_for_department']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 10, bottom: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: Row(
                            children: [
                              iDs['instagram_id'].toString() != 'null'
                                  ? iDs['instagram_id'].toString() != ''
                                      ? GestureDetector(
                                          onTap: () {
                                            _launchInBrowser(Uri.parse(
                                                'https://instagram.com/' +
                                                    iDs['instagram_id']
                                                        .toString()));
                                          },
                                          child: Container(
                                              height: 30,
                                              width: 40,
                                              child: Image.asset(
                                                  'images/instagram-icon.png')),
                                        )
                                      : Container()
                                  : Container(),
                              iDs['facebook_id'].toString() != 'null'
                                  ? iDs['facebook_id'].toString() != ''
                                      ? GestureDetector(
                                          onTap: () {
                                            _launchInBrowser(Uri.parse(
                                                'https://facebook.com/' +
                                                    iDs['facebook_id']
                                                        .toString()));
                                          },
                                          child: Container(
                                              height: 50,
                                              width: 40,
                                              child: Image.asset(
                                                  'images/facebook-icon.png')),
                                        )
                                      : Container()
                                  : Container(),
                              iDs['twitter_id'].toString() != 'null'
                                  ? iDs['twitter_id'].toString() != ''
                                      ? GestureDetector(
                                          onTap: () {
                                            _launchInBrowser(Uri.parse(
                                                'https://twitter.com/' +
                                                    iDs['twitter_id']
                                                        .toString()));
                                          },
                                          child: Container(
                                              height: 27,
                                              width: 40,
                                              child: Image.asset(
                                                  'images/twitter-icon.png')),
                                        )
                                      : Container()
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, bottom: 10, top: 10),
                              child: Text('Biograpghy',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: ExpandableText(
                                  expandText: 'Show more',
                                  collapseText: 'Show less',
                                  maxLines: 4,
                                  creditInfo['biography'].toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10, top: 10),
                        child: Text('Images',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: iMages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 150,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/original/" +
                                          iMages[index]['file_path'].toString(),
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10, top: 10),
                        child: Text(
                            'More Movies & Series by ' +
                                creditInfo['name'].toString(),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                            itemCount: castMovies.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return castMovies[index]['media_type'] ==
                                            'movie'
                                        ? Desctest(castMovies[index]['id'])
                                        : SeriesDesc(castMovies[index]['id']);
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
                                                        castMovies[index]
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
                                                castMovies[index]
                                                            ['media_type'] ==
                                                        'movie'
                                                    ? castMovies[index]['title']
                                                    : castMovies[index]['name'],
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
                                                  castMovies[index]
                                                              ['media_type'] ==
                                                          'movie'
                                                      ? castMovies[index]
                                                          ['release_date']
                                                      : castMovies[index]
                                                          ['first_air_date'],
                                                  style: TextStyle(
                                                      color: Colors.white30)),
                                              Text(
                                                castMovies[index][
                                                            'original_language'] !=
                                                        null
                                                    ? castMovies[index][
                                                            'original_language']
                                                        .toUpperCase()
                                                    : "Movie",
                                                style: TextStyle(
                                                    color: Colors.white38,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        ),
                                        Container(
                                          height: 18,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Text(
                                                castMovies[index]
                                                            ['media_type'] ==
                                                        'movie'
                                                    ? 'Movie'
                                                    : 'Series',
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    color: Colors.white30)),
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
