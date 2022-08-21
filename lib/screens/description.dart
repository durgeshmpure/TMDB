import 'package:flutter/material.dart';


class Description extends StatefulWidget {

String MovieName='';
String description ='';
String posterUrl ='';
String bannerurl ='';
double averagevotes=0.0;
String releasedate ='';
int movieID= 0;




  Description(Key? key,this.MovieName,this.description) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Column(
      children:[

      ]
    ) );
  }
}