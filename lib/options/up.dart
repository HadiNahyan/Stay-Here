import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
class Pic extends StatefulWidget {
  final String num;
  Pic(this.num);
  @override
  _PicState createState() => _PicState(num);
}

class _PicState extends State<Pic> {
  final String num;
  _PicState(this.num);
  List<File> _images = []; // List to store selected images
  final picker = ImagePicker();
  bool _isUploading = false;

  Future getImages() async {
    final pickedFiles = await picker.getMultiImage(
      imageQuality: 70,
      maxHeight: 800,
      maxWidth: 800,
    );

    setState(() {
      if (pickedFiles != null) {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      } else {
        print('No images selected.');
      }
    });
  }

  Future uploadImages() async {
    setState(() {
      _isUploading = true;
    });

    // Generate a unique ID for the group of images
    String groupId = num;

    for (File image in _images) {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$groupId/${Path.basename(image.path)}');
      firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() {
        Navigator.pop(context);
        // print('File Uploaded: ${image.path}');
        // // Store image metadata (e.g., download URL) in database
        // storeImageData(groupId, storageReference.fullPath);
      });
    }

    setState(() {
      _isUploading = false;
    });
  }

  void storeImageData(String groupId, String imagePath) {
    setState(() {
      imPath=imagePath;
    });
    // You can store the image metadata (e.g., download URL) in Firebase Realtime Database or Firestore
    // Here, we print the image path for demonstration purposes
    print('Image Path: $imagePath');
    // You can save the image metadata (e.g., download URL) to the database here
  }
  String imPath="Upload";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: _images.isEmpty
            ? Text('No images selected.')
            : Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    _images[index],
                    height: 200,
                  );
                },
              ),
            ),
            _isUploading
                ? CircularProgressIndicator()
                : TextButton(
              onPressed: uploadImages,
              child: Text(imPath),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImages,
        tooltip: 'Pick Images',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class Soon extends StatelessWidget {
  const Soon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Future Update"),
      ),
      body: Center(child: Text("Coming Soon!!",style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrangeAccent
      ),),) ,
    );
  }
}
