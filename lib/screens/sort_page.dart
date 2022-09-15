import 'package:flutter/material.dart';

class SortPage extends StatefulWidget {
  const SortPage({Key? key}) : super(key: key);

  @override
  State<SortPage> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
  int selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Sort'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sort By',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              RadioListTile(
                title: Text(
                  'Popularity',
                  style: TextStyle(color: Colors.white),
                ),
                value: 0,
                groupValue: selectedValue,
                onChanged: (value) => setState(() {
                  selectedValue = 0;
                }),
              ),
              RadioListTile(
                title: Text(
                  'Newest',
                  style: TextStyle(color: Colors.white),
                ),
                value: 1,
                groupValue: selectedValue,
                onChanged: (value) => setState(() {
                  selectedValue = 1;
                }),
              ),
              RadioListTile(activeColor: Colors.yellow,
                title: Text(
                  'Highest Rated',
                  style: TextStyle(color: Colors.white),
                ),
                value: 2,
                groupValue: selectedValue,
                onChanged: (value) => setState(() {
                  selectedValue = 2;
                }),
              ),
              RadioListTile(
                title: Text(
                  'Highest Voted',
                  style: TextStyle(color: Colors.white),
                ),
                value: 3,
                groupValue: selectedValue,
                onChanged: (value) => setState(() {
                  selectedValue = 3;
                }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff58BDB4),
                          minimumSize: Size.fromHeight(50)),
                      
                      child: Text(
                        'Update Sorting',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                      },
                    ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
