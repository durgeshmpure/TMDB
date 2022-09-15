import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/desc_test.dart';
import 'package:flutter_application_1/screens/sort_page.dart';
import 'package:http/http.dart' as http;

class GenrePage extends StatefulWidget {
  String genreId = '';
  String genreName = '';

  GenrePage(this.genreId, this.genreName);

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool hasMore = true;

  List genrespecificMovies = [];
  loadGenreMovies(String genreId) async {
    var endpoint = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=18ae282b0af89a13697e609ae851dac1&language=en-US&region=IN&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$genreId&with_watch_monetization_types=flatrate');
    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    setState(() {
      page++;
      if (body['results'].length == 0) {
        hasMore = false;
      }
      genrespecificMovies.addAll(body['results']);
    });
    print(genrespecificMovies.length);
  }

  @override
  void initState() {
    loadGenreMovies(widget.genreId);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadGenreMovies(widget.genreId);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.genreName),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              
              Expanded(
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: genrespecificMovies.length + 1,
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.6,
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemBuilder: (context, index) => index <
                            genrespecificMovies.length
                        ? GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Desctest(
                                      genrespecificMovies[index]['id']),
                                )),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 250,
                                        width: 200,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/original/" +
                                                  genrespecificMovies[index]
                                                          ['poster_path']
                                                      .toString(),
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              LinearProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        genrespecificMovies[index]['title'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 18,
                                        ),
                                        Text(
                                          genrespecificMovies[index]
                                                      ['vote_average']
                                                  .toString() +
                                              '/10',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        children: [
                                          Text(
                                              genrespecificMovies[index]
                                                          ['release_date'] !=
                                                      null
                                                  ? genrespecificMovies[index]
                                                      ['release_date']
                                                  : "Movie",
                                              style: TextStyle(
                                                  color: Colors.white30)),
                                          Text(
                                            genrespecificMovies[index]
                                                        ['original_language'] !=
                                                    null
                                                ? genrespecificMovies[index]
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
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: hasMore
                                ? CircularProgressIndicator()
                                : Text(
                                    'No more data to load',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          )),
              ),
            ],
          ),
        ));
  }
}
