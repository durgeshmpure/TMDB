import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/peoples_page.dart';
import 'package:flutter_application_1/screens/series_desc.dart';

import 'package:tmdb_api/tmdb_api.dart';
import 'desc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String message = '';
  bool noItems = true;
  List search = [];
  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';
  bool isSearchNull = false;
  loadMovies(String value) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    Map searchresults = await tmdbWithCustomLogs.v3.search.queryMulti(value);

    setState(() {
      search = searchresults['results'];
    });
  }

  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(right: 10.0, left: 10, top: 20, bottom: 10),
          child: TextField(
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: 17),
            onSubmitted: (value) async {
              await loadMovies(value);
              setState(() {
                if (search.length == 0) {
                  noItems = false;
                  message = 'No Results Found';
                } else {
                  noItems = true;
                  message = '';
                }
              });
            },
            decoration: InputDecoration(
                hoverColor: Colors.orange[400],
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search for Movie,Series,Actors',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
        ),
        noItems
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: search.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          if (search[index]['media_type'] == 'movie') {
                            return Desctest(search[index]['id']);
                          } else if (search[index]['media_type'] == 'tv') {
                            return SeriesDesc(search[index]['id']);
                          } else {
                            return PeoplesPage(search[index]['id']);
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: 100,
                                      child: search[index]['media_type']
                                                      .toString() ==
                                                  'movie' ||
                                              search[index]['media_type']
                                                      .toString() ==
                                                  'tv'
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "https://image.tmdb.org/t/p/original/" +
                                                      search[index]
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
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  "https://image.tmdb.org/t/p/original/" +
                                                      search[index]
                                                              ['profile_path']
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
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, right: 10, bottom: 10),
                                          child: Container(height:25,
                                            child: Text(
                                              search[index]['title']
                                                          .toString() !=
                                                      'null'
                                                  ? search[index]['title']
                                                      .toString()
                                                  : search[index]['name']
                                                      .toString(),
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            search[index]['media_type']
                                                        .toString() !=
                                                    'tv'
                                                ? search[index]['media_type']
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    search[index][
                                                                'media_type'] !=
                                                            'person'
                                                        ? Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.yellow,
                                                            size: 18,
                                                          )
                                                        : Container(),
                                                    search[index][
                                                                'media_type'] !=
                                                            'person'
                                                        ? Text(
                                                            search[index][
                                                                        'vote_average']
                                                                    .toString() +
                                                                '/10',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                        : Text(
                                                            'Known for ' +
                                                                search[index][
                                                                        'known_for_department']
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  width: 85,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      search[index]['media_type']
                                                                  .toString() ==
                                                              'movie'
                                                          ? search[index][
                                                                  'release_date']
                                                              .toString()
                                                          : search[index]['first_air_date']
                                                                      .toString() ==
                                                                  'null'
                                                              ? ''
                                                              : search[index][
                                                                      'first_air_date']
                                                                  .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0, top: 8),
                                          child: Text(
                                            search[index]['media_type'] !=
                                                    'person'
                                                ? search[index]
                                                        ['original_language']
                                                    .toString()
                                                    .toUpperCase()
                                                : search[index]['gender']
                                                            .toString() ==
                                                        '2'
                                                    ? 'Male'
                                                    : 'Female',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ),
                                        
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            color: Color.fromARGB(255, 32, 32, 32),
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Text(
                message,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
      ]),
    ));
  }
}
