import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traffic_signs_recognition_app/open_gallery.dart';

class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 20, 70, 156),
        onPressed: () {
          Get.offAll(()=> const OpenGallery());
        },
        label: const Text(
          'İleri',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        icon: const Icon(
          Icons.skip_next,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/img2.jpg',
                  width: 300,
                  height: 400,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Trafik İşaretleri Tanıma Uygulamasına Hoş Geldiniz',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
