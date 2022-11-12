import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class OpenGallery extends StatefulWidget {
  const OpenGallery({super.key});

  @override
  State<OpenGallery> createState() => _OpenGalleryState();
}

class _OpenGalleryState extends State<OpenGallery> {
  List<dynamic>? _outputs;
  XFile? _image;
  bool _loading = false;
  int color = 0xffc248bd;
  var imageResize;
  List? _output;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Scan Photo from Gallery',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
             
          ),
        ),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null ? Container() : Image.file(File(_image!.path)),

                    //Image.file(_image, color: Colors.grey, colorBlendMode: BlendMode.saturation),
                    const SizedBox(height: 20),
                    const Text("Sonuçlar:"),
                    _outputs != null
                        ? Text(
                            "Result: ${_outputs![0]["label"]}\nConfidence:${_outputs![0]["confidence"].toStringAsFixed(2)}\nİndex: ${_outputs![0]["index"]}",
                            style: TextStyle(
                              color: Color(color),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Container(),

                    // imageResize == null ? Container() : Image.file(imageResize),
                    // imageResize == null ? Container() : Image.memory(imageResize.readAsBytesSync()),
                    // imageResize == null ? Container() : Image.file(File(imageResize.path)),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickImage,
        icon: const Icon(Icons.remove_red_eye),
        label: const Text("Start"),
        foregroundColor: Colors.white,
  
      ),
    );
  }

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });

      classifyImage(_image!);
    // imageResize = ResizeImage(File(_image!.path), width: 224, height: 224);
    // _loading = false;
   
  }

  classifyImage(XFile image) async {
    //this function runs the model on the image

   
  
 

    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 43, //the amout of categories our neural network can predict
      threshold: 0.2,
      imageMean: 0.0,
      imageStd: 255.0,
      asynch: true,
    );
    debugPrint("Label: ${output.toString()}");
    setState(() {
      _outputs = output;
      _loading = false;
    });
  }

  Uint8List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  getRed(int pixel) {
    return (pixel >> 16) & 0xFF;
  }

  getGreen(int pixel) {
    return (pixel >> 8) & 0xFF;
  }

  getBlue(int pixel) {
    return pixel & 0xFF;
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/tflite/converted_model.tflite",
      labels: "assets/tflite/labels.txt",
    );
  }

  
}
