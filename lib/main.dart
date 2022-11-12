import 'package:flutter/material.dart';
import 'package:traffic_signs_recognition_app/open_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Signs Recognition App',

      theme: ThemeData(
    
        useMaterial3: true, 
        colorScheme:   ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
       ),
      home: const OpenGallery(),
    );
  }
}
