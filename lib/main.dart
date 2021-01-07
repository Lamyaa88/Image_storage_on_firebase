import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;

void main() => runApp(new CameraApp());

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => new _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File image;
  File _image;
  String _uploadedFileURL;

  picker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore File Upload'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Selected Image'),
              _image != null
                  ? Image.asset(
                _image.path,
                height: 150,
              )
                  : Container(height: 150),
              _image == null
                  ? RaisedButton(
                child: Text('Choose File'),
                onPressed: chooseFile,
                color: Colors.cyan,
              )
                  : Container(),
              _image != null
                  ? RaisedButton(
                child: Text('Upload File'),
                onPressed: uploadFile,
                color: Colors.cyan,
              )
                  : Container(),
              _image != null
                  ? RaisedButton(
                child: Text('Clear Selection'),
                onPressed: () {},
              )
                  : Container(),
              Text('Uploaded Image'),
              _uploadedFileURL != null
                  ? Image.network(
                _uploadedFileURL,
                height: 150,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}
