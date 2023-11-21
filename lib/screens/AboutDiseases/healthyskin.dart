import 'package:flutter/material.dart';

class Healthy extends StatelessWidget {
  const Healthy({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Healthy"),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
                padding: EdgeInsets.all(16),
                child: Image(image: AssetImage("assets/images/heatlth.jpg"))),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "\"Keindahan kulit adalah Anda dapat memengaruhinya baik dari dalam maupun luar,\" kata dokter kulit Doris Day, MD, penulis Forget the Facelift: Turn Back the Clock with a Revolutionary Program for Ageless Skin.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Apa yang kamu makan itu penting?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Mengonsumsi banyak buah dan sayuran yang kaya antioksidan baik untuk seluruh tubuh Anda, termasuk kulit Anda. \n\nAntioksidan seperti beta-karoten dan vitamin C, E, dan A dapat mengurangi kerusakan yang disebabkan oleh molekul tidak stabil yang dikenal sebagai radikal bebas. Molekul ini dapat merusak sel kulit dan menyebabkan tanda-tanda penuaan.\n\nSalah satu cara terbaik untuk mendapatkan lebih banyak antioksidan adalah dengan mengonsumsi berbagai macam buah dan sayuran. \n \"Saya merekomendasikan untuk mengonsumsi sebanyak mungkin variasi dan warna dalam makanan Anda,\" kata Day. \"Cobalah mengemil blueberry, stroberi, jeruk bali, kangkung, bayam, dan berbagai jenis paprika.\" Ia juga menyarankan untuk menambahkan sedikit pasta tomat, yang mengandung antioksidan yang disebut likopen, ke dalam tumisan sayuran, nasi merah, atau quinoa. .\n Ide bagus lainnya adalah mengisi keranjang belanjaan Anda dengan makanan yang tinggi asam lemak omega-3, termasuk salmon liar, sarden, telur yang diperkaya, dan kenari.\n \"Asam lemak omega-3 membantu menjaga bagian luar atas tetap utuh. lapisan kulit kuat dan utuh sehingga racun dan polutan eksternal dapat dicegah,” kata dokter kulit David E. Bank, MD, direktur Pusat Dermatologi, Kosmetik, dan Bedah Laser di Mount Kisco, N.Y.",
                  style: TextStyle(fontSize: 16),
                )),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
    ));
  }
}
