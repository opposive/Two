import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class Twod {
  String number, price;

  Twod({required this.number, required this.price});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool textScanning = false;
  XFile? imageFile = null;
  String scannedText = "";
  List<Twod> scannedtextlist = <Twod>[];
  List<String> Scannedteslines = <String>[];
  int count = 0;


  void getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
      scannedText = "Error Occuring while scanning";
    }
  }

  void getRecognizedText(XFile image) async {
    // log(image);
    scannedtextlist = [];
    Scannedteslines = [];
    var inputImage = InputImage.fromFilePath(image.path);
    var TextDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await TextDetector.processImage(inputImage);
    await TextDetector.close();
    scannedText = '';
    List<String> numbers =[];

    // count = 0;
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        Scannedteslines.add(line.text);
        if(line.text.contains('-')) {
          var sparated = line.text.split('-');
            var number = sparated[0];
            var price = sparated[1];

            if(number.contains(',')){
               // = number.split(',');
              numbers.add(number.splitMapJoin(','));
            }
        }

        for(String number in numbers){

        }

        // scannedText = scannedText + line.text + ' line' + '\n';
        // for (TextElement words in line.elements) {
        //   int index = line.elements.indexOf(words);
        //   if (index % 2 != 0) {
        //     int indextwo = index - 1 as int;
        //     scannedtextlist?.add(Twod(
        //         number: line.elements.elementAt(indextwo).text,
        //         price: words.text));
        //     count++;
        //   } else {
        //     count++;
        //   }
        // }
      }
    }

    textScanning = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two D Scanner'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (textScanning) const CircularProgressIndicator(),
            if (!textScanning && imageFile == null)
              Padding(
                padding: EdgeInsets.all(40),
                child: Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey[300]!,
                ),
              ),
            if (imageFile != null)
              Padding(
                padding: EdgeInsets.all(40),
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image.file(
                    File(imageFile!.path),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shadowColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: () {
                      getImage();
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 30,
                          ),
                          Text('Gallery')
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shadowColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: () {},
                    child: Container(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          Text('Camera')
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            imageFile != null
                ? Container(
                    child: Center(
                      child: DataTable(columns: [
                        DataColumn(
                          label: Text('Number'),
                        ),
                        // DataColumn(
                        //   label: Text('Price'),
                        // ),
                      ], rows: [
                        for (String tdvar in Scannedteslines)
                          DataRow(cells: [
                            DataCell(Text(tdvar.toString())),
                            // DataCell(Text(tdvar.price.toString())),
                          ]),
                      ]),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Text('There is no read text'),
                    ),
                  ),
            // Container(
            //   child: Center(
            //     child: DataTable(columns: [
            //       DataColumn(
            //         label: Text('Number'),
            //       ),
            //       DataColumn(
            //         label: Text('Price'),
            //       ),
            //     ], rows: [
            //       for (String tdvar in scannedtextlist)
            //         DataRow(cells: [
            //           DataCell(Text(tdvar.number.toString())),
            //           // DataCell(Text(tdvar.price.toString())),
            //         ]),
            //     ]),
            //   ),
            // )
            //     : Container(
            //   child: Center(
            //     child: Text('There is no read text'),
            //   ),
            // ),

            // Container(
            //         child: Text(scannedText),
            //       )
            //     : Container(
            //         child: Center(
            //           child: Text('There is no read text'),
            //         ),
            //       ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }
}
