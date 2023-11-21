import 'package:flutter/material.dart';

class Acne extends StatelessWidget {
  const Acne({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ringworm"),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
                padding: EdgeInsets.all(16),
                child: Image(image: AssetImage("assets/images/ringworm.jpeg"))),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Ringworm adalah infeksi kulit umum yang disebabkan oleh jamur, dengan gejala khas berupa ruam melingkar (berbentuk seperti cincin) yang biasanya berwarna merah dan gatal. Jamur yang menyebabkan infeksi ini dapat hidup di kulit, permukaan, dan barang-barang rumah tangga seperti pakaian, handuk, dan tempat tidur.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Jenis-Jenis Ringworm",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "\u2022 Ringworm of the scalp (tinea capitis). Ditandai dengan munculnya sisik di kulit kepala yang berkembang menjadi bercak-bercak yang gatal dan bersisik. Paling umum terjadi pada anak - anak.\n\u2022 Ringworm of the body (tinea corporis). Sering muncul sebagai bercak atau ruam dengan bentuk yang khas, yaitu seperti cincin bulat.\n\u2022 Jock itch (tinea cruris). Mengacu pada infeksi ringworm pada kulit di sekitar selangkangan, paha bagian dalam, dan bokong. Kondisi ini sering terjadi pada pria dan remaja laki-laki.\n\u2022 Athlete’s foot (tinea pedis). Nama lainnya adalah kutu air. Merupakan istilah untuk infeksi ringworm pada kaki. Sering dialami oleh orang yang sering bertelanjang kaki di tempat umum di mana infeksi dapat menyebar, seperti ruang ganti, kamar mandi, dan kolam renang.",
                  style: TextStyle(fontSize: 18),
                )),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Pengobatan untuk Ringworm",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Ringworm of the scalp memerlukan obat oral yang membutuhkan resep seperti griseofulvin (Gris-PEG) atau terbinafine. Obat kulit dan krim kulit antijamur yang dijual bebas di apotek mungkin direkomendasikan untuk digunakan juga. Produk ini umumnya mengandung klotrimazol, mikonazol, terbinafine, atau bahan terkait lainnya.",
                  style: TextStyle(fontSize: 18),
                )),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Selain resep obat, dokter biasanya menyarankan agar kamu merawat infeksi di rumah dengan cara:",
                  style: TextStyle(fontSize: 18),
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "\u2022 Mencuci seprai dan pakaian setiap hari selama infeksi untuk membantu mendisinfeksi lingkungan.\n\u2022 Mengeringkan tubuh secara menyeluruh setelah mandi.\n\u2022 Mengenakan pakaian longgar.\n\u2022 Mengobati semua area yang terinfeksi.",
                  style: TextStyle(fontSize: 18),
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
