import 'package:flutter/material.dart';


class WatchListProvider with ChangeNotifier {
  List<String> movieIds = [];
  List<String> seriesIds = [];

  bool isMovieInWatchlist(String movieId) {
    bool c = movieIds.contains(movieId);
    print(c);
    return c;
  }

  bool isSeriesInWatchlist(String seriesId) {
    bool c = seriesIds.contains(seriesId);
    print(c);
    return c;
  }

  void getPreferences(List<String> movieId) {
    movieIds = movieId;
    notifyListeners();
  }
   void getPreferencesSeries(List<String> seriesId) {
    seriesIds = seriesId;
    notifyListeners();
  }

  void addMovietoList(String MovieId) {
    if (movieIds.contains(MovieId)) {
    } else {
      movieIds.add(MovieId);
    }

    notifyListeners();
  }

  void removeMovietoList(String MovieId) {
    if (movieIds.contains(MovieId)) {
      movieIds.remove(MovieId);
    } else {}
    notifyListeners();
  }

  void addSeriestoList(String SeriesId) {
    if (seriesIds.contains(SeriesId)) {
    } else {
      seriesIds.add(SeriesId);
    }
    notifyListeners();
  }

  void removeSeriestoList(String SeriesId) {
    if (seriesIds.contains(SeriesId)) {
      seriesIds.remove(SeriesId);
    } else {}
    notifyListeners();
  }
}
