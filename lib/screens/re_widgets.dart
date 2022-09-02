import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/seeall_page_movies.dart';
import 'package:flutter_application_1/screens/seeall_pages_series.dart';
import 'package:flutter_application_1/screens/series_desc.dart';

import 'desc_test.dart';

class listBuilderMovie extends StatefulWidget {
  List listTiles;
  String title;
  listBuilderMovie(this.listTiles, this.title);

  @override
  State<listBuilderMovie> createState() => _listBuilderMovieState();
}

class _listBuilderMovieState extends State<listBuilderMovie> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 10, bottom: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900)),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SeeAllPage(widget.listTiles, widget.title),
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
        Container(
          height: 280,
          child: ListView.builder(
              itemCount: widget.listTiles.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Desctest(widget.listTiles[index]['id']);
                    }));
                  },
                  child: Container(
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
                                      "https://image.tmdb.org/t/p/original/" +
                                          widget.listTiles[index]['poster_path']
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
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                  widget.listTiles[index]['title'] != null
                                      ? widget.listTiles[index]['title']
                                      : "Movie",
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text(
                                    widget.listTiles[index]['release_date'] !=
                                            null
                                        ? widget.listTiles[index]
                                            ['release_date']
                                        : "Movie",
                                    style: TextStyle(color: Colors.white30)),
                                Text(
                                  widget.listTiles[index]
                                              ['original_language'] !=
                                          null
                                      ? widget.listTiles[index]
                                              ['original_language']
                                          .toUpperCase()
                                      : "Movie",
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          )
                        ]),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class listBuilderSeries extends StatefulWidget {
  List listTiles;
  String title;
  listBuilderSeries(this.listTiles,this.title);

  @override
  State<listBuilderSeries> createState() => _listBuilderSeriesState();
}

class _listBuilderSeriesState extends State<listBuilderSeries> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 10, bottom: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900)),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SeeAllPageSeries(widget.listTiles, widget.title),
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
        Container(
                  height: 280,
                  child: ListView.builder(
                      itemCount: widget.listTiles.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SeriesDesc(widget.listTiles[index]['id']);
                            }));
                          },
                          child: Container(
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
                                              "https://image.tmdb.org/t/p/original/" +
                                                  widget.listTiles[index]
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
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                          widget.listTiles[index]['name'] != null
                                              ? widget.listTiles[index]['name']
                                              : "Movie",
                                          overflow: TextOverflow.fade,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            widget.listTiles[index]
                                                        ['first_air_date'] !=
                                                    null
                                                ? widget.listTiles[index]
                                                    ['first_air_date']
                                                : "Movie",
                                            style: TextStyle(
                                                color: Colors.white30)),
                                        Text(
                                          widget.listTiles[index]
                                                      ['original_language'] !=
                                                  null
                                              ? widget.listTiles[index]
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
                ),
      ],
    );
  }
}
