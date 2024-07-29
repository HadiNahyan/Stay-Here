import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:staybnb/options/find.dart';

import 'options/up.dart';
class Reg extends StatelessWidget {
  final TextEditingController mail = TextEditingController();
  final TextEditingController num = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController passC = TextEditingController();
  String ml='';
  String ps='';
  String con='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: mail,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: num,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passC,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                ml=mail.text;
                ps=pass.text;
                con=num.text;
                createUsr(mail: ml,con: con,pass: ps);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Sign()));
              },
              child: Text('Register'),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Sign()));
              },
              child: Text(
                'Already have an account? Sign in here',
                style: TextStyle(
                  color: Colors.blue,
                 // decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future createUsr({
  required String con,
  required String mail,
  required String pass,
}) async {
  final docUsr= FirebaseFirestore.instance.collection('users').doc(mail);
  final json={
    'contact':con,
    'mail':mail,
    'pass':pass,
  };
  await docUsr.set(json);
}
class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
            ),
            SizedBox(height: 20.0),
           TextButton(
              onPressed: () async {
                String m=_emailController.text;
                String p= _passwordController.text;
                DocumentSnapshot ds =
                    await FirebaseFirestore.instance.collection('users').doc(m).get();
                // Cast the data to Map<String, dynamic>
                Map<String, dynamic>? data = ds.data() as Map<String, dynamic>?;
                // Check if the data is not null and contains the 'Pass' field
                if (m==data?['mail']&&p==data?['pass']) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>Admin(data?['contact'])));
                }
             else{
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                   content: Text('Email or password not matched')
               )
               );
              }
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Reg()));
              },
              child: Text(
                'Don\'t have an account? Register here',
                style: TextStyle(
                  color: Colors.blue,
                //  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Admin extends StatefulWidget {
  final String num;
  Admin(this.num);
  @override
  _AdminState createState() => _AdminState(num);
}

class _AdminState extends State<Admin> {
  final String num;
  _AdminState(this.num);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Ad'),
      ),
      body: Center(child: Column(
        children: [
          TextButton(onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>Ad(num)));
          }, child: Text("Create Ad"),),
          TextButton(onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>Ad(num)));
          }, child: Text("Update Ad"),),
          TextButton(onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>Soon()));
          }, child: Text("Delete Ad"),),
        ],
      ),
      )
    );
  }
}

class Ad extends StatefulWidget {
  final String num;
  Ad(this.num);
  @override
  State<Ad> createState() => _AdState(num);
}

class _AdState extends State<Ad> {
  final String num;
  _AdState(this.num);
  @override
  Widget build(BuildContext context) {
    final nC = TextEditingController();
    final lC = TextEditingController();
    final cC = TextEditingController();
    final dC=TextEditingController();
    String drpVal="Single Bed";
    String name='';
    String loc='';
    String bed='';
    String cost='';
    String det='';
    String pn='';
    return Scaffold(
        appBar: AppBar(
          title: Text("Please Fill up the form"),
        ),
        body:  ListView(
          padding: EdgeInsets.only(left: 2,right: 2,top:20),
          children: [
            Padding(padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 15),child: TextField(
              controller: nC,
              decoration: InputDecoration(
                labelText: "Apartment/Hotel Name",
                border: OutlineInputBorder(),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 15),child: TextField(
              controller: lC,
              decoration: InputDecoration(
                labelText: "Full Address",
                hintText: "Street,Area,City,Country",
                border: OutlineInputBorder(),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 2,left: 5,right: 5),
                child:DropdownButtonFormField(
                  value: drpVal,
                  onChanged: (val){
                    drpVal=val as String;
                  },
                  decoration: InputDecoration(
                      labelText: "Bed Type",
                      prefixIcon: Icon(Icons.bed_sharp),
                      border: UnderlineInputBorder()
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Single Bed"),value: 'Single Bed',
                    ),
                    DropdownMenuItem(child: Text("Double Bed"),value: 'Double Bed',
                    ),
                  ],
                  icon: Icon(Icons.arrow_circle_down_sharp,),
                )
            ),
            Padding(padding: EdgeInsets.only(bottom: 3,left: 5,right: 5),child: TextField(
              controller: cC,
              decoration: InputDecoration(
                labelText: "Nightly rent",
                border: OutlineInputBorder(),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 15,left: 5,right: 5),child: TextField(
              controller: dC,
              decoration: InputDecoration(
                labelText: "Short Details",
                hintText: "2 Bed rooms,1 bath, air conditioned",
                border: OutlineInputBorder(),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 3,left: 5,right: 5),child: TextField(
              decoration: InputDecoration(
                labelText: "Phone number",
                enabled: false,
                hintText: num,
                border: OutlineInputBorder(),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.all(5),child: TextButton(
              child: Text("Select at least 3 images"),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Pic(num)));
              },
            ),),
            Padding(padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        name=nC.text;
                        loc=lC.text;
                        cost=cC.text;
                        det=dC.text;
                        bed=drpVal;
                        pn=num;
                        createAd(bed: bed,cost: cost,det: det,loc: loc,nam: name,pn: pn);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>Ad(num)));
                      },
                      child: Text("Post Ad"),
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }
}

Future createAd({
  required String nam,
  required String loc,
  required String cost,
  required String det,
  required String bed,
  required String pn,
}) async {
  final docUsr1= FirebaseFirestore.instance.collection('ads').doc(pn);
  final json={
    'name':nam,
    'num':pn,
    'bedType':bed,
    'cost':cost,
    'location':loc,
    'details':det,
  };
  await docUsr1.set(json);
}
