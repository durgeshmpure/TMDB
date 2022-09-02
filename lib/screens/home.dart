import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/search_page.dart';
import 'package:flutter_application_1/screens/series_page.dart';
import 'moviepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> tabs = [
    MoviePage(),SearchPage(),SeriesPage()
  ];

  int _index = 0;



  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: FloatingNavbar(
          onTap: (int val) => setState(() => _index = val),
          currentIndex: _index,
          items: [
            FloatingNavbarItem(icon: Icons.movie, title: 'Movies'),
            FloatingNavbarItem(icon: Icons.search,title: 'Search'),
            FloatingNavbarItem(icon: Icons.tv,title: 'Series'),
            

            
            
          ],
        ),
        backgroundColor: Colors.black,
        body: tabs[_index]);
  }
}
