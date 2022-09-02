import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/screens/desc_test.dart';
import 'package:tmdb_api/tmdb_api.dart';

// ignore: must_be_immutable
class SeeAllPage extends StatefulWidget {
  List tiles = [];
  String listType = '';

  SeeAllPage(this.tiles, this.listType);

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final apikey = '18ae282b0af89a13697e609ae851dac1';
  final token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOGFlMjgyYjBhZjg5YTEzNjk3ZTYwOWFlODUxZGFjMSIsInN1YiI6IjYyZjRhZGI2ZmVhNmUzMDA5MTM2MGEwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_4JO4qLXgi6o-pTkEwDreERWQUtb9TxB-LZl6MLeWA';
  ScrollController scrollController = ScrollController();
  int page = 2;
  bool hasMore = true;
  List result = [];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetch();
      }
    });
    super.initState();
  }

  fetch() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));
    if (widget.listType == 'UpComing Movies') {
      Map trendingresult = await tmdbWithCustomLogs.v3.movies
          .getUpcoming(region: 'IN', page: page);
      result = trendingresult['results'];
    } else if (widget.listType == 'TopRated Movies') {
      Map trendingresult = await tmdbWithCustomLogs.v3.movies
          .getTopRated(region: 'IN', page: page);
      result = trendingresult['results'];
    } else if (widget.listType == 'In Theatres') {
      Map trendingresult = await tmdbWithCustomLogs.v3.movies
          .getNowPlaying(region: 'IN', page: page);
      result = trendingresult['results'];
    } else if (widget.listType == 'Popular Movies') {
      Map trendingresult = await tmdbWithCustomLogs.v3.movies
          .getPopular(region: 'IN', page: page);
      result = trendingresult['results'];
    } else if (widget.listType == 'Trending Movies') {
      Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending(
          mediaType: MediaType.movie, timeWindow: TimeWindow.day, page: page);
      result = trendingresult['results'];
    }
    setState(() {
      if (result.length != 0) {
        widget.tiles.addAll(result);
        page++;
      } else {
        hasMore = !hasMore;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.listType,
            style: TextStyle(color: Colors.white),
          )),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: widget.tiles.length + 1,
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.6,
            crossAxisCount: 2,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, index) => index < widget.tiles.length
              ? GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Desctest(widget.tiles[index]['id']),
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
                                        widget.tiles[index]['poster_path']
                                            .toString(),
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
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.tiles[index]['title'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 18,
                              ),
                              Text(
                                widget.tiles[index]['vote_average'].toString() +
                                    '/10',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text(
                                    widget.tiles[index]['release_date'] != null
                                        ? widget.tiles[index]['release_date']
                                        : "Movie",
                                    style: TextStyle(color: Colors.white30)),
                                Text(
                                  widget.tiles[index]['original_language'] !=
                                          null
                                      ? widget.tiles[index]['original_language']
                                          .toUpperCase()
                                      : "Movie",
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : hasMore
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Text(
                        'No Furthur data Available',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
        ),
      ),
    );
  }
}
