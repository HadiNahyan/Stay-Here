import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:staybnb/options/up.dart';

class Story extends StatelessWidget {
  final List<String> imageList = [
    'images/paris.jpg',
    'images/paris2.jpg',
    'images/paris3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Travellers Story"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 200),
                viewportFraction: 0.8,
              ),
              items: imageList.map((item) => Container(
                child: Center(
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              )).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/pro.jpg'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Injamam Tuhin",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Paris, France",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Paris is a great city"
                      "I stayed at Hotel Lafin for 2 night"
                      "It was My dream to Travel France and Paris. I'm Fully Satisfied with the service of the Hotel. It is Nearby Tower of Paris."
                      "They Serve fresh Food And Drinks. Hotel is very clean and the rent was also satisfying",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Soon()));
                      },
                          child: Text("Share Your Story")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
