import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class Find extends StatefulWidget {
  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place to stay'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0,left: 20,right: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search by location or cost...',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('ads').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs
                      .where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final loc = doc['location'].toString().toLowerCase();
                    final cost = doc['cost'].toString().toLowerCase();
                    final searchText = _searchController.text.toLowerCase();

                    return name.contains(searchText) || loc.contains(searchText) || cost.contains(searchText);
                  })
                      .map((doc) {
                    return RoomContainer(
                      name: doc['name'],
                      loc: doc['location'],
                      con: doc['num'],
                      bedType: doc['bedType'],
                      details: doc['details'],
                      cost: doc['cost'],
                      imageUrls: 'images/'+doc['num'],
                    );
                  })
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoomContainer extends StatelessWidget {
  final String name;
  final String loc;
  final String con;
  final String bedType;
  final String details;
  final String cost;
  final String imageUrls;

  RoomContainer({
    required this.name,
    required this.loc,
    required this.con,
    required this.bedType,
    required this.details,
    required this.cost,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoomCarouselSlider(folderName: imageUrls),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Location: $loc',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Bed Type: $bedType',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Room Details: $details',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Rent: $cost per Night',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed:  () async {
                    print(con);
                    await launch('tel:' + '$con');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.black
                  ),
                  child: Text('Book Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoomCarouselSlider extends StatelessWidget {
  final String folderName;

  RoomCarouselSlider({required this.folderName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchImageUrls(folderName),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(left: 185.0,right: 185),
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 5,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error loading images');
        }
        return Container(
          height: 200,
          padding: EdgeInsets.only(bottom: 10),
          child: CarouselSlider(
            items: snapshot.data!.map((imageUrl) {
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _fetchImageUrls(String folderName) async {
    List<String> imageUrls = [];
    try {
      ListResult result = await FirebaseStorage.instance.ref().child(folderName).listAll();
      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
    return imageUrls;
  }
}
