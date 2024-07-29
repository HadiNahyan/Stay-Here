import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:staybnb/options/popular.dart';
import 'package:staybnb/options/story.dart';
import 'package:staybnb/reg.dart';
import 'options/find.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stay Bnb',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: Text("StayBNB",style: TextStyle(color: Colors.blueAccent),),centerTitle: true,actions: [
        IconButton(onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>Sign()));
        }, icon: Icon(Icons.perm_identity_sharp,color: Colors.black,))
      ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.house_outlined),text: "Find Places",),
              Tab(icon: Icon(Icons.maps_home_work_rounded),text: "Popular Places",),
              Tab(icon: Icon(Icons.history_edu_sharp),text: "Travelers Stroy",),
              Tab(icon: Icon(Icons.local_offer),text: "Online Packages",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Find(),
            Popular(),
            Story(),
            Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Exclusive Offers \nAre Coming Soon !!",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
