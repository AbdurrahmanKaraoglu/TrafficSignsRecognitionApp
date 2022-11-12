import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

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

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/tflite/converted_model.tflite",
      labels: "assets/tflite/labels.txt",
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
  }

  classifyImage(XFile image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 43, // Etiket sayısı
    );
    debugPrint("Label: ${output.toString()}");
    setState(() {
      _outputs = output;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 70, 156),
        centerTitle: true,
        title: const Text(
          'Trafik İşaretleri Tanıma Uygulaması',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
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
                    Container(
                      margin: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 19, 60, 94),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 19, 60, 94),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 0),
                          ),
                        ],
                      ),
                      child: _image == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/img1.png',
                                // 'assets/images/img2.jpg',
                                height: 300,
                                width: 300,
                                fit:  BoxFit.fill,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(_image!.path),
                                width: 300,
                                height: 300,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 224, 221, 221),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 19, 60, 94),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 19, 60, 94),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(2, 0),
                          ),
                        ],
                      ),
                      child: Text(
                        _outputs != null ? "${_outputs![0]["label"]}" : "Trafik işareti tanımlanamadı",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickImage,
        icon: const Icon(Icons.image),
        label: const Text("Galeriden Resim Seç"),
        foregroundColor: Colors.white,
      ),
    );
  }
}
