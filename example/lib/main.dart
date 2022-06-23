import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiCrop Image',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.yellow, primaryColor: Colors.yellow),
      home: const MyHomePage(title: 'Multi Crop Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile>? receivedFiles = [];
  List<File> croppedFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: croppedFiles.length,
          itemBuilder: (context, index) {
            return Container(
                height: 250,
                padding: const EdgeInsets.all(10.0),
                child: Image.file(
                  croppedFiles[index],
                  fit: BoxFit.fitWidth,
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chooseImage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void chooseImage() async {
    receivedFiles = await _picker.pickMultiImage();
    MultiImageCrop.startCropping(
        context: context,
        aspectRatio: 4 / 3,
        files: List.generate(
            receivedFiles!.length, (index) => File(receivedFiles![index].path)),
        callBak: (List<File> images) {
          setState(() {
            croppedFiles = images;
          });
        });
  }
}
