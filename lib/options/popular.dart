import 'package:flutter/material.dart';
import 'package:staybnb/options/up.dart';

class Popular extends StatefulWidget {
  @override
  _PopularState createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  final List<String> places = [
    "Santoroni",
    "Paris",
    "Greece",
    "Paris",
    "Tokyo",
    "Greece",
    "Paris",
    "Greece",
    "Paris",
    "Tokyo",
  ];

  final List<String> images = [
    "images/santorini.jpg",
    'images/paris.jpg',
    "images/santorini.jpg",
    'images/paris.jpg',
    "images/tokyo.jpg",
    "images/santorini.jpg",
    'images/paris.jpg',
    "images/santorini.jpg",
    'images/paris.jpg',
    "images/tokyo.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Places"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Soon()));
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      places[index],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
